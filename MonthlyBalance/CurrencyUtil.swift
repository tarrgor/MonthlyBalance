//
//  CurrencyUtil.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 16.12.15.
//  Copyright © 2015 Karrmarr Software. All rights reserved.
//

import Foundation

enum CurrencyError: Error {
  case invalidAmount
}

class CurrencyUtil {
  
  static func formattedValue(_ amount: Double) throws -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .currency
    
    guard let result = numberFormatter.string(from: NSNumber(value: amount))
    else {
      throw CurrencyError.invalidAmount
    }
    
    return result
  }
  
}
