//
//  ManageAccountViewController.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 04.12.15.
//  Copyright © 2015 Karrmarr Software. All rights reserved.
//

import UIKit

typealias ManageAccountsOnChangeSelection = (Account) -> ()

class ManageAccountsTableViewController : UITableViewController {
  
  var accounts: [Account] = Account.findAll()
  var selectedAccountIndex = 0
  
  var onChangeSelection: ManageAccountsOnChangeSelection?
  
  // MARK: - Initialization
  
  override func viewDidLoad() {
    let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ManageAccountsTableViewController.addButtonPressed(_:)))
    setupNavigationItemWithTitle(kTitleManageAccounts, backButtonSelector: #selector(backButtonPressed(_:)), rightItem: addButtonItem)
  }
  
  // MARK: - Actions
  
  func backButtonPressed(_ sender: UIBarButtonItem) {
    self.navigationController?.popToRootViewController(animated: true)
  }
  
  func addButtonPressed(_ sender: UIBarButtonItem) {
    let createAccountViewController = CreateAccountFormViewController()
    createAccountViewController.onCreateAccount = { viewController, account in
      self.accounts.append(account)

      delay(400) {
        let indexPath = IndexPath(row: self.accounts.count - 1, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
      }
    }
    
    self.navigationController?.pushViewController(createAccountViewController, animated: true)
  }
  
  // MARK: TableView methods

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.accounts.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: kIdAccountCell) as! AccountTableViewCell
    
    cell.accountNameLabel.text = self.accounts[indexPath.row].name!
    cell.balanceLabel.text = String(describing: self.accounts[indexPath.row].balanceCurrentMonth!)
    cell.selectedBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: cell.bounds.size.height))
    cell.selectedBackgroundView?.backgroundColor = UIColor(hex: kColorTableViewSelection)
    
    if indexPath.row == self.selectedAccountIndex {
      cell.checkmarkImageView.image = UIImage(named: kImageNameCheckmarkIcon)
    } else {
      cell.checkmarkImageView.image = nil
    }
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.selectedAccountIndex = indexPath.row
    // TODO reloadData??
    tableView.reloadData()
    
    if let callback = self.onChangeSelection {
      callback(self.accounts[self.selectedAccountIndex])
    }
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    
    if editingStyle == .delete {
      let accountToDelete: Account = self.accounts[indexPath.row]
      self.showConfirmationDialogWithTitle("ATTENTION!", message: "Do you really want to delete account \(accountToDelete.name!)") {
        action in
        accountToDelete.delete()
        self.accounts.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
      }
    }
  }
}
