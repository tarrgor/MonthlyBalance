//
//  ManageActivitiesTableViewController.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 11.01.16.
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


class ManageActivitiesTableViewController : UITableViewController {
  var account: Account?
  
  var selectedIndexPath: IndexPath?
  
  var swipeToDelete = false
  
  override func viewDidLoad() {
    // Get selected account
    self.account = self.settings?.selectedAccount
    
    // Setup autolayout for tableView
    tableView.estimatedRowHeight = 66.0
    tableView.rowHeight = UITableViewAutomaticDimension
    
    // Setup navigationBar
    setupNavigationItemWithTitle(kTitleManageActivities, backButtonSelector: #selector(backButtonPressed(_:)), rightItem: editButtonItem)
  }
  
  func backButtonPressed(_ sender: UIBarButtonItem) {
    self.navigationController?.popToRootViewController(animated: true)
  }
  
  // MARK: - TableView DataSource
  
  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    if self.isEditing && !self.swipeToDelete {
      self.tableView.beginUpdates()
      
      let indexPath = IndexPath(row: self.account!.activities!.count, section: 0)
      self.tableView.insertRows(at: [indexPath], with: .automatic)
      self.tableView.endUpdates()
      
      self.tableView.setEditing(editing, animated: animated)
    } else {
      self.tableView.beginUpdates()
      
      let indexPath = IndexPath(row: self.account!.activities!.count, section: 0)
      self.tableView.deleteRows(at: [indexPath], with: .automatic)
      self.tableView.endUpdates()
      
      self.tableView.setEditing(editing, animated: animated)
    }
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let account: Account = self.account, let activities = account.activities {
      return self.isEditing ? activities.count + 1 : activities.count
    }
    return 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if self.isEditing && indexPath.row >= self.account?.activities?.count {
      let cell = tableView.dequeueReusableCell(withIdentifier: "NewActivityCell")
      cell?.selectedBackgroundView = UIView(frame: cell!.frame)
      cell?.selectedBackgroundView?.backgroundColor = UIColor(hex: kColorTableViewSelection)
      return cell!
    }
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell") as! ActivityTableViewCell
    let activities = self.account!.activities!
    let activity: Activity = activities[indexPath.row] as! Activity
    
    cell.titleLabel.text = activity.title!
    cell.timeLabel.text = activity.date!.displayText
    if let amount = activity.amount {
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
      if let activity = self.account?.activities?[indexPath.row] as? Activity {
        self.account?.recalculateTotalsForUpdateActivity(activity, newAmount: 0.0, newDate: activity.date!)
        activity.delete()
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
      }
    } else if editingStyle == .insert {
      openActivityDialog(indexPath)
    }
  }
  
  override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
    if indexPath.row >= self.account?.activities?.count {
      return .insert
    }
    return .delete
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.tableView.deselectRow(at: indexPath, animated: false)
    if indexPath.row >= self.account?.activities?.count && isEditing {
      self.tableView(tableView, commit: .insert, forRowAt: indexPath)
    } else {
      if let activity = self.account?.activities?[indexPath.row] {
        openActivityDialog(indexPath, activity: activity as? Activity)
      }
    }
  }
  
  override func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
    self.swipeToDelete = true
  }
  
  override func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
    self.swipeToDelete = false
  }
  
  func openActivityDialog(_ indexPath: IndexPath, activity: Activity? = nil) {
    let editActivityFormViewController = EditActivityFormViewController()
    editActivityFormViewController.onSave = editActivityViewControllerDidSaveEvent
    editActivityFormViewController.activity = activity

    self.selectedIndexPath = indexPath
    self.navigationController?.pushViewController(editActivityFormViewController, animated: true)
  }
}

extension ManageActivitiesTableViewController {
  func editActivityViewControllerDidSaveEvent(_ viewController: EditActivityFormViewController, activity: Activity?) {
    if let _ = activity, let indexPath = self.selectedIndexPath {
      
      if viewController.mode == .add {
        self.tableView.insertRows(at: [indexPath], with: .automatic)
      } else {
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
      }
      self.selectedIndexPath = nil
      
    }
  }
}


