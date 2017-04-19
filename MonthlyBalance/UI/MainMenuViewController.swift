//
//  MainMenuViewController.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 09.12.15.
//  Copyright © 2015 Karrmarr Software. All rights reserved.
//

import UIKit

class MainMenuViewController : UIViewController {
  
  @IBAction func manageAccountsMenuItemPressed(_ sender: UIButton) {
    loadViewControllerWithIdentifier(kIdManageAccountsTableViewController) { navController, viewController in
      let homeViewController = navController.topViewController as! HomeViewController
      if let manageAccountsViewController = viewController as? ManageAccountsTableViewController {
        manageAccountsViewController.onChangeSelection = homeViewController.didChangeAccountSelection
        if let account = self.settings?.selectedAccount, let index = manageAccountsViewController.accounts.index(of: account) {
          manageAccountsViewController.selectedAccountIndex = index
        }
      }
    }
  }

  @IBAction func manageEventsMenuItemPressed(_ sender: UIButton) {
    loadViewControllerWithIdentifier(kIdManageEventsTableViewController, beforePush: nil)
  }
  
  @IBAction func manageActivitiesMenuItemPressed(_ sender: UIButton) {
    loadViewControllerWithIdentifier(kIdManageActivitiesTableViewController, beforePush: nil)
  }
  
  @IBAction func settingsMenuItemPressed(_ sender: UIButton) {
    loadViewControllerWithIdentifier(kIdSettingsViewController, beforePush: nil)
  }
  
  fileprivate func loadViewControllerWithIdentifier(_ identifier: String, beforePush: ((UINavigationController, UIViewController) -> ())?) {
    if let svc = self.slideMenuViewController {
      svc.closeMenu(true)
      
      if let navController = svc.contentViewController as? UINavigationController {
        if let newViewController = self.storyboard?.instantiateViewController(withIdentifier: identifier) {
          if let callback = beforePush {
            callback(navController, newViewController)
          }
          
          navController.pushViewController(newViewController, animated: true)
        }
      }
    }
  }
}
