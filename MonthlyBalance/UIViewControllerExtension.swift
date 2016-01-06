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
  
}
