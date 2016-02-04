//
//  UIViewControllerExtension.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 30.11.15.
//  Copyright © 2015 Karrmarr Software. All rights reserved.
//

import UIKit

extension UIViewController {
  
  var settings: Settings? {
    // Get the settings
    let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
    return appDelegate?.settings
  }
  
  var slideMenuViewController : SlideMenuViewController? {
    var controller: SlideMenuViewController? = nil
    var parent: UIViewController? = self.parentViewController
    
    while controller == nil && parent != nil {
      if parent!.isKindOfClass(SlideMenuViewController) {
        controller = parent as? SlideMenuViewController
      } else {
        parent = parent?.parentViewController
      }
    }
    
    return controller
  }
  
  func showAlertWithTitle(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    alertController.addAction(UIAlertAction(title: kTitleOkButton, style: UIAlertActionStyle.Default, handler: nil))
    self.presentViewController(alertController, animated: true, completion: nil)
  }
  
  func openAmountPadInMode(mode: AmountPadMode, delegate: AmountPadDelegate, maskRect: ((AmountPadViewController) -> (CGRect))? = nil) {
    let amountPadViewController = AmountPadViewController()
    amountPadViewController.delegate = delegate
    amountPadViewController.mode = mode
    self.addChildViewController(amountPadViewController)
    self.view.addSubview(amountPadViewController.view)
    
    var factor: CGFloat = 0.75
    if DeviceType.IS_IPHONE_4_OR_LESS {
      factor = 1.0
    } else if DeviceType.IS_IPHONE_5 {
      factor = 0.9
    }
    
    let amountPadHeight = self.view.bounds.size.height * factor;
    amountPadViewController.view.frame = CGRect(x: 0, y: self.view.bounds.size.height + 100, width: self.view.bounds.size.width, height: amountPadHeight)
    
    if maskRect != nil {
      let maskLayer = CAShapeLayer()
      let path = UIBezierPath(rect: maskRect!(amountPadViewController))
      maskLayer.path = path.CGPath
      amountPadViewController.view.layer.mask = maskLayer
    }
    
    UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
      let ypos = self.view.bounds.size.height - amountPadViewController.view.bounds.size.height
      amountPadViewController.view.frame.origin = CGPoint(x: 0, y: ypos)
    }, completion: nil)
  }
  
  func closeAmountPad(amountPad: AmountPadViewController, completion: (() -> ())? = nil) {
    UIView.animateWithDuration(0.3, delay: 0.0, options: [], animations: {
      amountPad.view.frame.origin.y += self.view.frame.size.height
      }, completion: {_ in
        amountPad.view.removeFromSuperview()
    })
    amountPad.removeFromParentViewController()
    if let callback = completion {
      callback()
    }
  }
  
  func setupNavigationItemWithTitle(title: String, backButtonSelector: Selector, rightItem: UIBarButtonItem? = nil) {
    // Setup navigationBar
    self.navigationItem.title = title
    self.navigationItem.leftItemsSupplementBackButton = false
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: kTitleBackButton, style: UIBarButtonItemStyle.Plain, target: self, action: backButtonSelector)
    self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
    self.navigationItem.rightBarButtonItem = rightItem
    self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
  }
}
