//
//  UIColorExtension.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 14.11.15.
//  Copyright © 2015 Karrmarr Software. All rights reserved.
//

import UIKit

extension UIColor {
  
  convenience init(hex: String) {
    let rgbValue = UnsafeMutablePointer<UInt32>.alloc(1)
    
    let scanner = NSScanner(string: hex)
    if hex[0] == "#"  {
      scanner.scanLocation = 1
    }
    scanner.scanHexInt(rgbValue)
    
    let cval = rgbValue.memory
    rgbValue.destroy()
    
    self.init(red: CGFloat(((cval & 0xFF0000) >> 16)) / 255.0,
      green: CGFloat(((cval & 0xFF00) >> 8)) / 255.0,
      blue: CGFloat(cval & 0xFF) / 255.0, alpha: 1.0)
  }
  
}
