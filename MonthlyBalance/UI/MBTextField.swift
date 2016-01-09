//
//  MBTextField.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 09.01.16.
//  Copyright © 2016 Karrmarr Software. All rights reserved.
//

import UIKit

@IBDesignable
class MBTextField : UITextField {
  
  @IBInspectable var xInsets: CGFloat = 20
  @IBInspectable var yInsets: CGFloat = 0
  
  @IBInspectable var placeholderColor: UIColor = UIColor.blackColor() {
    didSet {
      if let placeholder = self.placeholder {
        let placeholder = NSAttributedString(string: placeholder, attributes: [ NSForegroundColorAttributeName : self.placeholderColor ])
        self.attributedPlaceholder = placeholder
      }
    }
  }
  
  override func textRectForBounds(bounds: CGRect) -> CGRect {
    return CGRectInset(bounds, self.xInsets, self.yInsets)
  }
  
  override func editingRectForBounds(bounds: CGRect) -> CGRect {
    return CGRectInset(bounds, self.xInsets, self.yInsets)
  }
  
}
