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
    
    return activities.sortedArray(using: sortDescriptors) as! [Activity]
  }
  
  var sortedActivitiesByDate: [Activity] {
    guard let activities = self.activities else { return [] }
    
    let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
    let sortDescriptors = [ sortDescriptor ]
    
    return activities.sortedArray(using: sortDescriptors) as! [Activity]
  }
  
  func latestActivities(_ count: Int) -> [Activity] {
    let sorted = sortedActivitiesByDate
    let subArray: [Activity] = Array(sorted.suffix(count))
    return subArray
  }
  
  static func create(_ name: String) -> Account? {
    let account: Account? = NSEntityDescription.insertNewObject(forEntityName: kAccountEntity, into: CoreDataManager.sharedManager().managedObjectContext) as? Account
    if account != nil {
      account!.name = name
      account!.balanceTotal = 0.0
      account!.balanceCurrentMonth = 0.0
      account!.balanceCurrentYear = 0.0
      account!.lastUpdated = Date()
      CoreDataManager.sharedManager().saveContext()
    }
    return account
  }
  
  static func findAll() -> [Account] {
    return fetchAccounts(nil)
  }
  
  static func findByName(_ name: String) -> [Account] {
    return fetchAccounts(NSPredicate(format: "name == %@", name))
  }
  
  @discardableResult
  func addActivityForDate(_ date: Date, title: String, icon: String, amount: Double) -> Activity? {
    let activity: Activity? = NSEntityDescription.insertNewObject(forEntityName: "Activity", into: CoreDataManager.sharedManager().managedObjectContext) as? Activity
    if activity != nil {
      activity!.date = date
      activity!.title = title
      activity!.icon = icon
      activity!.amount = amount as NSNumber
      activity!.account = self
      
      adjustBalancesForActivity(activity!)
      
      self.lastUpdated = Date()
      
      CoreDataManager.sharedManager().saveContext()
    }
    return activity
  }
  
  func addEventWithTitle(_ title: String, icon: String, recurring: Bool, dayOfMonth: Int, interval: Int,
    amount: Double) -> ScheduledEvent? {
    let event: ScheduledEvent? = NSEntityDescription.insertNewObject(forEntityName: "ScheduledEvent", into: CoreDataManager.sharedManager().managedObjectContext) as? ScheduledEvent
    if event != nil {
      event!.recurring = recurring as NSNumber
      event!.title = title
      event!.icon = icon
      event!.dayOfMonth = dayOfMonth as NSNumber
      event!.interval = interval as NSNumber
      event!.amount = amount as NSNumber
      event!.account = self
      event!.nextDueDate = Date().nextDateWithDayOfMonth(dayOfMonth)
      CoreDataManager.sharedManager().saveContext()
    }
    return event
  }
  
  func delete() {
    let context: NSManagedObjectContext = CoreDataManager.sharedManager().managedObjectContext
    context.delete(self)
    CoreDataManager.sharedManager().saveContext()
  }
  
  func updateData() {
    let lastUpdateMonth = self.lastUpdated?.month()
    let lastUpdateYear = self.lastUpdated?.year()
    let currentDate = Date()
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
      events.enumerateObjects({ event, index, _ in
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
    
    self.lastUpdated = Date()
    CoreDataManager.sharedManager().saveContext()
  }
  
  func recalculateTotalsForUpdateActivity(_ activity: Activity, newAmount: Double, newDate: Date) {
    let difference = newAmount - Double(activity.amount!)
    
    self.balanceTotal = NSNumber(value: self.balanceTotal!.doubleValue + difference as Double)

    if activity.isInCurrentMonth() {
      self.balanceCurrentMonth = NSNumber(value: self.balanceCurrentMonth!.doubleValue - activity.amount!.doubleValue as Double)
    }
    if newDate.isInCurrentMonth() {
      self.balanceCurrentMonth = NSNumber(value: self.balanceCurrentMonth!.doubleValue + newAmount as Double)
    }
    
    if activity.isInCurrentYear() {
      self.balanceCurrentYear = NSNumber(value: self.balanceCurrentYear!.doubleValue - activity.amount!.doubleValue as Double)
    }
    if newDate.isInCurrentYear() {
      self.balanceCurrentYear = NSNumber(value: self.balanceCurrentYear!.doubleValue + newAmount as Double)
    }
  }
  
  // MARK: - Private methods
  
  fileprivate func adjustBalancesForActivity(_ activity: Activity) {
    self.balanceTotal = NSNumber(value: self.balanceTotal!.doubleValue + activity.amount!.doubleValue as Double)
    if activity.isInCurrentMonth() {
      self.balanceCurrentMonth = NSNumber(value: self.balanceCurrentMonth!.doubleValue + activity.amount!.doubleValue as Double)
    }
    if activity.isInCurrentYear() {
      self.balanceCurrentYear = NSNumber(value: self.balanceCurrentYear!.doubleValue + activity.amount!.doubleValue as Double)
    }
  }
  
  fileprivate static func fetchAccounts(_ predicate: NSPredicate?) -> [Account] {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: kAccountEntity)
    if predicate != nil {
      request.predicate = predicate!
    }
    let results = try! CoreDataManager.sharedManager().managedObjectContext.fetch(request)
    return results as! [Account]
  }
}








