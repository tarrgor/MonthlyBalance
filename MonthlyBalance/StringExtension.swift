//
//  StringExtension.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 14.11.15.
//  Copyright © 2015 Karrmarr Software. All rights reserved.
//

import Foundation

extension String {
  
  func trim() -> String {
    return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
  }
  
  subscript (i: Int) -> Character {
    return self[self.startIndex.advancedBy(i)]
  }
  
  subscript (i: Int) -> String {
    return String(self[i] as Character)
  }
  
  subscript (r: Range<Int>) -> String {
    return substringWithRange(Range(start: startIndex.advancedBy(r.startIndex), end: startIndex.advancedBy(r.endIndex)))
  }
}