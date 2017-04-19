//
//  EditEventTableViewController.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 09.01.16.
//  Copyright © 2016 Karrmarr Software. All rights reserved.
//

import UIKit

typealias EditEventOnSave = (EditEventTableViewController, ScheduledEvent?) -> ()
typealias EditEventOnCancel = (EditEventTableViewController) -> ()

class EditEventTableViewController : UITableViewController {
  
  var event: ScheduledEvent?
  
  let viewTitles = [ "Add new events", "Edit event" ]
  
  var mode: ViewControllerMode = .add

  var onSave: EditEventOnSave?
  var onCancel: EditEventOnCancel?
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var recurringSwitch: UISwitch!
  
  @IBOutlet weak var amountLabel: MBAmountLabel!
  
  @IBOutlet weak var dayOfMonthSlider: UISlider!
  @IBOutlet weak var dayOfMonthLabel: UILabel!
  
  @IBOutlet weak var intervalSlider: UISlider!
  @IBOutlet weak var intervalLabel: UILabel!
  
  override func viewDidLoad() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(EditEventTableViewController.viewTapped))
    self.view.addGestureRecognizer(tap);
    
    let saveButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(EditEventTableViewController.saveButtonPressed(_:)))
    setupNavigationItemWithTitle(kTitleManageEvents, backButtonSelector: #selector(cancelButtonPressed(_:)), rightItem: saveButtonItem)
    
    // Check if controller is called in "edit" mode
    if self.event != nil {
      self.mode = .edit
      self.titleLabel.text = self.viewTitles[1]
      
      self.titleTextField.text = self.event!.title
      self.amountLabel.amount = Double(self.event!.amount!)
      self.recurringSwitch.isOn = Bool(self.event!.recurring!)
      self.dayOfMonthSlider.value = Float(self.event!.dayOfMonth!)
      self.dayOfMonthLabel.text = String(Int(self.dayOfMonthSlider.value))
      self.intervalSlider.value = Float(self.event!.interval!)
      self.intervalLabel.text = String(Int(self.intervalSlider.value))
    } else {
      self.titleLabel.text = self.viewTitles[0]
    }
  }
  
  @IBAction func saveButtonPressed(_ sender: UIButton) {
    let title = self.titleTextField.text
    if title == nil || title?.characters.count == 0 {
      self.showAlertWithTitle("Error!", message: "Please enter a title.")
      return
    }
    
    if let account = self.settings?.selectedAccount {
      let recurring = self.recurringSwitch.isOn
      let dayOfMonth = Int(self.dayOfMonthSlider.value)
      let interval = Int(self.intervalSlider.value)
      let amount = self.amountLabel.amount
      
      if self.event == nil {
        self.event = account.addEventWithTitle(title!, icon: "", recurring: recurring, dayOfMonth: dayOfMonth, interval: interval, amount: amount)
      } else {
        self.event!.title = title
        self.event!.recurring = recurring as NSNumber
        self.event!.dayOfMonth = dayOfMonth as NSNumber
        self.event!.interval = interval as NSNumber
        self.event!.amount = amount as NSNumber
        self.event!.nextDueDate = Date().nextDateWithDayOfMonth(dayOfMonth)
        self.event!.update()
      }
    } else {
      print("No selected account found in the settings.")
    }
    
    if let callback = self.onSave {
      callback(self, self.event)
    }
    
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func cancelButtonPressed(_ sender: UIButton) {
    if let callback = self.onCancel {
      callback(self)
    }
    
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func incomeButtonPressed(_ sender: UIButton) {
    openAmountPadInMode(.income, okHandler: { amountPad in
      self.amountLabel.amount = amountPad.finalAmount
      self.closeAmountPad(amountPad)
    }, cancelHandler: { amountPad in
      self.closeAmountPad(amountPad)
    })
  }
  
  @IBAction func expenditureButtonPressed(_ sender: UIButton) {
    openAmountPadInMode(.expenditure, okHandler: { amountPad in
      self.amountLabel.amount = amountPad.finalAmount
      self.closeAmountPad(amountPad)
    }, cancelHandler: { amountPad in
      self.closeAmountPad(amountPad)
    })
  }
  
  @IBAction func dayOfMonthSliderChanged(_ sender: UISlider) {
    self.dayOfMonthLabel.text = String(Int(self.dayOfMonthSlider.value))
  }
  
  @IBAction func intervalSliderChanged(_ sender: UISlider) {
    self.intervalLabel.text = String(Int(self.intervalSlider.value))
  }
  
  func viewTapped() {
    self.titleTextField.resignFirstResponder()
  }
}

extension EditEventTableViewController : UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.titleTextField.resignFirstResponder()
    return true
  }
}

