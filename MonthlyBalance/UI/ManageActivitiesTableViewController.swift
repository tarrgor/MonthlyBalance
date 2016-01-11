//
//  ManageActivitiesTableViewController.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 11.01.16.
//  Copyright © 2016 Karrmarr Software. All rights reserved.
//

import UIKit

class ManageActivitiesTableViewController : UITableViewController {
  var account: Account?
  
  var selectedIndexPath: NSIndexPath?
  
  var swipeToDelete = false
  
  override func viewDidLoad() {
    // Get selected account
    self.account = self.settings?.selectedAccount
    
    // Setup autolayout for tableView
    tableView.estimatedRowHeight = 78.0
    tableView.rowHeight = UITableViewAutomaticDimension
    
    // Setup navigationBar
    self.navigationItem.title = kTitleManageActivities
    self.navigationItem.leftItemsSupplementBackButton = false
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: kTitleBackButton, style: UIBarButtonItemStyle.Plain, target: self, action: "backButtonPressed:")
    self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
    self.navigationItem.rightBarButtonItem = editButtonItem()
    self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
  }
  
  func backButtonPressed(sender: UIBarButtonItem) {
    self.navigationController?.popToRootViewControllerAnimated(true)
  }
  
  // MARK: - TableView DataSource
  
  override func setEditing(editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    if self.editing && !self.swipeToDelete {
      self.tableView.beginUpdates()
      
      let indexPath = NSIndexPath(forRow: self.account!.activities!.count, inSection: 0)
      self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
      self.tableView.endUpdates()
      
      self.tableView.setEditing(editing, animated: animated)
    } else {
      self.tableView.beginUpdates()
      
      let indexPath = NSIndexPath(forRow: self.account!.activities!.count, inSection: 0)
      self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
      self.tableView.endUpdates()
      
      self.tableView.setEditing(editing, animated: animated)
    }
  }
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let account: Account = self.account, activities = account.activities {
      return self.editing ? activities.count + 1 : activities.count
    }
    return 0
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if self.editing && indexPath.row >= self.account?.activities?.count {
      let cell = tableView.dequeueReusableCellWithIdentifier("NewActivityCell")
      cell?.selectedBackgroundView = UIView(frame: cell!.frame)
      cell?.selectedBackgroundView?.backgroundColor = UIColor(hex: kColorSelectedTableViewCell)
      return cell!
    }
    
    let cell = tableView.dequeueReusableCellWithIdentifier("ActivityCell") as! ActivityTableViewCell
    let activities = self.account!.activities!
    let activity: Activity = activities[indexPath.row] as! Activity
    
    cell.titleLabel.text = activity.title!
    cell.timeLabel.text = "Time"
    if let amount = activity.amount {
      cell.amountLabel.amount = Double(amount)
    } else {
      cell.amountLabel.text = "ERR!"
    }
    
    return cell
  }
  
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
      if let activity = self.account?.activities?[indexPath.row] as? Activity {
        //activity.delete()
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
      }
    } else if editingStyle == .Insert {
      //openEventDialog(indexPath)
    }
  }
  
  override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
    if indexPath.row >= self.account?.activities?.count {
      return .Insert
    }
    return .Delete
  }
  
  override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
    if self.editing && indexPath.row >= self.account?.activities?.count {
      return indexPath
    }
    return nil
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
    if indexPath.row >= self.account?.activities?.count && editing {
      self.tableView(tableView, commitEditingStyle: .Insert, forRowAtIndexPath: indexPath)
    }
  }
  
  override func tableView(tableView: UITableView, willBeginEditingRowAtIndexPath indexPath: NSIndexPath) {
    self.swipeToDelete = true
  }
  
  override func tableView(tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath) {
    self.swipeToDelete = false
  }
  
  /*
  func openEventDialog(indexPath: NSIndexPath) {
    if let editEventTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("EditEventTableViewController")
      as? EditEventTableViewController {
        editEventTableViewController.delegate = self
        
        self.selectedIndexPath = indexPath
        self.presentViewController(editEventTableViewController, animated: true, completion: nil)
    }
  }
  */
}
