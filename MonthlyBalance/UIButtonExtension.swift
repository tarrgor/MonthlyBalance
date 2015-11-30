//
//  UIButtonExtension.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 21.11.15.
//  Copyright © 2015 Karrmarr Software. All rights reserved.
//

import UIKit

extension UIButton {
  
  static func amountPadButtonWithTitle(title: String) -> UIButton {
    let button = UIButton(type: .System)
    button.frame = CGRect(x: 50, y: 100, width: 64, height: 64)
    
    button.titleLabel?.font = UIFont(name: kMainFontName, size: 36)
    button.setTitle(title, forState: .Normal)
    button.setTitleColor(UIColor.blackColor(), forState: .Normal)
    
    if let number = Int(title) {
      button.tag = number
    }
    
    button.setBackgroundImage(UIImage(named: "NumericButtonCircle"), forState: .Normal)

    button.translatesAutoresizingMaskIntoConstraints = false

    return button
  }
 
  static func amountPadButtonWithNumberZero() -> UIButton {
    let button = UIButton(type: .System)
    button.frame = CGRect(x: 50, y: 100, width: 148, height: 64)
    
    button.titleLabel?.font = UIFont(name: kMainFontName, size: 36)
    button.setTitle("0", forState: .Normal)
    button.setTitleColor(UIColor.blackColor(), forState: .Normal)
    button.tag = 10
    
    button.setBackgroundImage(UIImage(named: "ZeroButtonOval"), forState: .Normal)
    
    button.translatesAutoresizingMaskIntoConstraints = false
    
    return button
  }

  static func amountPadOkButton() -> UIButton {
    let button = UIButton(type: .System)
    button.frame = CGRect(x: 50, y: 100, width: 64, height: 64)
    
    button.setBackgroundImage(UIImage(named: "OkButton"), forState: .Normal)
    
    button.translatesAutoresizingMaskIntoConstraints = false
    
    return button
  }

  static func amountPadCancelButton() -> UIButton {
    let button = UIButton(type: .System)
    button.frame = CGRect(x: 50, y: 100, width: 64, height: 64)
    
    button.setBackgroundImage(UIImage(named: "CancelButton"), forState: .Normal)
    
    button.translatesAutoresizingMaskIntoConstraints = false
    
    return button
  }

  static func menuItemButton(title: String) -> UIButton {
    let button = UIButton(type: .System)
    button.titleLabel?.font = UIFont(name: kMenuFontName, size: 20)
    button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    button.setTitle(title, forState: .Normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.sizeToFit()

    return button
  }
}