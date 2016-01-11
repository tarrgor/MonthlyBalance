//
//  EditEventDelegate.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 10.01.16.
//  Copyright © 2016 Karrmarr Software. All rights reserved.
//

import Foundation

protocol EditEventDelegate {
  func editEventViewControllerDidSaveEvent(viewController: EditEventTableViewController, event: ScheduledEvent?)
  
  func editEventViewControllerDidCancelEvent(viewController: EditEventTableViewController)
}