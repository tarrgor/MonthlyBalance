//
//  EditEventTableViewController.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 09.01.16.
//  Copyright © 2016 Karrmarr Software. All rights reserved.
//

import UIKit

class EditEventTableViewController : UITableViewController {
  
  var event: ScheduledEvent?
  
  var delegate: EditEventDelegate?
  
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var recurringSwitch: UISwitch!
  
  @IBOutlet weak var amountLabel: MBAmountLabel!
  
  @IBOutlet weak var dayOfMonthSlider: UISlider!
  @IBOutlet weak var dayOfMonthLabel: UILabel!
  
  @IBOutlet weak var intervalSlider: UISlider!
  @IBOutlet weak var intervalLabel: UILabel!
  
  override func viewDidLoad() {
    let tap = UITapGestureRecognizer(target: self, action: "viewTapped")
    
    self.view.addGestureRecognizer(tap);
    
    let saveButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveButtonPressed:")
    setupNavigationItemWithTitle(kTitleManageEvents, backButtonSelector: "cancelButtonPressed:", rightItem: saveButtonItem)
  }
  
  @IBAction func saveButtonPressed(sender: UIButton) {
    let title = self.titleTextField.text
    if title == nil || title?.characters.count == 0 {
      self.showAlertWithTitle("Error!", message: "Please enter a title.")
      return
    }
    
    if let account = self.settings?.selectedAccount {
      let recurring = self.recurringSwitch.on
      let dayOfMonth = Int(self.dayOfMonthSlider.value)
      let interval = Int(self.intervalSlider.value)
      let amount = self.amountLabel.amount
      
      self.event = account.addEventWithTitle(title!, icon: "", recurring: recurring, dayOfMonth: dayOfMonth, interval: interval, amount: amount)
    } else {
      print("No selected account found in the settings.")
    }
    
    self.delegate?.editEventViewControllerDidSaveEvent(self, event: self.event)
    
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  @IBAction func cancelButtonPressed(sender: UIButton) {
    self.delegate?.editEventViewControllerDidCancelEvent(self)
    
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  @IBAction func incomeButtonPressed(sender: UIButton) {
    openAmountPadInMode(.Income, delegate: self)
  }
  
  @IBAction func expenditureButtonPressed(sender: UIButton) {
    openAmountPadInMode(.Expenditure, delegate: self)
  }
  
  @IBAction func dayOfMonthSliderChanged(sender: UISlider) {
    self.dayOfMonthLabel.text = String(Int(self.dayOfMonthSlider.value))
  }
  
  @IBAction func intervalSliderChanged(sender: UISlider) {
    self.intervalLabel.text = String(Int(self.intervalSlider.value))
  }
  
  func viewTapped() {
    self.titleTextField.resignFirstResponder()
  }
}

extension EditEventTableViewController : AmountPadDelegate {
  func amountPadDidPressOk(amountPad: AmountPadViewController) {
    self.amountLabel.amount = amountPad.finalAmount
    closeAmountPad(amountPad)
  }
  
  func amountPadDidPressCancel(amountPad: AmountPadViewController) {
    closeAmountPad(amountPad)
  }
}

extension EditEventTableViewController : UITextFieldDelegate {
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    self.titleTextField.resignFirstResponder()
    return true
  }
}

