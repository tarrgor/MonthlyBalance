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
    let rgbValue = UnsafeMutablePointer<UInt32>.allocate(capacity: 1)
    
    let scanner = Scanner(string: hex)
    if hex[0] == "#"  {
      scanner.scanLocation = 1
    }
    scanner.scanHexInt32(rgbValue)
    
    let cval = rgbValue.pointee
    rgbValue.deinitialize()
    
    self.init(red: CGFloat(((cval & 0xFF0000) >> 16)) / 255.0,
      green: CGFloat(((cval & 0xFF00) >> 8)) / 255.0,
      blue: CGFloat(cval & 0xFF) / 255.0, alpha: 1.0)
  }
  
}
