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
  var numericButtons = [UIButton?](repeating: nil, count: 10)
  var commaButton: UIButton!
  var okButton: UIButton!
  var cancelButton: UIButton!
  
  // MARK: - Initialization
  
  override init(effect: UIVisualEffect?) {
    super.init(effect: effect)
    
    self.backgroundColor = UIColor.clear
    self.layer.cornerRadius = 30
    
    self.clipsToBounds = true
    
    // User interface
    createAmountLabel()
    createHorizontalLineView()
    createNumericButtons()
    
    //setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func layoutSubviews() {
    setupConstraints()
  }
  
  // MARK: - Autolayout
  
  func setupConstraints() {
    var keyGapHorizontal: CGFloat = 16.0
    var keyGapVertical: CGFloat = 10.0
    var keyGapReduction: CGFloat = 0.0
    var topGap: CGFloat = 30.0
    var leftGap: CGFloat = 40.0
    if DeviceType.IS_IPHONE_4_OR_LESS {
      keyGapHorizontal = 10.0
      keyGapReduction = 5.0
      keyGapVertical = 6.0
      topGap = 6.0
      leftGap = 6.0
    } else if DeviceType.IS_IPHONE_5 {
      keyGapHorizontal = 9.0
      leftGap = 12.0
      keyGapReduction = 5.0
    } else if DeviceType.IS_IPHONE_6 {
      topGap = 20.0
    }
    
    // Amount label constraints
    self.addConstraint(NSLayoutConstraint(item: self.amountLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: topGap))
    self.addConstraint(NSLayoutConstraint(item: self.amountLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -22))
    
    // Line view constraints
    self.addConstraint(NSLayoutConstraint(item: self.lineView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leadingMargin, multiplier: 1, constant: 0))
    self.addConstraint(NSLayoutConstraint(item: self.lineView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailingMargin, multiplier: 1, constant: 0))
    self.addConstraint(NSLayoutConstraint(item: self.lineView, attribute: .top, relatedBy: .equal, toItem: self.amountLabel, attribute: .bottom, multiplier: 1, constant: 4))
    self.lineView.addConstraint(NSLayoutConstraint(item: self.lineView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 2))
    
    // Constraints for numeric buttons
    self.addConstraint(NSLayoutConstraint(item: self.numericButtons[7]!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: leftGap))
    self.addConstraint(NSLayoutConstraint(item: self.numericButtons[7]!, attribute: .top, relatedBy: .equal, toItem: self.lineView, attribute: .bottom, multiplier: 1, constant: 14))
    self.addConstraint(NSLayoutConstraint(item: self.numericButtons[8]!, attribute: .leading, relatedBy: .equal, toItem: self.numericButtons[7]!, attribute: .trailing, multiplier: 1, constant: keyGapHorizontal))
    self.addConstraint(NSLayoutConstraint(item: self.numericButtons[8]!, attribute: .top, relatedBy: .equal, toItem: self.numericButtons[7]!, attribute: .top, multiplier: 1, constant: 0))
    self.addConstraint(NSLayoutConstraint(item: self.numericButtons[9]!, attribute: .leading, relatedBy: .equal, toItem: self.numericButtons[8]!, attribute: .trailing, multiplier: 1, constant: keyGapHorizontal))
    self.addConstraint(NSLayoutConstraint(item: self.numericButtons[9]!, attribute: .top, relatedBy: .equal, toItem: self.numericButtons[7]!, attribute: .top, multiplier: 1, constant: 0))

    self.addConstraint(NSLayoutConstraint(item: self.numericButtons[4]!, attribute: .leading, relatedBy: .equal, toItem: self.numericButtons[7]!, attribute: .leading, multiplier: 1, constant: 0))
    self.addConstraint(NSLayoutConstraint(item: self.numericButtons[4]!, attribute: .top, relatedBy: .equal, toItem: self.numericButtons[7]!, attribute: .bottom, multiplier: 1, constant: keyGapVertical))
    self.addConstraint(NSLayoutConstraint(item: self.numericButtons[5]!, attribute: .leading, relatedBy: .equal, toItem: self.numericButtons[4]!, attribute: .trailing, multiplier: 1, constant: keyGapHorizontal))
    self.addConstraint(NSLayoutConstraint(item: self.numericButtons[5]!, attribute: .top, relatedBy: .equal, toItem: self.numericButtons[4]!, attribute: .top, multiplier: 1, constant: 0))
    self.addConstraint(NSLayoutConstraint(item: self.numericButtons[6]!, attribute: .leading, relatedBy: .equal, toItem: self.numericButtons[5]!, attribute: .trailing, multiplier: 1, constant: keyGapHorizontal))
    self.addConstraint(NSLayoutConstraint(item: self.numericButtons[6]!, attribute: .top, relatedBy: .equal, toItem: self.numericButtons[4]!, attribute: .top, multiplier: 1, constant: 0))

    self.addConstraint(NSLayoutConstraint(item: self.numericButtons[1]!, attribute: .leading, relatedBy: .equal, toItem: self.numericButtons[7]!, attribute: .leading, multiplier: 1, constant: 0))
    self.addConstraint(NSLayoutConstraint(item: self.numericButtons[1]!, attribute: .top, relatedBy: .equal, toItem: self.numericButtons[4]!, attribute: .bottom, multiplier: 1, constant: keyGapVertical))
    self.addConstraint(NSLayoutConstraint(item: self.numericButtons[2]!, attribute: .leading, relatedBy: .equal, toItem: self.numericButtons[1]!, attribute: .trailing, multiplier: 1, constant: keyGapHorizontal))
    self.addConstraint(NSLayoutConstraint(item: self.numericButtons[2]!, attribute: .top, relatedBy: .equal, toItem: self.numericButtons[1]!, attribute: .top, multiplier: 1, constant: 0))
    self.addConstraint(NSLayoutConstraint(item: self.numericButtons[3]!, attribute: .leading, relatedBy: .equal, toItem: self.numericButtons[2]!, attribute: .trailing, multiplier: 1, constant: keyGapHorizontal))
    self.addConstraint(NSLayoutConstraint(item: self.numericButtons[3]!, attribute: .top, relatedBy: .equal, toItem: self.numericButtons[1]!, attribute: .top, multiplier: 1, constant: 0))
    
    self.addConstraint(NSLayoutConstraint(item: self.numericButtons[0]!, attribute: .leading, relatedBy: .equal, toItem: self.numericButtons[7]!, attribute: .leading, multiplier: 1, constant: 0))
    self.addConstraint(NSLayoutConstraint(item: self.numericButtons[0]!, attribute: .top, relatedBy: .equal, toItem: self.numericButtons[1]!, attribute: .bottom, multiplier: 1, constant: keyGapVertical))
    self.addConstraint(NSLayoutConstraint(item: self.commaButton, attribute: .leading, relatedBy: .equal, toItem: self.numericButtons[0]!, attribute: .trailing, multiplier: 1, constant: keyGapHorizontal - keyGapReduction))
    self.addConstraint(NSLayoutConstraint(item: self.commaButton, attribute: .top, relatedBy: .equal, toItem: self.numericButtons[0]!, attribute: .top, multiplier: 1, constant: 0))
    
    self.addConstraint(NSLayoutConstraint(item: self.cancelButton, attribute: .trailing, relatedBy: .equal, toItem: self.lineView, attribute: .trailing, multiplier: 1, constant: 0))
    self.addConstraint(NSLayoutConstraint(item: self.cancelButton, attribute: .top, relatedBy: .equal, toItem: self.numericButtons[7]!, attribute: .top, multiplier: 1, constant: 0))
    
    self.addConstraint(NSLayoutConstraint(item: self.okButton, attribute: .leading, relatedBy: .equal, toItem: self.cancelButton, attribute: .leading, multiplier: 1, constant: 0))
    self.addConstraint(NSLayoutConstraint(item: self.okButton, attribute: .top, relatedBy: .equal, toItem: self.numericButtons[0]!, attribute: .top, multiplier: 1, constant: 0))
  }
  
  // MARK: - Create user interface components
  
  func createAmountLabel() {
    let amountFont = UIFont(name: kMainFontName, size: 48)
    
    self.amountLabel = UILabel(frame: CGRect.zero)
    self.amountLabel.text = "0 €"
    self.amountLabel.font = amountFont
    self.amountLabel.sizeToFit()
    self.amountLabel.translatesAutoresizingMaskIntoConstraints = false
    
    self.addSubview(self.amountLabel)
  }
  
  func createHorizontalLineView() {
    self.lineView = UIView(frame: CGRect.zero)
    self.lineView.backgroundColor = UIColor.black
    self.lineView.translatesAutoresizingMaskIntoConstraints = false
    
    self.addSubview(lineView)
  }
  
  func createNumericButtons() {
    for btn in 0...9 {
      let button = btn > 0 ? UIButton.amountPadButtonWithTitle(String(btn)) : UIButton.amountPadButtonWithNumberZero()
      self.addSubview(button)
      self.numericButtons[btn] = button
    }
    
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
