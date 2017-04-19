//
//  AmountPadViewController.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 20.11.15.
//  Copyright © 2015 Karrmarr Software. All rights reserved.
//

import UIKit

enum AmountPadMode : Double {
  case income = 1.0, expenditure = -1.0
}

typealias AmountPadViewOk = (AmountPadViewController) -> ()
typealias AmountPadViewCancel = (AmountPadViewController) -> ()

class AmountPadViewController : UIViewController {
  
  var amount: Int = 0
  var digits: Int = 0
  
  var finalAmount: Double {
    return (Double(self.amount) + Double(self.digits) / 100) * self.mode.rawValue
  }
  
  var mode: AmountPadMode = .expenditure
  
  var onOk: AmountPadViewOk?
  var onCancel: AmountPadViewCancel?
  
  fileprivate var _decimalMode = false
  fileprivate var _currentDigit = 1
  
  // MARK: - Initialization
  
  override func loadView() {
    let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
    self.view = AmountPadView(effect: blurEffect)
    
    setupActions()
  }

  // MARK: - Actions
  
  // TODO: Create a builder class for the amount
  
  func okPressed(_ sender: UIButton) {
    if let callback = self.onOk {
      callback(self)
    }
  }
  
  func cancelPressed(_ sender: UIButton) {
    self.amount = 0
    self.digits = 0
    
    if let callback = self.onCancel {
      callback(self)
    }
  }
  
  func numberPressed(_ sender: UIButton) {
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
  
  func commaPressed(_ sender: UIButton) {
    if !self._decimalMode {
      _decimalMode = true
      updateAmountDisplay()
    }
  }
  
  // MARK: - Private methods
  
  fileprivate func updateAmountDisplay() {
    let amountPadView = self.view as! AmountPadView
    
    var amountString = String(self.amount)
    if self.digits > 0 {
      amountString.append("." + String(self.digits))
    } else if _decimalMode {
      amountString.append(".")
    }
    amountString.append(" €")
    amountPadView.amountLabel.text = amountString
  }
  
  fileprivate func setupActions() {
    let amountPadView = self.view as! AmountPadView
    
    amountPadView.okButton.addTarget(self, action: #selector(AmountPadViewController.okPressed(_:)), for: .touchUpInside)
    amountPadView.cancelButton.addTarget(self, action: #selector(AmountPadViewController.cancelPressed(_:)), for: .touchUpInside)
    
    for numericButton in amountPadView.numericButtons {
      numericButton?.addTarget(self, action: #selector(numberPressed(_:)), for: .touchUpInside)
    }
    
    amountPadView.commaButton.addTarget(self, action: #selector(AmountPadViewController.commaPressed(_:)), for: .touchUpInside)
  }

}
