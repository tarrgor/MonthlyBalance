//
//  EditEventTableViewController.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 09.01.16.
//  Copyright © 2016 Karrmarr Software. All rights reserved.
//

import UIKit

class EditEventTableViewController : UITableViewController {
  
  var event: ScheduledEvent!
  
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var recurringSwitch: UISwitch!
  
  @IBOutlet weak var amountLabel: MBAmountLabel!
  
  @IBOutlet weak var dayOfMonthSlider: UISlider!
  @IBOutlet weak var dayOfMonthLabel: UILabel!
  
  @IBOutlet weak var intervalSlider: UISlider!
  @IBOutlet weak var intervalLabel: UILabel!
  
  @IBAction func saveButtonPressed(sender: UIButton) {
  }
  
  @IBAction func cancelButtonPressed(sender: UIButton) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func incomeButtonPressed(sender: UIButton) {
    openAmountPadInMode(.Income, delegate: self)
  }
  
  @IBAction func expenditureButtonPressed(sender: UIButton) {
    openAmountPadInMode(.Expenditure, delegate: self)
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



