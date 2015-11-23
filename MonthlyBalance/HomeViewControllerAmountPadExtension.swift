//
//  HomeViewControllerAmountPadExtension.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 23.11.15.
//  Copyright © 2015 Karrmarr Software. All rights reserved.
//

import UIKit

extension HomeViewController : AmountPadDelegate {
  
  func amountPadDidPressOk(amountPad: AmountPadViewController) {
    animateAmountPadOutOfScreen(amountPad)
    resetButtons()
  }
  
  func amountPadDidPressCancel(amountPad: AmountPadViewController) {
    animateAmountPadOutOfScreen(amountPad)
    resetButtons()
  }
  
  func resetButtons() {
    incomeButton.enabled = true
    expenditureButton.enabled = true
    
    incomeButton.backgroundColor = UIColor(hex: "#468AFF")
    expenditureButton.backgroundColor = UIColor(hex: "#468AFF")
  }
  
  func animateAmountPadOutOfScreen(amountPad: AmountPadViewController) {
    UIView.animateWithDuration(0.3, delay: 0.0, options: [], animations: {
      amountPad.view.frame.origin.y += self.view.frame.size.height
    }, completion: {_ in
      amountPad.view.removeFromSuperview()
    })
  }
}
