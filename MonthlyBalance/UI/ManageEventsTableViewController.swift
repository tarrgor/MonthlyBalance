//
//  ManageEventsTableViewController.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 06.01.16.
//  Copyright © 2016 Karrmarr Software. All rights reserved.
//

import UIKit

class ManageEventsTableViewController : UITableViewController {
  
  var account: Account?
  
  override func viewDidLoad() {
    // Get selected account
    self.account = self.settings?.selectedAccount
    
    // Setup autolayout for tableView
    tableView.estimatedRowHeight = 78.0
    tableView.rowHeight = UITableViewAutomaticDimension
    
    // Setup navigationBar
    self.navigationItem.title = kTitleManageEvents
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
    self.tableView.setEditing(editing, animated: animated)

    let indexPath = NSIndexPath(forRow: self.account!.scheduledEvents!.count, inSection: 0)
    if self.editing {
      self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    } else {
      self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
  }
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let account: Account = self.account, events = account.scheduledEvents {
      return self.editing ? events.count + 1 : events.count
    }
    return 0
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if self.editing && indexPath.row >= self.account?.scheduledEvents?.count {
      let cell = tableView.dequeueReusableCellWithIdentifier("NewEventCell")
      cell?.selectedBackgroundView = UIView(frame: cell!.frame)
      cell?.selectedBackgroundView?.backgroundColor = UIColor(hex: kColorSelectedTableViewCell)
      return cell!
    }
    
    let cell = tableView.dequeueReusableCellWithIdentifier("EventCell") as! EventTableViewCell
    let events = self.account!.scheduledEvents!
    let event: ScheduledEvent = events.allObjects[indexPath.row] as! ScheduledEvent
    
    cell.titleLabel.text = event.title!
    cell.scheduleLabel.text = "Every \(event.dayOfMonth!) all \(event.interval!) months."
    cell.nextLabel.text = "\(event.nextDueDate!.day()).\(event.nextDueDate!.month()).\(event.nextDueDate!.year())"
    cell.amountLabel.text = String(event.amount!)
    
    return cell
  }
  
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    
  }
  
  override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
    if self.editing && indexPath.row >= self.account?.scheduledEvents?.count {
      return .Insert
    }
    return .Delete
  }
  
  override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
    if self.editing && indexPath.row >= self.account?.scheduledEvents?.count {
      return indexPath
    }
    return nil
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    addDummyEvent(indexPath)
    self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
  }
  
  func addDummyEvent(indexPath: NSIndexPath) {
    if let editEventTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("EditEventTableViewController") {
      
      self.presentViewController(editEventTableViewController, animated: true) {
        
      }
    }
    
    /*
    self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    */
  }
}
