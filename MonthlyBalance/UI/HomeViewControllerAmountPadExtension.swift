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
    closeAmountPad(amountPad)
  }
  
  func amountPadDidPressCancel(amountPad: AmountPadViewController) {
    closeAmountPad(amountPad)
  }

  func openAmountPad(mode: AmountPadMode) {
    let amountPadViewController = AmountPadViewController()
    amountPadViewController.delegate = self
    amountPadViewController.mode = mode
    self.addChildViewController(amountPadViewController)
    self.view.addSubview(amountPadViewController.view)

    let amountPadHeight = self.view.bounds.size.height * 0.75;
    amountPadViewController.view.frame = CGRect(x: 0, y: self.view.bounds.size.height + 100, width: self.view.bounds.size.width, height: amountPadHeight)

    let maskLayer = CAShapeLayer()
    let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: amountPadViewController.view.bounds.size.height - self.incomeButton.bounds.size.height - 3))
    maskLayer.path = path.CGPath

    amountPadViewController.view.layer.mask = maskLayer

    UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
      let ypos = self.view.bounds.size.height - amountPadViewController.view.bounds.size.height
      amountPadViewController.view.frame.origin = CGPoint(x: 0, y: ypos)
    }, completion: nil)
  }

  func closeAmountPad(amountPad: AmountPadViewController) {
    animateAmountPadOutOfScreen(amountPad)
    resetButtons()
    amountPad.removeFromParentViewController()
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
