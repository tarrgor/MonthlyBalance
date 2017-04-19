//
//  NSDateExtensionTests.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 09.11.15.
//  Copyright © 2015 Karrmarr Software. All rights reserved.
//

import XCTest

@testable import MonthlyBalance

class NSDateExtensionTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testDayMonthAndYear_IsSetCorrectly() {
    let calendar = Calendar.current
    var components = DateComponents()
    components.day = 27
    components.month = 4
    components.year = 2015
    
    let date: Date = calendar.date(from: components)!
    
    XCTAssert(date.day() == 27)
    XCTAssert(date.month() == 4)
    XCTAssert(date.year() == 2015)
  }
  
  func testNextDateWithDayOfWeek_IsReturnedCorrectly() {
    let calendar = Calendar.current
    var components = DateComponents()
    components.day = 27
    components.month = 4
    components.year = 2015
    
    let date: Date = calendar.date(from: components)!
    
    let nextDate = date.nextDateWithDayOfMonth(20)
    
    XCTAssert(nextDate.day() == 20)
    XCTAssert(nextDate.month() == 5)
    XCTAssert(nextDate.year() == 2015)
  }
  
  func testDateWithDayMonthYear_ReturnsCorrectDate() {
    let date = Date.dateWithDay(24, month: 12, year: 2014)
    
    XCTAssert(date?.day() == 24)
    XCTAssert(date?.month() == 12)
    XCTAssert(date?.year() == 2014)
  }
}
