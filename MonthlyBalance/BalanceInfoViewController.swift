//
//  BalanceInfoViewController.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 14.11.15.
//  Copyright © 2015 Karrmarr Software. All rights reserved.
//

import UIKit

class BalanceInfoViewController: UIViewController {
  var pageIndex: Int = 0
  
  override func loadView() {
    // Initialize view
    self.view = BalanceInfoView(frame: CGRect(x: 0, y: 80, width: 414, height: 120))
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func updateViewConstraints() {
    if let superview = self.view.superview {
      superview.addConstraint(NSLayoutConstraint(item: self.view, attribute: .Width, relatedBy: .Equal, toItem: superview, attribute: .Width, multiplier: 1, constant: 0))
      superview.addConstraint(NSLayoutConstraint(item: self.view, attribute: .Height, relatedBy: .Equal, toItem: superview, attribute: .Height, multiplier: 1, constant: 0))
    }
    
    super.updateViewConstraints()
  }
}
