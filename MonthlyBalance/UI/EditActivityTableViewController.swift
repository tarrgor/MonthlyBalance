//
//  EditActivityTableViewController.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 12.01.16.
//  Copyright © 2016 Karrmarr Software. All rights reserved.
//

import UIKit

class EditActivityTableViewController : UITableViewController {
  
  let viewTitles = [ "Add new activity", "Edit activity" ]
  
  var activity: Activity?
  
  var mode: ViewControllerMode = .Add
  
  var delegate: EditActivityDelegate?
  
  @IBOutlet weak var titleTextField: UITextField!
  
  @IBOutlet weak var amountLabel: MBAmountLabel!
  
  @IBOutlet weak var dateButton: UIButton!
  
  @IBOutlet weak var titleLabel: UILabel!
  
  override func viewDidLoad() {
    // Add a gesture recognizer to remove keyboard when tapped somewhere
    let tap = UITapGestureRecognizer(target: self, action: "viewTapped")
    self.view.addGestureRecognizer(tap);
    
    // Check if controller is called in "edit" mode
    if self.activity != nil {
      self.mode = .Edit
      self.titleLabel.text = self.viewTitles[1]
      
      self.titleTextField.text = self.activity!.title
      self.amountLabel.amount = Double(self.activity!.amount!)
      
      let dateStr = NSDateFormatter.localizedStringFromDate(self.activity!.date!, dateStyle: .ShortStyle, timeStyle: .NoStyle)
      self.dateButton.setTitle(dateStr, forState: .Normal)
    } else {
      self.titleLabel.text = self.viewTitles[0]
    }
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
      
      if self.activity == nil {
        self.activity = account.addActivityForDate(date, title: title!, icon: "", amount: amount)
      } else {
        account.recalculateTotalsForUpdateActivity(self.activity!, newAmount: amount, newDate: date)
        
        self.activity!.title = title
        self.activity!.amount = amount
        self.activity!.date = date
        self.activity!.update()
      }
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
