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
  
  // MARK: - Initialization
  
  override func viewDidLoad() {
    self.navigationItem.title = kTitleManageAccounts
    self.navigationItem.leftItemsSupplementBackButton = false
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: kTitleBackButton, style: UIBarButtonItemStyle.Plain, target: self, action: "backButtonPressed:")
    self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addButtonPressed:")
    self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
  }
  
  // MARK: - Actions
  
  func backButtonPressed(sender: UIBarButtonItem) {
    self.navigationController?.popToRootViewControllerAnimated(true)
  }
  
  func addButtonPressed(sender: UIBarButtonItem) {
    Account.create("Test")
    self.accounts = Account.findAll()
    tableView.reloadData()
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
  }
}