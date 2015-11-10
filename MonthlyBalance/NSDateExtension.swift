//
//  NSDateExtension.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 08.11.15.
//  Copyright © 2015 Karrmarr Software. All rights reserved.
//

import Foundation

extension NSDate {
  
  func year() -> Int {
    let calendar = NSCalendar.currentCalendar()
    return calendar.component(NSCalendarUnit.Year, fromDate: self)
  }

  func month() -> Int {
    let calendar = NSCalendar.currentCalendar()
    return calendar.component(NSCalendarUnit.Month, fromDate: self)
  }
  
  func day() -> Int {
    let calendar = NSCalendar.currentCalendar()
    return calendar.component(NSCalendarUnit.Day, fromDate: self)
  }
  
  func nextDateWithDayOfMonth(dayOfMonth: Int) -> NSDate {
    let calendar = NSCalendar.currentCalendar()
    let components = NSDateComponents()
    components.day = dayOfMonth
    let nextDate = calendar.nextDateAfterDate(self, matchingComponents: components, options: NSCalendarOptions.MatchNextTime)
    return nextDate!
  }
  
  static func dateWithDay(day: Int, month: Int, year: Int) -> NSDate? {
    let calendar = NSCalendar.currentCalendar()
    let components = NSDateComponents()
    components.day = day
    components.month = month
    components.year = year
    return calendar.dateFromComponents(components)
  }
}