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
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    return appDelegate?.settings
  }
  
  var slideMenuViewController : SlideMenuViewController? {
    var controller: SlideMenuViewController? = nil
    var parent: UIViewController? = self.parent
    
    while controller == nil && parent != nil {
      if parent!.isKind(of: SlideMenuViewController.self) {
        controller = parent as? SlideMenuViewController
      } else {
        parent = parent?.parent
      }
    }
    
    return controller
  }
  
  func showAlertWithTitle(_ title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    alertController.addAction(UIAlertAction(title: kTitleOkButton, style: UIAlertActionStyle.default, handler: nil))
    self.present(alertController, animated: true, completion: nil)
  }
  
  func showConfirmationDialogWithTitle(_ title: String, message: String, confirmed: ((UIAlertAction) -> Void)? = nil) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    alertController.addAction(UIAlertAction(title: kTitleCancelButton, style: UIAlertActionStyle.default, handler: nil))
    alertController.addAction(UIAlertAction(title: kTitleOkButton, style: UIAlertActionStyle.default, handler: confirmed))
    self.present(alertController, animated: true, completion: nil)
  }
  
  func openAmountPadInMode(_ mode: AmountPadMode, okHandler: AmountPadViewOk?, cancelHandler: AmountPadViewCancel? = nil, maskRect: ((AmountPadViewController) -> (CGRect))? = nil) {
    let amountPadViewController = AmountPadViewController()
    amountPadViewController.onOk = okHandler
    amountPadViewController.onCancel = cancelHandler
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
      maskLayer.path = path.cgPath
      amountPadViewController.view.layer.mask = maskLayer
    }
    
    UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
      let ypos = self.view.bounds.size.height - amountPadViewController.view.bounds.size.height
      amountPadViewController.view.frame.origin = CGPoint(x: 0, y: ypos)
    }, completion: nil)
  }
  
  func closeAmountPad(_ amountPad: AmountPadViewController, completion: (() -> ())? = nil) {
    UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
      amountPad.view.frame.origin.y += self.view.frame.size.height
      }, completion: {_ in
        amountPad.view.removeFromSuperview()
    })
    amountPad.removeFromParentViewController()
    if let callback = completion {
      callback()
    }
  }
  
  func setupNavigationItemWithTitle(_ title: String, backButtonSelector: Selector, rightItem: UIBarButtonItem? = nil) {
    // Setup navigationBar
    self.navigationItem.title = title
    self.navigationItem.leftItemsSupplementBackButton = false
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: kTitleBackButton, style: UIBarButtonItemStyle.plain, target: self, action: backButtonSelector)
    self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
    self.navigationItem.rightBarButtonItem = rightItem
    self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
  }
}
