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
  
  override func viewDidLoad() {
    // remove line below the navigation bar
    self.navigationBar.setBackgroundImage(UIImage(), forBarPosition: UIBarPosition.Any, barMetrics: UIBarMetrics.Default)
    self.navigationBar.shadowImage = UIImage()
    
    let placeholderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.7)
    let nameString = NSAttributedString(string: "Name", attributes: [ NSForegroundColorAttributeName : placeholderColor ])
    self.nameTextField.attributedPlaceholder = nameString
    let pwdString = NSAttributedString(string: "Password", attributes: [ NSForegroundColorAttributeName : placeholderColor ])
    self.passwordTextField.attributedPlaceholder = pwdString
  }
  
  @IBAction func createAccountButtonPressed(sender: UIButton) {
    if self.nameTextField.text! == "" {
      self.showAlertWithTitle("Error", message: "Please enter a name for your account!")
      return
    }
    
    Account.create(self.nameTextField.text!)

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


