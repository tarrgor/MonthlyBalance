//
//  AmountPadViewController.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 20.11.15.
//  Copyright © 2015 Karrmarr Software. All rights reserved.
//

import UIKit

enum AmountPadMode : Double {
  case Income = 1.0, Expenditure = -1.0
}

class AmountPadViewController : UIViewController {
  
  var amount: Int = 0
  var digits: Int = 0
  
  var finalAmount: Double {
    return (Double(self.amount) + Double(self.digits) / 100) * self.mode.rawValue
  }
  
  var mode: AmountPadMode = .Expenditure
  
  var delegate: AmountPadDelegate? = nil
  
  private var _decimalMode = false
  private var _currentDigit = 1
  
  // MARK: - Initialization
  
  override func loadView() {
    let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
    self.view = AmountPadView(effect: blurEffect)
    
    setupActions()
  }

  // MARK: - Actions
  
  // TODO: Create a builder class for the amount
  
  func okPressed(sender: UIButton) {
    self.delegate?.amountPadDidPressOk(self)
  }
  
  func cancelPressed(sender: UIButton) {
    self.amount = 0
    self.digits = 0
    
    self.delegate?.amountPadDidPressCancel(self)
  }
  
  func numberPressed(sender: UIButton) {
    if sender.tag >= 1 && sender.tag <= 10 {
      let number = sender.tag < 10 ? sender.tag : 0
      if (_decimalMode) {
        if (_currentDigit == 1) {
          self.digits = number * 10
          _currentDigit = 2
        } else {
          self.digits += number
          _currentDigit = 1
        }
      } else {
        self.amount = self.amount * 10 + number
      }
      updateAmountDisplay()
    }
  }
  
  func commaPressed(sender: UIButton) {
    if !self._decimalMode {
      _decimalMode = true
      updateAmountDisplay()
    }
  }
  
  // MARK: - Private methods
  
  private func updateAmountDisplay() {
    let amountPadView = self.view as! AmountPadView
    
    var amountString = String(self.amount)
    if self.digits > 0 {
      amountString.appendContentsOf("." + String(self.digits))
    } else if _decimalMode {
      amountString.appendContentsOf(".")
    }
    amountString.appendContentsOf(" €")
    amountPadView.amountLabel.text = amountString
  }
  
  private func setupActions() {
    let amountPadView = self.view as! AmountPadView
    
    amountPadView.okButton.addTarget(self, action: "okPressed:", forControlEvents: .TouchUpInside)
    amountPadView.cancelButton.addTarget(self, action: "cancelPressed:", forControlEvents: .TouchUpInside)
    
    for numericButton in amountPadView.numericButtons {
      numericButton?.addTarget(self, action: "numberPressed:", forControlEvents: .TouchUpInside)
    }
    
    amountPadView.commaButton.addTarget(self, action: "commaPressed:", forControlEvents: .TouchUpInside)
  }

}
