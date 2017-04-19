//
// Created by Thorsten Klusemann on 14.02.16.
// Copyright (c) 2016 Karrmarr Software. All rights reserved.
//

import UIKit
import Eureka

typealias EditActivityOnSave = (EditActivityFormViewController, Activity?) -> ()
typealias EditActivityOnCancel = (EditActivityFormViewController) -> ()

class EditActivityFormViewController : FormViewController {

  var onSave: EditActivityOnSave?
  var onCancel: EditActivityOnCancel?
  
  var activity: Activity?
  
  var mode: ViewControllerMode = .add
  
  var selectedActivityType = 0

  let viewTitles = [ "Add new activity", "Edit activity" ]

  override func viewDidLoad() {
    super.viewDidLoad()

    // Setup navigation bar
    let saveButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonPressed(_:)))
    setupNavigationItemWithTitle(kTitleManageActivities, backButtonSelector: #selector(cancelButtonPressed(_:)), rightItem: saveButtonItem)

    let formatter = NumberFormatter()
    formatter.numberStyle = NumberFormatter.Style.currency

    
    // Check if controller is called in "edit" mode
    if self.activity != nil {
      self.mode = .edit
    }

    // Setup the form
    FormUtil.setupForm(self)

    form +++

    Section("Manage Activity") { section in
      FormUtil.configureSectionHeader(section, title: viewTitles[mode.rawValue])
    }
      
    <<< LabelRow() {
      $0.title = kExplanationActivity
    }

    form +++

    Section("Title") { section in
      FormUtil.configureSectionHeader(section, title: "Title")
    }

    <<< TextRow("Title") {
      $0.title = "Title"
      $0.placeholder = "Title"
      
      if self.mode == .edit {
        $0.value = self.activity!.title
      }
    }
    
    form +++
    
    Section("Activity") { section in
      FormUtil.configureSectionHeader(section, title: "Activity")
    }
    
    <<< SegmentedRow<String>("Type") {
      $0.options = [ "Income", "Expenditure" ]
    }.cellUpdate() { cell, row in
      if self.mode == .edit {
        if Float(self.activity!.amount!) > 0 {
          cell.segmentedControl.selectedSegmentIndex = 0
          self.selectedActivityType = 0
        } else {
          cell.segmentedControl.selectedSegmentIndex = 1
          self.selectedActivityType = 1
        }
        self.updateTextFieldColor()
        self.updateSegmentColor(cell.segmentedControl)
      } else {
        cell.segmentedControl.selectedSegmentIndex = 1
        self.selectedActivityType = 1
        self.updateTextFieldColor()
        self.updateSegmentColor(cell.segmentedControl)
      }
    }.onChange({ row in
      self.selectedActivityType = row.cell.segmentedControl.selectedSegmentIndex
      self.updateSegmentColor(row.cell.segmentedControl)
      self.updateTextFieldColor()
    })
      
    <<< DecimalRow("Amount") {
      $0.title = "Amount"
      $0.formatter = formatter
      
      if self.mode == .edit {
        $0.value = abs(self.activity!.amount!.doubleValue)
      } else {
        $0.value = 0
      }
    }.cellUpdate({ cell, row in
      self.updateTextFieldColor()
    }).onChange({ row in
      if (row.value != nil) {
        row.value = abs(row.value!)
        row.displayValueFor?(row.value)
      }
    })
      
    <<< MBDateRow("Date") {
      $0.title = "Date of activity"
      
      if self.mode == .edit {
        $0.value = self.activity!.date!
      } else {
        $0.value = Date()
      }
    }
  }

  func saveButtonPressed(_ sender: UIButton) {
    let values = form.values()
    
    guard let title = values["Title"]! as? String else {
      self.showAlertWithTitle("Error", message: "Please enter a title for your activity!")
      return
    }
    guard let amount = values["Amount"]! as? Float else {
      self.showAlertWithTitle("Error", message: "Please enter an amount for your activity!")
      return
    }
    var date = values["Date"]! as? Date
    if date == nil {
      date = Date()
    }

    var factor: Float = 1.0
    if let type = values["Type"]! as? String {
      if type == "Expenditure" {
        factor = -1.0
      }
    } else {
      factor = -1.0
    }
    
    if let account = self.settings?.selectedAccount {
      if self.activity == nil {
        self.activity = account.addActivityForDate(date!, title: title, icon: "", amount: Double(abs(amount) * factor))
      } else {
        account.recalculateTotalsForUpdateActivity(self.activity!, newAmount: Double(amount), newDate: date!)
        
        self.activity!.title = title
        self.activity!.amount = NSNumber(value: abs(amount) * factor)
        self.activity!.date = date!
        self.activity!.update()
      }
    } else {
      print("No selected account found in the settings.")
    }

    if let callback = self.onSave {
      callback(self, self.activity)
    }
    
    self.navigationController?.popViewController(animated: true)
  }
  
  func cancelButtonPressed(_ sender: UIButton) {
    if let callback = self.onCancel {
      callback(self)
    }
    
    self.navigationController?.popViewController(animated: true)
  }
  
  func updateTextFieldColor() {
    if let row = form.rowBy(tag: "Amount") as? DecimalRow {
      if self.selectedActivityType == 1 {
        row.cell.textField.textColor = UIColor.red
      } else {
        row.cell.textField.textColor = UIColor.green
      }
    }
  }
  
  func updateSegmentColor(_ segmentedControl: UISegmentedControl) {
    if segmentedControl.selectedSegmentIndex == 0 {
      segmentedControl.tintColor = UIColor(hex: kColorIncome)
    } else {
      segmentedControl.tintColor = UIColor(hex: kColorExpenditure)
    }
  }
}
