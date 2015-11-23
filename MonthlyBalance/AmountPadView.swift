//
//  AmountPadView.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 20.11.15.
//  Copyright © 2015 Karrmarr Software. All rights reserved.
//

import UIKit

class AmountPadView : UIVisualEffectView {
  
  var amountLabel: UILabel!
  var lineView: UIView!
  var numericButtons = [UIButton?](count: 10, repeatedValue: nil)
  var commaButton: UIButton!
  var okButton: UIButton!
  var cancelButton: UIButton!
  
  // MARK: - Initialization
  
  override init(effect: UIVisualEffect?) {
    super.init(effect: effect)
    
    self.backgroundColor = UIColor.clearColor()
    self.layer.cornerRadius = 30
    
    self.clipsToBounds = true
    
    // User interface
    createAmountLabel()
    createHorizontalLineView()
    createNumericButtons()
    
    setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  // MARK: - Autolayout
  
  func setupConstraints() {
    // Amount label constraints
    self.addConstraint(NSLayoutConstraint(item: self.amountLabel, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 37))
    self.addConstraint(NSLayoutConstraint(item: self.amountLabel, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1, constant: -22))
    
    // Line view constraints
    self.addConstraint(NSLayoutConstraint(item: self.lineView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .LeadingMargin, multiplier: 1, constant: 0))
    self.addConstraint(NSLayoutConstraint(item: self.lineView, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .TrailingMargin, multiplier: 1, constant: 0))
    self.addConstraint(NSLayoutConstraint(item: self.lineView, attribute: .Top, relatedBy: .Equal, toItem: self.amountLabel, attribute: .Bottom, multiplier: 1, constant: 4))
    self.lineView.addConstraint(NSLayoutConstraint(item: self.lineView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 2))
    
    // Constraints for numeric buttons
    self.addConstraint(NSLayoutConstraint(item: self.numericButtons[7]!, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1, constant: 63))
    self.addConstraint(NSLayoutConstraint(item: self.numericButtons[7]!, attribute: .Top, relatedBy: .Equal, toItem: self.lineView, attribute: .Bottom, multiplier: 1, constant: 14))
    self.addConstraint(NSLayoutConstraint(item: self.numericButtons[8]!, attribute: .Leading, relatedBy: .Equal, toItem: self.numericButtons[7]!, attribute: .Trailing, multiplier: 1, constant: 16))
    self.addConstraint(NSLayoutConstraint(item: self.numericButtons[8]!, attribute: .Top, relatedBy: .Equal, toItem: self.numericButtons[7]!, attribute: .Top, multiplier: 1, constant: 0))
    self.addConstraint(NSLayoutConstraint(item: self.numericButtons[9]!, attribute: .Leading, relatedBy: .Equal, toItem: self.numericButtons[8]!, attribute: .Trailing, multiplier: 1, constant: 16))
    self.addConstraint(NSLayoutConstraint(item: self.numericButtons[9]!, attribute: .Top, relatedBy: .Equal, toItem: self.numericButtons[7]!, attribute: .Top, multiplier: 1, constant: 0))

    self.addConstraint(NSLayoutConstraint(item: self.numericButtons[4]!, attribute: .Leading, relatedBy: .Equal, toItem: self.numericButtons[7]!, attribute: .Leading, multiplier: 1, constant: 0))
    self.addConstraint(NSLayoutConstraint(item: self.numericButtons[4]!, attribute: .Top, relatedBy: .Equal, toItem: self.numericButtons[7]!, attribute: .Bottom, multiplier: 1, constant: 10))
    self.addConstraint(NSLayoutConstraint(item: self.numericButtons[5]!, attribute: .Leading, relatedBy: .Equal, toItem: self.numericButtons[4]!, attribute: .Trailing, multiplier: 1, constant: 16))
    self.addConstraint(NSLayoutConstraint(item: self.numericButtons[5]!, attribute: .Top, relatedBy: .Equal, toItem: self.numericButtons[4]!, attribute: .Top, multiplier: 1, constant: 0))
    self.addConstraint(NSLayoutConstraint(item: self.numericButtons[6]!, attribute: .Leading, relatedBy: .Equal, toItem: self.numericButtons[5]!, attribute: .Trailing, multiplier: 1, constant: 16))
    self.addConstraint(NSLayoutConstraint(item: self.numericButtons[6]!, attribute: .Top, relatedBy: .Equal, toItem: self.numericButtons[4]!, attribute: .Top, multiplier: 1, constant: 0))

    self.addConstraint(NSLayoutConstraint(item: self.numericButtons[1]!, attribute: .Leading, relatedBy: .Equal, toItem: self.numericButtons[7]!, attribute: .Leading, multiplier: 1, constant: 0))
    self.addConstraint(NSLayoutConstraint(item: self.numericButtons[1]!, attribute: .Top, relatedBy: .Equal, toItem: self.numericButtons[4]!, attribute: .Bottom, multiplier: 1, constant: 10))
    self.addConstraint(NSLayoutConstraint(item: self.numericButtons[2]!, attribute: .Leading, relatedBy: .Equal, toItem: self.numericButtons[1]!, attribute: .Trailing, multiplier: 1, constant: 16))
    self.addConstraint(NSLayoutConstraint(item: self.numericButtons[2]!, attribute: .Top, relatedBy: .Equal, toItem: self.numericButtons[1]!, attribute: .Top, multiplier: 1, constant: 0))
    self.addConstraint(NSLayoutConstraint(item: self.numericButtons[3]!, attribute: .Leading, relatedBy: .Equal, toItem: self.numericButtons[2]!, attribute: .Trailing, multiplier: 1, constant: 16))
    self.addConstraint(NSLayoutConstraint(item: self.numericButtons[3]!, attribute: .Top, relatedBy: .Equal, toItem: self.numericButtons[1]!, attribute: .Top, multiplier: 1, constant: 0))
    
    self.addConstraint(NSLayoutConstraint(item: self.numericButtons[0]!, attribute: .Leading, relatedBy: .Equal, toItem: self.numericButtons[7]!, attribute: .Leading, multiplier: 1, constant: 0))
    self.addConstraint(NSLayoutConstraint(item: self.numericButtons[0]!, attribute: .Top, relatedBy: .Equal, toItem: self.numericButtons[1]!, attribute: .Bottom, multiplier: 1, constant: 10))
    self.addConstraint(NSLayoutConstraint(item: self.commaButton, attribute: .Leading, relatedBy: .Equal, toItem: self.numericButtons[0]!, attribute: .Trailing, multiplier: 1, constant: 16))
    self.addConstraint(NSLayoutConstraint(item: self.commaButton, attribute: .Top, relatedBy: .Equal, toItem: self.numericButtons[0]!, attribute: .Top, multiplier: 1, constant: 0))
    
    self.addConstraint(NSLayoutConstraint(item: self.cancelButton, attribute: .Leading, relatedBy: .Equal, toItem: self.numericButtons[9]!, attribute: .Trailing, multiplier: 1, constant: 38))
    self.addConstraint(NSLayoutConstraint(item: self.cancelButton, attribute: .Top, relatedBy: .Equal, toItem: self.numericButtons[7]!, attribute: .Top, multiplier: 1, constant: 0))
    
    self.addConstraint(NSLayoutConstraint(item: self.okButton, attribute: .Leading, relatedBy: .Equal, toItem: self.cancelButton, attribute: .Leading, multiplier: 1, constant: 0))
    self.addConstraint(NSLayoutConstraint(item: self.okButton, attribute: .Top, relatedBy: .Equal, toItem: self.numericButtons[0]!, attribute: .Top, multiplier: 1, constant: 0))
  }
  
  // MARK: - Create user interface components
  
  func createAmountLabel() {
    let amountFont = UIFont(name: kMainFontName, size: 48)
    
    self.amountLabel = UILabel(frame: CGRectZero)
    self.amountLabel.text = "0 €"
    self.amountLabel.font = amountFont
    self.amountLabel.sizeToFit()
    self.amountLabel.translatesAutoresizingMaskIntoConstraints = false
    
    self.addSubview(self.amountLabel)
  }
  
  func createHorizontalLineView() {
    self.lineView = UIView(frame: CGRectZero)
    self.lineView.backgroundColor = UIColor.blackColor()
    self.lineView.translatesAutoresizingMaskIntoConstraints = false
    
    self.addSubview(lineView)
  }
  
  func createNumericButtons() {
    let button7 = UIButton.amountPadButtonWithTitle("7")
    self.addSubview(button7)
    self.numericButtons[7] = button7

    let button8 = UIButton.amountPadButtonWithTitle("8")
    self.addSubview(button8)
    self.numericButtons[8] = button8

    let button9 = UIButton.amountPadButtonWithTitle("9")
    self.addSubview(button9)
    self.numericButtons[9] = button9

    let button4 = UIButton.amountPadButtonWithTitle("4")
    self.addSubview(button4)
    self.numericButtons[4] = button4
    
    let button5 = UIButton.amountPadButtonWithTitle("5")
    self.addSubview(button5)
    self.numericButtons[5] = button5
    
    let button6 = UIButton.amountPadButtonWithTitle("6")
    self.addSubview(button6)
    self.numericButtons[6] = button6

    let button1 = UIButton.amountPadButtonWithTitle("1")
    self.addSubview(button1)
    self.numericButtons[1] = button1

    let button2 = UIButton.amountPadButtonWithTitle("2")
    self.addSubview(button2)
    self.numericButtons[2] = button2
    
    let button3 = UIButton.amountPadButtonWithTitle("3")
    self.addSubview(button3)
    self.numericButtons[3] = button3
    
    let button0 = UIButton.amountPadButtonWithNumberZero()
    self.addSubview(button0)
    self.numericButtons[0] = button0
    
    let buttonComma = UIButton.amountPadButtonWithTitle(".")
    self.addSubview(buttonComma)
    self.commaButton = buttonComma
    
    let okButton = UIButton.amountPadOkButton()
    self.addSubview(okButton)
    self.okButton = okButton
    
    let cancelButton = UIButton.amountPadCancelButton()
    self.addSubview(cancelButton)
    self.cancelButton = cancelButton
  }
}
