//
//  MBAmountLabel.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 09.01.16.
//  Copyright © 2016 Karrmarr Software. All rights reserved.
//

import UIKit

@IBDesignable
class MBAmountLabel : UILabel {
  
  @IBInspectable var amount: Double = 0.0 {
    didSet {
      setAmountLabelText()
    }
  }
  
  fileprivate func setAmountLabelText() {
    do {
      try self.text = CurrencyUtil.formattedValue(abs(self.amount))
      if self.amount < 0 {
        self.textColor = UIColor.red
      } else {
        self.textColor = UIColor.green
      }
    } catch {
      self.text = "ERROR!"
    }
  }
}
