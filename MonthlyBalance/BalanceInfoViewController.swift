//
//  BalanceInfoViewController.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 14.11.15.
//  Copyright © 2015 Karrmarr Software. All rights reserved.
//

import UIKit

class BalanceInfoViewController: UIViewController {
  var headline: String = "No title"
  var referencedEntity: Account?
  var referenceKey: String = ""
  var pageIndex: Int = 0
  
  var headlineLabel: UILabel!
  var amountLabel: UILabel!

  override func loadView() {
    // Initialize view
    self.view = UIView(frame: CGRect(x: 0, y: 0, width: 414, height: 120))
    self.view.backgroundColor = UIColor(hex: kBaseBackgroundColor)
    self.view.translatesAutoresizingMaskIntoConstraints = false    
    
    // initialize Labels
    self.headlineLabel = UILabel(frame: CGRect(x: 0, y: 10, width: self.view.bounds.size.width, height: 20))
    self.headlineLabel.textColor = UIColor.whiteColor()
    self.headlineLabel.text = self.headline
    self.headlineLabel.font = UIFont(name: kMainFontName, size: 16)
    self.headlineLabel.textAlignment = .Center
    //self.headlineLabel.translatesAutoresizingMaskIntoConstraints = false
    //self.headlineLabel.sizeToFit()
    
    self.view.addSubview(self.headlineLabel)

    self.amountLabel = UILabel(frame: CGRect(x: 0, y: 35, width: self.view.bounds.size.width, height: 50))
    self.amountLabel.textColor = UIColor(hex: kBalanceAmountTextColor)
    self.amountLabel.font = UIFont(name: kMainFontName, size: 48)
    self.amountLabel.text = "952,00 €"
    self.amountLabel.textAlignment = .Center
    
    self.view.addSubview(self.amountLabel)
    
    // TODO: Resolve autolayout issues
    
    // Add autolayout constraints
    /*
    let horizontalConstraint = NSLayoutConstraint(item: self.headlineLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0)
    let verticalConstraint = NSLayoutConstraint(item: self.headlineLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1.0, constant: 0)
    let widthConstraint = NSLayoutConstraint(item: self.headlineLabel, attribute: .Width, relatedBy: NSLayoutRelation.GreaterThanOrEqual, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 80)
    let heightConstraint = NSLayoutConstraint(item: self.headlineLabel, attribute: .Height, relatedBy: NSLayoutRelation.GreaterThanOrEqual, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 20)
    
    self.view.addConstraint(horizontalConstraint)
    self.view.addConstraint(verticalConstraint)
    self.view.addConstraint(widthConstraint)
    self.view.addConstraint(heightConstraint)
    
    let views = [ "headline" : self.headlineLabel, "view" : self.view ]
    self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[headline]-|", options: [], metrics: [:], views: views))
    self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[headline]-|", options: [], metrics: [:], views: views))
    */
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}
