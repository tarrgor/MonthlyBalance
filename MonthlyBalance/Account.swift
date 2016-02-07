//
//  Account.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 08.11.15.
//  Copyright © 2015 Karrmarr Software. All rights reserved.
//

import Foundation
import CoreData

@objc(Account)
class Account: NSManagedObject {

  var sortedActivitiesByTitle: [Activity] {
    guard let activities = self.activities else { return [] }
    
    let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
    let sortDescriptors = [ sortDescriptor ]
    
    return activities.sortedArrayUsingDescriptors(sortDescriptors) as! [Activity]
  }
  
  var sortedActivitiesByDate: [Activity] {
    guard let activities = self.activities else { return [] }
    
    let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
    let sortDescriptors = [ sortDescriptor ]
    
    return activities.sortedArrayUsingDescriptors(sortDescriptors) as! [Activity]
  }
  
  func latestActivities(count: Int) -> [Activity] {
    let sorted = sortedActivitiesByDate
    let subArray: [Activity] = Array(sorted.suffix(count))
    return subArray
  }
  
  static func create(name: String) -> Account? {
    let account: Account? = NSEntityDescription.insertNewObjectForEntityForName(kAccountEntity, inManagedObjectContext: CoreDataManager.sharedManager().managedObjectContext) as? Account
    if account != nil {
      account!.name = name
      account!.balanceTotal = 0.0
      account!.balanceCurrentMonth = 0.0
      account!.balanceCurrentYear = 0.0
      account!.lastUpdated = NSDate()
      CoreDataManager.sharedManager().saveContext()
    }
    return account
  }
  
  static func findAll() -> [Account] {
    return fetchAccounts(nil)
  }
  
  static func findByName(name: String) -> [Account] {
    return fetchAccounts(NSPredicate(format: "name == %@", name))
  }
  
  func addActivityForDate(date: NSDate, title: String, icon: String, amount: Double) -> Activity? {
    let activity: Activity? = NSEntityDescription.insertNewObjectForEntityForName("Activity", inManagedObjectContext: CoreDataManager.sharedManager().managedObjectContext) as? Activity
    if activity != nil {
      activity!.date = date
      activity!.title = title
      activity!.icon = icon
      activity!.amount = amount
      activity!.account = self
      
      adjustBalancesForActivity(activity!)
      
      self.lastUpdated = NSDate()
      
      CoreDataManager.sharedManager().saveContext()
    }
    return activity
  }
  
  func addEventWithTitle(title: String, icon: String, recurring: Bool, dayOfMonth: Int, interval: Int,
    amount: Double) -> ScheduledEvent? {
    let event: ScheduledEvent? = NSEntityDescription.insertNewObjectForEntityForName("ScheduledEvent", inManagedObjectContext: CoreDataManager.sharedManager().managedObjectContext) as? ScheduledEvent
    if event != nil {
      event!.recurring = recurring
      event!.title = title
      event!.icon = icon
      event!.dayOfMonth = dayOfMonth
      event!.interval = interval
      event!.amount = amount
      event!.account = self
      event!.nextDueDate = NSDate().nextDateWithDayOfMonth(dayOfMonth)
      CoreDataManager.sharedManager().saveContext()
    }
    return event
  }
  
  func delete() {
    let context: NSManagedObjectContext = CoreDataManager.sharedManager().managedObjectContext
    context.deleteObject(self)
    CoreDataManager.sharedManager().saveContext()
  }
  
  func updateData() {
    let lastUpdateMonth = self.lastUpdated?.month()
    let lastUpdateYear = self.lastUpdated?.year()
    let currentDate = NSDate()
    let currentMonth = currentDate.month()
    let currentYear = currentDate.year()
    
    // Check if month has changed since last update
    if currentMonth != lastUpdateMonth || currentYear != lastUpdateYear {
      // reset currentMonth-balance
      self.balanceCurrentMonth = 0.0
    }
    // Check if year has changed since last update
    if currentYear != lastUpdateYear {
      self.balanceCurrentYear = 0.0
    }
    
    // Check if there were any events due since the last update and apply them
    // to the account
    if let events = self.scheduledEvents {
      events.enumerateObjectsUsingBlock({ event, index, _ in
        let currentEvent = event as! ScheduledEvent
        if currentEvent.due {
          // apply the event to the account
          currentEvent.applyToAccount()
          
          if !(currentEvent.recurring as! Bool) {
            currentEvent.delete()
          }
        }
      })
    }
    
    self.lastUpdated = NSDate()
    CoreDataManager.sharedManager().saveContext()
  }
  
  func recalculateTotalsForUpdateActivity(activity: Activity, newAmount: Double, newDate: NSDate) {
    let difference = newAmount - Double(activity.amount!)
    
    self.balanceTotal = NSNumber(double: self.balanceTotal!.doubleValue + difference)

    if activity.isInCurrentMonth() {
      self.balanceCurrentMonth = NSNumber(double: self.balanceCurrentMonth!.doubleValue - activity.amount!.doubleValue)
    }
    if newDate.isInCurrentMonth() {
      self.balanceCurrentMonth = NSNumber(double: self.balanceCurrentMonth!.doubleValue + newAmount)
    }
    
    if activity.isInCurrentYear() {
      self.balanceCurrentYear = NSNumber(double: self.balanceCurrentYear!.doubleValue - activity.amount!.doubleValue)
    }
    if newDate.isInCurrentYear() {
      self.balanceCurrentYear = NSNumber(double: self.balanceCurrentYear!.doubleValue + newAmount)
    }
  }
  
  // MARK: - Private methods
  
  private func adjustBalancesForActivity(activity: Activity) {
    self.balanceTotal = NSNumber(double: self.balanceTotal!.doubleValue + activity.amount!.doubleValue)
    if activity.isInCurrentMonth() {
      self.balanceCurrentMonth = NSNumber(double: self.balanceCurrentMonth!.doubleValue + activity.amount!.doubleValue)
    }
    if activity.isInCurrentYear() {
      self.balanceCurrentYear = NSNumber(double: self.balanceCurrentYear!.doubleValue + activity.amount!.doubleValue)
    }
  }
  
  private static func fetchAccounts(predicate: NSPredicate?) -> [Account] {
    let request = NSFetchRequest(entityName: kAccountEntity)
    if predicate != nil {
      request.predicate = predicate!
    }
    let results = try! CoreDataManager.sharedManager().managedObjectContext.executeFetchRequest(request)
    return results as! [Account]
  }
}








