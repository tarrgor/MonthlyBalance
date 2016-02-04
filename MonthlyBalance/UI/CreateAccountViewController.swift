//
//  CreateAccountViewController.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 30.11.15.
//  Copyright © 2015 Karrmarr Software. All rights reserved.
//

import UIKit

typealias OnCreateAccount = (UIViewController, Account) -> ()

class CreateAccountViewController : UITableViewController {
  
  @IBOutlet weak var nameTextField: MBTextField!
  @IBOutlet weak var passwordTextField: MBTextField!
  
  var onCreateAccount: OnCreateAccount?
  
  override func viewDidLoad() {
    let saveButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveButtonPressed:")
    setupNavigationItemWithTitle(kTitleManageAccounts, backButtonSelector: "backButtonPressed:", rightItem: saveButtonItem)
  }
  
  func backButtonPressed(sender: UIBarButtonItem) {
    self.navigationController?.popViewControllerAnimated(true)    
  }
  
  @IBAction func saveButtonPressed(sender: UIBarButtonItem) {
    if self.nameTextField.text! == "" {
      self.showAlertWithTitle("Error", message: "Please enter a name for your account!")
      return
    }
    
    let newAccount = Account.create(self.nameTextField.text!)
    self.settings?.selectedAccount = newAccount

    if let callback = self.onCreateAccount {
      callback(self, newAccount!)
    }
    
    self.navigationController?.popViewControllerAnimated(true)
  }
}

extension CreateAccountViewController : UITextFieldDelegate {
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if textField == self.nameTextField {
      self.passwordTextField.becomeFirstResponder()
    } else if textField == self.passwordTextField {
      self.passwordTextField.resignFirstResponder()
    }
    
    return true
  }
  
}


