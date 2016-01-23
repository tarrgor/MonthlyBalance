//
//  NSDateExtension.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 08.11.15.
//  Copyright © 2015 Karrmarr Software. All rights reserved.
//

import Foundation

let ONE_DAY: NSTimeInterval = NSTimeInterval(60*60*24)

extension NSDate {
  
  var displayText: String {
    var result: String = NSDateFormatter.localizedStringFromDate(self, dateStyle: .ShortStyle, timeStyle: .NoStyle)
    
    let currentDate = NSDate()
    let difference = currentDate.differenceInDaysToDate(self)
    if difference == 0 {
      result = "Today"
    } else if difference < 0 && difference >= -3 {
      if difference == -1 {
        result = "Yesterday"
      } else {
        result = "\(abs(difference)) days ago"
      }
    } else if difference > 0 && difference <= 3 {
      if difference == 1 {
        result = "Tomorrow"
      } else {
        result = "In \(abs(difference)) days"
      }
    }
    
    return result
  }
  
  func differenceInDaysToDate(date: NSDate) -> Int {
    let calendar = NSCalendar.currentCalendar()
    
    var earlierDate = self.earlierDate(date)
    let laterDate = self.laterDate(date)
    let factor: Int = earlierDate == self ? 1 : -1
    
    earlierDate = calendar.startOfDayForDate(earlierDate)
    
    let timeInterval = laterDate.timeIntervalSinceDate(earlierDate)
    let timeInDays = Int(timeInterval / ONE_DAY)
    
    return timeInDays * factor
  }
  
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
  
  func isInCurrentMonth() -> Bool {
    let currentDate = NSDate()
    let currentMonth = currentDate.month()
    let currentYear = currentDate.year()
    
    return self.month() == currentMonth && self.year() == currentYear
  }
  
  func isInCurrentYear() -> Bool {
    let currentDate = NSDate()
    let currentYear = currentDate.year()
    
    return self.year() == currentYear
  }

}