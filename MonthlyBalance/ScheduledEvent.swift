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
    let currentDate = NSDate()
    let comparison = currentDate.compare(self.nextDueDate!)
    return comparison == NSComparisonResult.OrderedDescending
  }

  func applyToAccount() -> Bool {
    if !self.due || self.account == nil {
      return false
    }
    
    self.account!.addActivityForDate(self.nextDueDate!, title: self.title!, icon: self.icon!, amount: self.amount!.doubleValue)
    if self.recurring! as Bool {
      self.nextDueDate = self.nextDueDate?.nextDateWithDayOfMonth(self.dayOfMonth!.integerValue)
    } else {
      self.nextDueDate = nil
    }
    
    return true
  }
  
  func delete() {
    let mutableEvents = NSMutableOrderedSet(orderedSet: self.account!.scheduledEvents!)
    mutableEvents.removeObject(self)
    self.account!.scheduledEvents = mutableEvents

    CoreDataManager.sharedManager().managedObjectContext.deleteObject(self)
    CoreDataManager.sharedManager().saveContext()
  }
}
