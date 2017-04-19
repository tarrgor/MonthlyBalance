//
//  ScheduledEvent.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 08.11.15.
//  Copyright © 2015 Karrmarr Software. All rights reserved.
//

import Foundation
import CoreData

@objc(ScheduledEvent)
class ScheduledEvent: NSManagedObject {

  var due: Bool {
    let currentDate = Date()
    let comparison = currentDate.compare(self.nextDueDate! as Date)
    return comparison == ComparisonResult.orderedDescending
  }

  @discardableResult
  func applyToAccount() -> Bool {
    if !self.due || self.account == nil {
      return false
    }
    
    self.account!.addActivityForDate(self.nextDueDate!, title: self.title!, icon: self.icon!, amount: self.amount!.doubleValue)
    if self.recurring! as! Bool {
      self.nextDueDate = self.nextDueDate?.nextDateWithDayOfMonth(self.dayOfMonth!.intValue)
    } else {
      self.nextDueDate = nil
    }
    
    return true
  }
  
  func delete() {
    let mutableEvents = NSMutableOrderedSet(orderedSet: self.account!.scheduledEvents!)
    mutableEvents.remove(self)
    self.account!.scheduledEvents = mutableEvents

    CoreDataManager.sharedManager().managedObjectContext.delete(self)
    CoreDataManager.sharedManager().saveContext()
  }
  
  func update() {
    CoreDataManager.sharedManager().saveContext()
  }
}
