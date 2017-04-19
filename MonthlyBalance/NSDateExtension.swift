//
//  NSDateExtension.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 08.11.15.
//  Copyright © 2015 Karrmarr Software. All rights reserved.
//

import Foundation

let ONE_DAY: TimeInterval = TimeInterval(60*60*24)

extension Date {
  
  var displayText: String {
    var result: String = DateFormatter.localizedString(from: self, dateStyle: .short, timeStyle: .none)
    
    let currentDate = Date()
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
  
  func differenceInDaysToDate(_ date: Date) -> Int {
    let calendar = Calendar.current
    
    var earlierDate = (self as NSDate).earlierDate(date)
    let laterDate = (self as NSDate).laterDate(date)
    let factor: Int = earlierDate == self ? 1 : -1
    
    earlierDate = calendar.startOfDay(for: earlierDate)
    
    let timeInterval = laterDate.timeIntervalSince(earlierDate)
    let timeInDays = Int(timeInterval / ONE_DAY)
    
    return timeInDays * factor
  }
  
  func year() -> Int {
    let calendar = Calendar.current
    return (calendar as NSCalendar).component(NSCalendar.Unit.year, from: self)
  }

  func month() -> Int {
    let calendar = Calendar.current
    return (calendar as NSCalendar).component(NSCalendar.Unit.month, from: self)
  }
  
  func day() -> Int {
    let calendar = Calendar.current
    return (calendar as NSCalendar).component(NSCalendar.Unit.day, from: self)
  }
  
  func nextDateWithDayOfMonth(_ dayOfMonth: Int) -> Date {
    let calendar = Calendar.current
    var components = DateComponents()
    components.day = dayOfMonth
    let nextDate = (calendar as NSCalendar).nextDate(after: self, matching: components, options: NSCalendar.Options.matchNextTime)
    return nextDate!
  }
  
  static func dateWithDay(_ day: Int, month: Int, year: Int) -> Date? {
    let calendar = Calendar.current
    var components = DateComponents()
    components.day = day
    components.month = month
    components.year = year
    return calendar.date(from: components)
  }
  
  func isInCurrentMonth() -> Bool {
    let currentDate = Date()
    let currentMonth = currentDate.month()
    let currentYear = currentDate.year()
    
    return self.month() == currentMonth && self.year() == currentYear
  }
  
  func isInCurrentYear() -> Bool {
    let currentDate = Date()
    let currentYear = currentDate.year()
    
    return self.year() == currentYear
  }

}
