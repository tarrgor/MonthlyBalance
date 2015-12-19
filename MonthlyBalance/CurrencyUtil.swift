//
//  CurrencyUtil.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 16.12.15.
//  Copyright © 2015 Karrmarr Software. All rights reserved.
//

import Foundation

enum CurrencyError: ErrorType {
  case InvalidAmount
}

class CurrencyUtil {
  
  static func formattedValue(amount: Double) throws -> String {
    let numberFormatter = NSNumberFormatter()
    numberFormatter.numberStyle = .CurrencyStyle
    
    guard let result = numberFormatter.stringFromNumber(amount)
    else {
      throw CurrencyError.InvalidAmount
    }
    
    return result
  }
  
}