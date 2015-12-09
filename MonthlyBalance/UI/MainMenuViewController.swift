//
//  MainMenuViewController.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 09.12.15.
//  Copyright © 2015 Karrmarr Software. All rights reserved.
//

import UIKit

class MainMenuViewController : UIViewController {
  
  @IBAction func manageAccountsMenuItemPressed(sender: UIButton) {
    if let svc = self.slideMenuViewController {
      svc.closeMenu(true)
      
      let navController = svc.contentViewController as? UINavigationController
      let manageAccountsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ManageAccountsTableViewController")
      navController?.pushViewController(manageAccountsViewController!, animated: true)
    }
  }
}
