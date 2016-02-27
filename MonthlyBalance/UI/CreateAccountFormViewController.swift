//
//  CreateAccountFormViewController.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 30.11.15.
//  Copyright © 2015 Karrmarr Software. All rights reserved.
//

import UIKit
import Eureka

typealias OnCreateAccount = (UIViewController, Account) -> ()

class CreateAccountFormViewController: FormViewController {
  
  var onCreateAccount: OnCreateAccount?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // init navigation bar
    let saveButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveButtonPressed:")
    setupNavigationItemWithTitle(kTitleManageAccounts, backButtonSelector: "backButtonPressed:", rightItem: saveButtonItem)

    // customize appearance of form
    FormUtil.setupForm(self)
    
    form +++=
      
      Section("Create account") { section in
        FormUtil.configureSectionHeader(section, title: kTitleCreateAccount)
      }
      <<< TextRow("Name") {
        $0.title = "Name"
        $0.placeholder = "Account Name"
      }
      <<< PasswordRow("Password") {
        $0.title = "Password"
        $0.placeholder = "Password"
    }
  }
  
  func backButtonPressed(sender: UIBarButtonItem) {
    self.navigationController?.popViewControllerAnimated(true)    
  }
  
  @IBAction func saveButtonPressed(sender: UIBarButtonItem) {
    let values = form.values()

    if values["Name"]! == nil {
      self.showAlertWithTitle("Error", message: "Please enter a name for your account!")
      return
    }
    
    let newAccount = Account.create(values["Name"]! as! String)
    self.settings?.selectedAccount = newAccount

    if let callback = self.onCreateAccount {
      callback(self, newAccount!)
    }

    self.navigationController?.popViewControllerAnimated(true)
  }
  
}

