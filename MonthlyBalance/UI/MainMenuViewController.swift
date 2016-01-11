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
    loadViewControllerWithIdentifier(kIdManageAccountsTableViewController) { navController, viewController in
      let homeViewController = navController.topViewController as! HomeViewController
      if let manageAccountsViewController = viewController as? ManageAccountsTableViewController {
        manageAccountsViewController.accountManagementDelegate = homeViewController
        if let account = self.settings?.selectedAccount, index = manageAccountsViewController.accounts.indexOf(account) {
          manageAccountsViewController.selectedAccountIndex = index
        }
      }
    }
  }

  @IBAction func manageEventsMenuItemPressed(sender: UIButton) {
    loadViewControllerWithIdentifier(kIdManageEventsTableViewController, beforePush: nil)
  }
  
  @IBAction func manageActivitiesMenuItemPressed(sender: UIButton) {
    loadViewControllerWithIdentifier(kIdManageActivitiesTableViewController, beforePush: nil)
  }
  
  @IBAction func settingsMenuItemPressed(sender: UIButton) {
    loadViewControllerWithIdentifier(kIdSettingsViewController, beforePush: nil)
  }
  
  private func loadViewControllerWithIdentifier(identifier: String, beforePush: ((UINavigationController, UIViewController) -> ())?) {
    if let svc = self.slideMenuViewController {
      svc.closeMenu(true)
      
      if let navController = svc.contentViewController as? UINavigationController {
        if let newViewController = self.storyboard?.instantiateViewControllerWithIdentifier(identifier) {
          if let callback = beforePush {
            callback(navController, newViewController)
          }
          
          navController.pushViewController(newViewController, animated: true)
        }
      }
    }
  }
}
