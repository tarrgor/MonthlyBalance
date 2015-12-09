//
//  BalanceInfoView.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 16.11.15.
//  Copyright © 2015 Karrmarr Software. All rights reserved.
//

import UIKit

class BalanceInfoView : UIView {
  
  var headlineLabel: UILabel!
  var amountLabel: UILabel!
  
  var headline: String = "No title" {
    didSet {
      updateLabels()
    }
  }
  
  var referencedEntity: Account?
  var referenceKey: String = ""

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.backgroundColor = UIColor(hex: kColorBaseBackground)
    
    self.translatesAutoresizingMaskIntoConstraints = true
    // needs to be true because otherwise the PageViewController shows nothing

    // initialize Labels
    self.headlineLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
    self.headlineLabel.textColor = UIColor.whiteColor()
    self.headlineLabel.text = self.headline
    self.headlineLabel.font = UIFont(name: kMainFontName, size: 16)
    self.headlineLabel.textAlignment = .Center
    self.headlineLabel.translatesAutoresizingMaskIntoConstraints = false
    self.headlineLabel.sizeToFit()
    
    self.addSubview(self.headlineLabel)
    
    self.amountLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
    self.amountLabel.textColor = UIColor(hex: kColorBalanceAmountText)
    self.amountLabel.font = UIFont(name: kMainFontName, size: 48)
    self.amountLabel.text = "952.00 €"
    self.amountLabel.textAlignment = .Center
    self.amountLabel.translatesAutoresizingMaskIntoConstraints = false
    self.amountLabel.sizeToFit()
    
    self.addSubview(self.amountLabel)
    
    self.setNeedsUpdateConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
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
  
  private func updateLabels() {
    self.headlineLabel.text = self.headline
  }
}
