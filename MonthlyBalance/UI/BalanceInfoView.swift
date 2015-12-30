//
//  BalanceInfoView.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 16.11.15.
//  Copyright © 2015 Karrmarr Software. All rights reserved.
//

import UIKit

enum BalanceInfoType : String {
  case TotalBalance = "Total Balance"
  case CurrentMonth = "Current month"
  case CurrentYear = "Current year"
  
  static func types() -> [BalanceInfoType] {
    return [ TotalBalance, CurrentMonth, CurrentYear ]
  }
  
  static func count() -> Int {
    return BalanceInfoType.types().count
  }
  
  func propertyName() -> String {
    switch self {
    case .TotalBalance:
      return "balanceTotal"
    case .CurrentMonth:
      return "balanceCurrentMonth"
    case .CurrentYear:
      return "balanceCurrentYear"
    }
  }
}

class BalanceInfoView : UIView {
  
  var type: BalanceInfoType
  var account: Account? {
    didSet {
      if account != nil {
        do {
          try setAmountLabelText()
        } catch {
          print("Could not set amount for label.")
        }
      }
    }
  }
  
  var headlineLabel: UILabel!
  var amountLabel: UILabel!
  
  var referencedEntity: Account?
  var referenceKey: String = ""

  init(frame: CGRect, type: BalanceInfoType, account: Account) throws {
    self.type = type
    self.account = account
    
    super.init(frame: frame)
    
    self.backgroundColor = UIColor(hex: kColorBaseBackground)
    
    self.translatesAutoresizingMaskIntoConstraints = true
    // needs to be true because otherwise the PageViewController shows nothing

    // initialize Labels
    self.headlineLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
    self.headlineLabel.textColor = UIColor.whiteColor()
    self.headlineLabel.text = self.type.rawValue
    self.headlineLabel.font = UIFont(name: kMainFontName, size: 16)
    self.headlineLabel.textAlignment = .Center
    self.headlineLabel.translatesAutoresizingMaskIntoConstraints = false
    self.headlineLabel.sizeToFit()
    
    self.addSubview(self.headlineLabel)
    
    self.amountLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
    self.amountLabel.textColor = UIColor(hex: kColorBalanceAmountText)
    self.amountLabel.font = UIFont(name: kMainFontName, size: 48)
    
    try setAmountLabelText()
    
    self.amountLabel.textAlignment = .Center
    self.amountLabel.translatesAutoresizingMaskIntoConstraints = false
    self.amountLabel.sizeToFit()
    
    self.addSubview(self.amountLabel)
    
    self.setNeedsUpdateConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    self.type = .TotalBalance
    self.account = nil
    super.init(coder: aDecoder)
  }
  
  override func updateConstraints() {
    // Add autolayout constraints
    if let superview = self.superview {
      superview.addConstraint(NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: superview, attribute: .Width, multiplier: 1, constant: 0))
      superview.addConstraint(NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: superview, attribute: .Height, multiplier: 1, constant: 0))
    }
    
    self.addConstraint(NSLayoutConstraint(item: self.headlineLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: .Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
    self.addConstraint(NSLayoutConstraint(item: self.headlineLabel, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .TopMargin, multiplier: 1.0, constant: 2))
    self.addConstraint(NSLayoutConstraint(item: self.amountLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: .Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
    self.addConstraint(NSLayoutConstraint(item: self.amountLabel, attribute: .Top, relatedBy: .Equal, toItem: self.headlineLabel, attribute: .Bottom, multiplier: 1.0, constant: 2))

    super.updateConstraints()
  }
  
  func setAmountLabelText() throws {
    if let account = self.account {
      let amount: Double = account.valueForKey(self.type.propertyName()) as! Double
      try self.amountLabel.text = CurrencyUtil.formattedValue(amount)
    }
  }
}
