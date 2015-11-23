//
//  AmountPadDelegate.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 23.11.15.
//  Copyright © 2015 Karrmarr Software. All rights reserved.
//

import Foundation

protocol AmountPadDelegate {
  
  func amountPadDidPressOk(amountPad: AmountPadViewController)
  func amountPadDidPressCancel(amountPad: AmountPadViewController)
  
}