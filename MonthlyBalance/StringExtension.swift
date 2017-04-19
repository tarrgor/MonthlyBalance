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
    return self.trimmingCharacters(in: CharacterSet.whitespaces)
  }
  
  subscript (i: Int) -> Character {
    return self[self.characters.index(self.startIndex, offsetBy: i)]
  }
  
  subscript (i: Int) -> String {
    return String(self[i] as Character)
  }
  
  subscript (r: Range<Int>) -> String {
    return substring(with: (characters.index(startIndex, offsetBy: r.lowerBound) ..< characters.index(startIndex, offsetBy: r.upperBound)))
  }
}
