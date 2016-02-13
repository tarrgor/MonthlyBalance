//
//  CreateAccountViewController.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 30.11.15.
//  Copyright © 2015 Karrmarr Software. All rights reserved.
//

import UIKit
import Eureka

typealias OnCreateAccount = (UIViewController, Account) -> ()

class CreateAccountViewController : FormViewController {
  
  var onCreateAccount: OnCreateAccount?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // init navigation bar
    let saveButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveButtonPressed:")
    setupNavigationItemWithTitle(kTitleManageAccounts, backButtonSelector: "backButtonPressed:", rightItem: saveButtonItem)

    // customize appearance of form
    self.tableView?.backgroundColor = UIColor(hex: kColorBaseBackground)
    setupFormRows()
    
    form +++=
      
      Section("Create account") { section in
        var header = HeaderFooterView<MBSectionHeaderView>(HeaderFooterProvider.Class)
        
        header.height = { return 70 }
        header.onSetupView = { view, section, form in
          view.title = kTitleCreateAccount
        }
        
        section.header = header
      }
      <<< TextRow() {
        $0.title = "Name"
        $0.placeholder = "Account Name"
      }
      <<< PasswordRow() {
        $0.title = "Password"
        $0.placeholder = "Password"
    }
  }
  
  func backButtonPressed(sender: UIBarButtonItem) {
    self.navigationController?.popViewControllerAnimated(true)    
  }
  
  @IBAction func saveButtonPressed(sender: UIBarButtonItem) {
    /*
    if self.nameTextField.text! == "" {
      self.showAlertWithTitle("Error", message: "Please enter a name for your account!")
      return
    }
    
    let newAccount = Account.create(self.nameTextField.text!)
    self.settings?.selectedAccount = newAccount

    if let callback = self.onCreateAccount {
      callback(self, newAccount!)
    }
    */
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  private func setupFormRows() {
    TextRow.defaultCellSetup = { cell, row in
      let r = row as TextRow
      r.placeholderColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
    }
    TextRow.defaultCellUpdate = { cell, row in
      let c = cell as TextCell
      c.backgroundColor = UIColor(hex: kColorSecondBackground)
      c.textLabel?.textColor = UIColor.whiteColor()
      c.tintColor = UIColor(hex: kColorHighlightedText)
    }
    PasswordRow.defaultCellSetup = { cell, row in
      let r = row as PasswordRow
      r.placeholderColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
    }
    PasswordRow.defaultCellUpdate = { cell, row in
      let c = cell as PasswordCell
      c.backgroundColor = UIColor(hex: kColorSecondBackground)
      c.textLabel?.textColor = UIColor.whiteColor()
      c.tintColor = UIColor(hex: kColorHighlightedText)
    }
  }
}

/*
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
*/

