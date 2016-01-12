//
//  EditActivityTableViewController.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 12.01.16.
//  Copyright © 2016 Karrmarr Software. All rights reserved.
//

import UIKit

class EditActivityTableViewController : UITableViewController {
  
  var activity: Activity?
  
  var delegate: EditActivityDelegate?
  
  @IBOutlet weak var titleTextField: UITextField!
  
  @IBOutlet weak var amountLabel: MBAmountLabel!
  
  @IBOutlet weak var dateButton: UIButton!
  
  override func viewDidLoad() {
    let tap = UITapGestureRecognizer(target: self, action: "viewTapped")
    
    self.view.addGestureRecognizer(tap);
  }
  
  @IBAction func saveButtonPressed(sender: UIButton) {
    let title = self.titleTextField.text
    if title == nil || title?.characters.count == 0 {
      self.showAlertWithTitle("Error!", message: "Please enter a title.")
      return
    }
    
    if let account = self.settings?.selectedAccount {
      let amount = self.amountLabel.amount
      let title = self.titleTextField.text
      let date: NSDate = NSDate()
      
      self.activity = account.addActivityForDate(date, title: title!, icon: "", amount: amount)
    } else {
      print("No selected account found in the settings.")
    }
    
    self.delegate?.editActivityViewControllerDidSaveEvent(self, activity: self.activity)
    
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func cancelButtonPressed(sender: UIButton) {
    self.delegate?.editActivityViewControllerDidCancelEvent(self)
    
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func incomeButtonPressed(sender: UIButton) {
    openAmountPadInMode(.Income, delegate: self)
  }
  
  @IBAction func expenditureButtonPressed(sender: UIButton) {
    openAmountPadInMode(.Expenditure, delegate: self)
  }
  
  @IBAction func dateButtonPressed(sender: UIButton) {
  }
  
  func viewTapped() {
    self.titleTextField.resignFirstResponder()
  }
}

extension EditActivityTableViewController : AmountPadDelegate {
  func amountPadDidPressOk(amountPad: AmountPadViewController) {
    self.amountLabel.amount = amountPad.finalAmount
    closeAmountPad(amountPad)
  }
  
  func amountPadDidPressCancel(amountPad: AmountPadViewController) {
    closeAmountPad(amountPad)
  }
}

extension EditActivityTableViewController : UITextFieldDelegate {
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    self.titleTextField.resignFirstResponder()
    return true
  }
}
