//
//  CoreDataManagerTests.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 08.11.15.
//  Copyright © 2015 Karrmarr Software. All rights reserved.
//

import XCTest

@testable import MonthlyBalance

class CoreDataManagerTests: XCTestCase {
  var coreDataManager: CoreDataManager!
  
  override func setUp() {
    super.setUp()
    
    CoreDataManager.testMode = true
    self.coreDataManager = CoreDataManager.sharedManager()
  }
  
  override func tearDown() {
    if !self.coreDataManager.deleteDatabase() {
      XCTFail("Database could not be deleted for the test.")
    }

    super.tearDown()
  }
  
  func testCreateAccount_AccountIsSavedCorrectly() {
    let acct = Account.create("TestAccount")
    
    XCTAssertNotNil(acct)
    
    let testAccts = Account.findByName("TestAccount")
    
    XCTAssert(testAccts.count == 1)
  }
  
  func testAddActivityToAccount_ActivityIsSavedCorrectly() {
    let acct = Account.create("TestAccount")
    
    XCTAssertNotNil(acct)

    let activity = acct!.addActivityForDate(NSDate(), title: "TestActivity", icon: "Default", amount: 50.0)
    
    XCTAssertNotNil(activity)

    let testAccts = Account.findByName("TestAccount")
    
    XCTAssert(testAccts.count == 1)
    XCTAssert(testAccts[0].activities!.count == 1)
    
    let testActivity = testAccts[0].activities!.allObjects[0]
    XCTAssert(testActivity.title == "TestActivity")
  }
  
  func testCreateScheduledEvent_EventIsSavedCorrectly() {
    let acct = Account.create("TestAccount")
    
    XCTAssertNotNil(acct)
    
    let event = acct!.addEventWithTitle("EventTitle", icon: "Default", recurring: true,
      dayOfMonth: 15, interval: 1, amount: 50.0)
    
    XCTAssertNotNil(event)
    XCTAssert(acct?.scheduledEvents?.count == 1)
    
    let testAccts = Account.findByName("TestAccount")
    
    XCTAssert(testAccts.count == 1)
    XCTAssert(testAccts[0].scheduledEvents!.count == 1)
    
    let testEvent = testAccts[0].scheduledEvents!.allObjects[0]
    XCTAssert(testEvent.title == "EventTitle")
  }
  
  func testAccountBalances_CalculatedCorrectlyAfterActivityAddedForCurrentDate() {
    let acct = Account.create("TestAccount")
    
    XCTAssertNotNil(acct)
    
    acct!.addActivityForDate(NSDate(), title: "TestDeposit", icon: "Default", amount: 35.0)
    
    XCTAssert(acct!.balanceTotal == 35.0)
    XCTAssert(acct!.balanceCurrentMonth == 35.0)
    XCTAssert(acct!.balanceCurrentYear == 35.0)
  }

  func testAccountBalances_CalculatedCorrectlyAfterActivityAddedWithDateInNextMonth() {
    let acct = Account.create("TestAccount")
    
    XCTAssertNotNil(acct)
    
    let calendar = NSCalendar.currentCalendar()
    let currentDate = NSDate()
    let activityDate = currentDate.dateByAddingTimeInterval(NSTimeInterval(60 * 60 * 24 * 40)) // 40 days
    let currentYear = calendar.components(NSCalendarUnit.Year, fromDate: currentDate)
    let activityYear = calendar.components(NSCalendarUnit.Year, fromDate: activityDate)
    
    acct!.addActivityForDate(activityDate, title: "TestDeposit", icon: "Default", amount: 35.0)
    
    XCTAssert(acct!.balanceTotal == 35.0)
    XCTAssert(acct!.balanceCurrentMonth == 0.0)
    if activityYear == currentYear {
      XCTAssert(acct!.balanceCurrentYear == 35.0)
    } else {
      XCTAssert(acct!.balanceCurrentYear == 0.0)
    }
  }
  
  func testAccountWithOlderActivities_UpdateRecalculatesBalances() {
    let acct = Account.create("OlderAccount")
    
    XCTAssertNotNil(acct)
    
    // 55 days ago
    let olderDate = NSDate().dateByAddingTimeInterval(NSTimeInterval(-60 * 60 * 24 * 55))
    fakeOlderAccount(acct!, olderDate: olderDate)
    
    // run the updateData() method on the account, when the user starts the app again now
    acct!.updateData()
    
    // Since the month has changed, we expect the currentMonth-Balance to be 0.0
    XCTAssert(acct!.balanceCurrentMonth == 0.0)
    
    // If the year has changed, the currentYear-Balance should be 0.0 too
    // otherwise it should be 1200.0
    let currentDate = NSDate()
    if currentDate.year() > olderDate.year() {
      XCTAssert(acct!.balanceCurrentYear == 0.0)
    } else {
      XCTAssert(acct!.balanceCurrentYear == 1200.0)
    }
  }
  
  func testAccountWithOlderActivities_ScheduledEventsAreApplied() {
    let acct = Account.create("OlderAccount")
    
    XCTAssertNotNil(acct)

    // 55 days ago
    let olderDate = NSDate.dateWithDay(10, month: 1, year: 2015)!
    fakeOlderAccount(acct!, olderDate: olderDate)
    
    // Create two scheduled events which were due in the timeframe between olderDate and now
    let event1 = acct!.addEventWithTitle("TestEvent1", icon: "Default", recurring: true, dayOfMonth: 20, interval: 1, amount: -100.0)
    let event2 = acct!.addEventWithTitle("TestEvent2", icon: "Default", recurring: false, dayOfMonth: 1, interval: 1, amount: -49.0)
    
    // Fake the events to make them fit into the time range from 55 days ago until today,
    // so they are due and updateData() applies them to the account
    let dateEvent1 = NSDate.dateWithDay(20, month: 1, year: 2015)
    event1?.nextDueDate = dateEvent1
    let dateEvent2 = NSDate.dateWithDay(25, month: 1, year: 2015)
    event2?.nextDueDate = dateEvent2
    coreDataManager.saveContext()
    
    // run the updateData() method on the account, when the user starts the app again now
    acct!.updateData()
    
    XCTAssertTrue(event1!.due)
    
    XCTAssert(acct!.balanceCurrentYear == (1200.0 - 100.0 - 49.0))
    XCTAssert(acct!.scheduledEvents?.count == 1)
  }
  
  private func fakeOlderAccount(account: Account, olderDate: NSDate) {
    account.addActivityForDate(olderDate, title: "Test1", icon: "Default", amount: -30.0)
    account.addActivityForDate(olderDate, title: "Test2", icon: "Default", amount: 145.0)
    account.addActivityForDate(olderDate, title: "Test3", icon: "Default", amount: -99.0)
    account.addActivityForDate(olderDate, title: "Test4", icon: "Default", amount: 230.0)
    
    // Fakes the balances which were current, when the user left the app 55 days ago ;-)
    account.balanceCurrentMonth = -30.0 + 145.0 - 99.0 + 230.0
    account.balanceCurrentYear = 1200.0
    account.lastUpdated = olderDate
    coreDataManager.saveContext()
  }
}










