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
  var type: BalanceInfoType
  var account: Account?
  
  init(type: BalanceInfoType, account: Account) {
    self.type = type
    self.account = account
    
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    self.type = .TotalBalance
    self.account = nil
    super.init(coder: aDecoder)
  }
  
  override func loadView() {
    // Initialize view
    let balanceInfoView = BalanceInfoView(frame: CGRect(x: 0, y: 80, width: 414, height: 120), type: self.type, account: account!)
    self.view = balanceInfoView
    
    
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
