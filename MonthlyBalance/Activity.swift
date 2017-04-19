//
//  Activity.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 08.11.15.
//  Copyright © 2015 Karrmarr Software. All rights reserved.
//

import Foundation
import CoreData

@objc(Activity)
class Activity: NSManagedObject {

  func update() {
    CoreDataManager.sharedManager().saveContext()
  }
 
  func delete() {
    let mutableActivities = NSMutableOrderedSet(orderedSet: self.account!.activities!)
    mutableActivities.remove(self)
    self.account!.activities = mutableActivities
    
    CoreDataManager.sharedManager().managedObjectContext.delete(self)
    CoreDataManager.sharedManager().saveContext()
  }
  
  func isInCurrentMonth() -> Bool {
    guard let activityDate = self.date else {
      return false
    }
    
    let currentDate = Date()
    let currentMonth = currentDate.month()
    let currentYear = currentDate.year()
    let activityMonth = activityDate.month()
    let activityYear = activityDate.year()
    
    return currentMonth == activityMonth && currentYear == activityYear
  }
  
  func isInCurrentYear() -> Bool {
    guard let activityDate = self.date else {
      return false
    }

    let currentDate = Date()
    let currentYear = currentDate.year()
    let activityYear = activityDate.year()
    
    return currentYear == activityYear
  }
}
