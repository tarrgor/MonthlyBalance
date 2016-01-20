//
//  CreateAccountViewController.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 30.11.15.
//  Copyright © 2015 Karrmarr Software. All rights reserved.
//

import UIKit

class CreateAccountViewController : UIViewController {
  
  @IBOutlet weak var navigationBar: UINavigationBar!
  
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  var delegate: CreateAccountDelegate?
  
  override func viewDidLoad() {
    // remove line below the navigation bar
    self.navigationBar.setBackgroundImage(UIImage(), forBarPosition: UIBarPosition.Any, barMetrics: UIBarMetrics.Default)
    self.navigationBar.shadowImage = UIImage()    
  }
  
  @IBAction func createAccountButtonPressed(sender: UIButton) {
    if self.nameTextField.text! == "" {
      self.showAlertWithTitle("Error", message: "Please enter a name for your account!")
      return
    }
    
    let newAccount = Account.create(self.nameTextField.text!)
    self.settings?.selectedAccount = newAccount

    self.delegate?.createAccountViewControllerDidCreateAccount(self, account: newAccount!)
    
    self.dismissViewControllerAnimated(true, completion: nil)
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


