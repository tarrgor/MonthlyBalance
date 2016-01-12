//
//  EditActivityDelegate.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 12.01.16.
//  Copyright © 2016 Karrmarr Software. All rights reserved.
//

import Foundation

protocol EditActivityDelegate {
  func editActivityViewControllerDidSaveEvent(viewController: EditActivityTableViewController, activity: Activity?)
  
  func editActivityViewControllerDidCancelEvent(viewController: EditActivityTableViewController)
}