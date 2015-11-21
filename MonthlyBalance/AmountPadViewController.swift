//
//  AmountPadViewController.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 20.11.15.
//  Copyright © 2015 Karrmarr Software. All rights reserved.
//

import UIKit

class AmountPadViewController : UIViewController {
  
  var amountLabel: UILabel!
  
  // MARK: - Initialization
  
  override func loadView() {
    let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
    self.view = AmountPadView(effect: blurEffect)
    
    self.view.backgroundColor = UIColor.clearColor()
    self.view.layer.cornerRadius = 30
    
    self.view.clipsToBounds = true
    
    // AmountLabel
    let font = UIFont(name: kMainFontName, size: 48)
    
    self.amountLabel = UILabel(frame: CGRectZero)
    self.amountLabel.text = "0"
    self.amountLabel.font = font
    self.amountLabel.sizeToFit()
    self.amountLabel.translatesAutoresizingMaskIntoConstraints = false
    
    self.view.addSubview(self.amountLabel)
    
    setupConstraints()
  }
  
  // MARK: - Autolayout
  
  func setupConstraints() {
    self.view.addConstraint(NSLayoutConstraint(item: self.amountLabel, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 37))
    self.view.addConstraint(NSLayoutConstraint(item: self.amountLabel, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .Trailing, multiplier: 1, constant: -22))
  }
}
