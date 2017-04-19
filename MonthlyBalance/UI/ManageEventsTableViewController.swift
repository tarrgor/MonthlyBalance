//
//  ManageEventsTableViewController.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 06.01.16.
//  Copyright © 2016 Karrmarr Software. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class ManageEventsTableViewController : UITableViewController {
  
  var account: Account?
  
  var selectedIndexPath: IndexPath?

  var swipeToDelete = false
  
  override func viewDidLoad() {
    // Get selected account
    self.account = self.settings?.selectedAccount
    
    // Setup autolayout for tableView
    tableView.estimatedRowHeight = 78.0
    tableView.rowHeight = UITableViewAutomaticDimension
    
    // Setup navigationBar
    setupNavigationItemWithTitle(kTitleManageEvents, backButtonSelector: #selector(backButtonPressed(_:)), rightItem: editButtonItem)
  }

  func backButtonPressed(_ sender: UIBarButtonItem) {
    self.navigationController?.popToRootViewController(animated: true)
  }
  
  // MARK: - TableView DataSource
  
  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    if self.isEditing && !self.swipeToDelete {
      self.tableView.beginUpdates()

      let indexPath = IndexPath(row: self.account!.scheduledEvents!.count, section: 0)
      self.tableView.insertRows(at: [indexPath], with: .automatic)
      self.tableView.endUpdates()

      self.tableView.setEditing(editing, animated: animated)
    } else {
      self.tableView.beginUpdates()

      let indexPath = IndexPath(row: self.account!.scheduledEvents!.count, section: 0)
      self.tableView.deleteRows(at: [indexPath], with: .automatic)
      self.tableView.endUpdates()

      self.tableView.setEditing(editing, animated: animated)
    }
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let account: Account = self.account, let events = account.scheduledEvents {
      return self.isEditing ? events.count + 1 : events.count
    }
    return 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if self.isEditing && indexPath.row >= self.account?.scheduledEvents?.count {
      let cell = tableView.dequeueReusableCell(withIdentifier: "NewEventCell")
      cell?.selectedBackgroundView = UIView(frame: cell!.frame)
      cell?.selectedBackgroundView?.backgroundColor = UIColor(hex: kColorTableViewSelection)
      return cell!
    }
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! EventTableViewCell
    let events = self.account!.scheduledEvents!
    let event: ScheduledEvent = events[indexPath.row] as! ScheduledEvent
    
    cell.titleLabel.text = event.title!
    cell.scheduleLabel.text = "Every \(event.dayOfMonth!) all \(event.interval!) months."
    cell.nextLabel.text = "\(event.nextDueDate!.day()).\(event.nextDueDate!.month()).\(event.nextDueDate!.year())"
    if let amount = event.amount {
      cell.amountLabel.amount = Double(amount)
    } else {
      cell.amountLabel.text = "ERR!"
    }
    cell.selectedBackgroundView = UIView(frame: cell.frame)
    cell.selectedBackgroundView?.backgroundColor = UIColor(hex: kColorTableViewSelection)
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      if let event = self.account?.scheduledEvents?[indexPath.row] as? ScheduledEvent {
        event.delete()
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
      }
    } else if editingStyle == .insert {
      openEventDialog(indexPath)
    }
  }
  
  override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
    if indexPath.row >= self.account?.scheduledEvents?.count {
      return .insert
    }
    return .delete
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.tableView.deselectRow(at: indexPath, animated: false)
    if indexPath.row >= self.account?.scheduledEvents?.count && isEditing {
      self.tableView(tableView, commit: .insert, forRowAt: indexPath)
    } else {
      if let event = self.account?.scheduledEvents?[indexPath.row] {
        openEventDialog(indexPath, event: event as? ScheduledEvent)
      }
    }
  }

  override func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
    self.swipeToDelete = true
  }

  override func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
    self.swipeToDelete = false
  }

  func openEventDialog(_ indexPath: IndexPath, event: ScheduledEvent? = nil) {
    let editEventFormViewController = EditEventFormViewController()
    
//      editEventTableViewController.onSave = editEventViewControllerDidSaveEvent
//      editEventTableViewController.event = event
          
    self.selectedIndexPath = indexPath
    self.navigationController?.pushViewController(editEventFormViewController, animated: true)
  }
}

extension ManageEventsTableViewController {
  func editEventViewControllerDidSaveEvent(_ viewController: EditEventTableViewController, event: ScheduledEvent?) {
    if let _ = event, let indexPath = self.selectedIndexPath {
      if viewController.mode == .add {
        self.tableView.insertRows(at: [indexPath], with: .automatic)
      } else {
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
      }
      self.selectedIndexPath = nil
    }
  }
}

