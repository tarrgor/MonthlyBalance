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
        setAmountLabelText()
      }
    }
  }
  
  var headlineLabel: UILabel!
  var amountLabel: MBAmountLabel!
  var wrapperView: UIView!
  
  var referencedEntity: Account?
  var referenceKey: String = ""

  init(frame: CGRect, type: BalanceInfoType, account: Account) throws {
    self.type = type
    self.account = account
    
    super.init(frame: frame)
    
    self.backgroundColor = UIColor(hex: kColorBaseBackground)
    
    self.translatesAutoresizingMaskIntoConstraints = true
    // needs to be true because otherwise the PageViewController shows nothing

    let isSmallPhone: Bool = DeviceType.IS_IPHONE_4_OR_LESS || DeviceType.IS_IPHONE_5
    let headlineFontSize: CGFloat = isSmallPhone ? 13 : 16
    let amountFontSize: CGFloat = isSmallPhone ? 36 : 48
    
    // initialize Labels
    self.headlineLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
    self.headlineLabel.textColor = UIColor.white
    self.headlineLabel.text = self.type.rawValue
    self.headlineLabel.font = UIFont(name: kMainFontName, size: headlineFontSize)
    self.headlineLabel.textAlignment = .center
    self.headlineLabel.translatesAutoresizingMaskIntoConstraints = false
    self.headlineLabel.sizeToFit()
    
    self.addSubview(self.headlineLabel)
    
    self.wrapperView = UIView(frame: CGRect.zero)
    self.wrapperView.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(self.wrapperView)
    
    self.amountLabel = MBAmountLabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
    self.amountLabel.font = UIFont(name: kMainFontName, size: amountFontSize)
    
    setAmountLabelText()
    
    self.amountLabel.textAlignment = .center
    self.amountLabel.translatesAutoresizingMaskIntoConstraints = false
    self.amountLabel.sizeToFit()
    
    self.wrapperView.addSubview(self.amountLabel)
    
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
      NSLayoutConstraint.activate([
        self.widthAnchor.constraint(equalTo: superview.widthAnchor),
        self.heightAnchor.constraint(equalTo: superview.heightAnchor)
      ])
    }
    
    let topConstant: CGFloat = DeviceType.IS_IPHONE_4_OR_LESS ? -2 : 2
    
    NSLayoutConstraint.activate([
      self.headlineLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      self.headlineLabel.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor, constant: topConstant),
      self.wrapperView.topAnchor.constraint(equalTo: self.headlineLabel.bottomAnchor),
      self.wrapperView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      self.wrapperView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      self.wrapperView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      self.amountLabel.centerXAnchor.constraint(equalTo: self.wrapperView.centerXAnchor),
      self.amountLabel.centerYAnchor.constraint(equalTo: self.wrapperView.centerYAnchor)
    ])

    super.updateConstraints()
  }
  
  func setAmountLabelText() {
    if let account = self.account {
      let amount: Double = account.value(forKey: self.type.propertyName()) as! Double
      self.amountLabel.amount = amount
    }
  }
}
