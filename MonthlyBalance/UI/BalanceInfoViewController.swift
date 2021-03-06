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
  var account: Account? {
    didSet {
      if let view = self.view {
        view.setValue(account, forKey: "account")
      }
    }
  }
  
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
    do {
      let balanceInfoView = try BalanceInfoView(frame: CGRect(x: 0, y: 80, width: 414, height: 120), type: self.type, account: account!)
      self.view = balanceInfoView
    } catch {
      self.showAlertWithTitle("An error occured!", message: "An invalid amount could not be converted to a currency format.")
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func updateViewConstraints() {
    if let superview = self.view.superview {
      superview.addConstraint(NSLayoutConstraint(item: self.view, attribute: .width, relatedBy: .equal, toItem: superview, attribute: .width, multiplier: 1, constant: 0))
      superview.addConstraint(NSLayoutConstraint(item: self.view, attribute: .height, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: 1, constant: 0))
    }
    
    super.updateViewConstraints()
  }
}
