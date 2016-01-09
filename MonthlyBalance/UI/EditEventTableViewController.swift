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
  @IBOutlet weak var setAmountButton: UIButton!
  
  @IBOutlet weak var dayOfMonthSlider: UISlider!
  @IBOutlet weak var dayOfMonthLabel: UILabel!
  
  @IBOutlet weak var intervalSlider: UISlider!
  @IBOutlet weak var intervalLabel: UILabel!
  
}

extension EditEventTableViewController {
  @IBAction func setAmountButtonPressed(sender: UIButton) {
  }
  @IBAction func saveButtonPressed(sender: UIButton) {
  }
  @IBAction func cancelButtonPressed(sender: UIButton) {
  }
}
