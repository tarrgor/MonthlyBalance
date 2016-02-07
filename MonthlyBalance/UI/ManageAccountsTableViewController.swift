//
//  ManageAccountViewController.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 04.12.15.
//  Copyright © 2015 Karrmarr Software. All rights reserved.
//

import UIKit

class ManageAccountsTableViewController : UITableViewController {
  
  var accounts: [Account] = Account.findAll()
  var selectedAccountIndex = 0
  
  var accountManagementDelegate: AccountManagementDelegate?
  
  // MARK: - Initialization
  
  override func viewDidLoad() {
    let addButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addButtonPressed:")
    setupNavigationItemWithTitle(kTitleManageAccounts, backButtonSelector: "backButtonPressed:", rightItem: addButtonItem)
  }
  
  // MARK: - Actions
  
  func backButtonPressed(sender: UIBarButtonItem) {
    self.navigationController?.popToRootViewControllerAnimated(true)
  }
  
  func addButtonPressed(sender: UIBarButtonItem) {
    guard let createAccountViewController = self.storyboard?.instantiateViewControllerWithIdentifier(kIdCreateAccountViewController) as? CreateAccountViewController
      else {
        showAlertWithTitle("ERROR", message: "There was an internal error while trying to display the 'Create Account' screen.")
        return
    }

    createAccountViewController.onCreateAccount = { viewController, account in
      self.accounts.append(account)

      delay(400) {
        let indexPath = NSIndexPath(forRow: self.accounts.count - 1, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
      }
    }
    
    self.navigationController?.pushViewController(createAccountViewController, animated: true)
  }
  
  // MARK: TableView methods

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.accounts.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(kIdAccountCell) as! AccountTableViewCell
    
    cell.accountNameLabel.text = self.accounts[indexPath.row].name!
    cell.balanceLabel.text = String(self.accounts[indexPath.row].balanceCurrentMonth!)
    cell.selectedBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: cell.bounds.size.height))
    cell.selectedBackgroundView?.backgroundColor = UIColor(hex: kColorTableViewSelection)
    
    if indexPath.row == self.selectedAccountIndex {
      cell.checkmarkImageView.image = UIImage(named: kImageNameCheckmarkIcon)
    } else {
      cell.checkmarkImageView.image = nil
    }
    
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    self.selectedAccountIndex = indexPath.row
    tableView.reloadData()
    self.accountManagementDelegate?.didChangeAccountSelection(self.accounts[self.selectedAccountIndex])
  }
  
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    
    if editingStyle == .Delete {
      let accountToDelete: Account = self.accounts[indexPath.row]
      self.showConfirmationDialogWithTitle("ATTENTION!", message: "Do you really want to delete account \(accountToDelete.name!)") {
        action in
        accountToDelete.delete()
        self.accounts.removeAtIndex(indexPath.row)
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
      }
    }
  }
}