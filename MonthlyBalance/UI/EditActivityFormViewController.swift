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
  
  var mode: ViewControllerMode = .Add
  
  var selectedActivityType = 0

  let viewTitles = [ "Add new activity", "Edit activity" ]

  override func viewDidLoad() {
    super.viewDidLoad()

    // Setup navigation bar
    let saveButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveButtonPressed:")
    setupNavigationItemWithTitle(kTitleManageActivities, backButtonSelector: "cancelButtonPressed:", rightItem: saveButtonItem)

    let formatter = NSNumberFormatter()
    formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle

    
    // Check if controller is called in "edit" mode
    if self.activity != nil {
      self.mode = .Edit
    }

    // Setup the form
    FormUtil.setupForm(self)

    form +++=

    Section("Manage Activity") { section in
      FormUtil.configureSectionHeader(section, title: viewTitles[mode.rawValue])
    }
      
    <<< LabelRow() {
      $0.title = kExplanationActivity
    }

    form +++=

    Section("Title") { section in
      FormUtil.configureSectionHeader(section, title: "Title")
    }

    <<< TextRow("Title") {
      $0.title = "Title"
      $0.placeholder = "Title"
      
      if self.mode == .Edit {
        $0.value = self.activity!.title
      }
    }
    
    form +++=
    
    Section("Activity") { section in
      FormUtil.configureSectionHeader(section, title: "Activity")
    }
    
    <<< SegmentedRow<String>("Type") {
      $0.options = [ "Income", "Expenditure" ]
    }.cellUpdate() { cell, row in
      if self.mode == .Edit {
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
      
      if self.mode == .Edit {
        $0.value = abs(Float(self.activity!.amount!))
      } else {
        $0.value = 0
      }
    }.cellUpdate({ cell, row in
      self.updateTextFieldColor()
    }).onChange({ row in
      if (row.value != nil) {
        row.value = abs(Float(row.value!))
        row.displayValueFor?(row.value)
      }
    })
      
    <<< MBDateRow("Date") {
      $0.title = "Date of activity"
      
      if self.mode == .Edit {
        $0.value = self.activity!.date!
      } else {
        $0.value = NSDate()
      }
    }
  }

  func saveButtonPressed(sender: UIButton) {
    let values = form.values()
    
    guard let title = values["Title"]! as? String else {
      self.showAlertWithTitle("Error", message: "Please enter a title for your activity!")
      return
    }
    guard let amount = values["Amount"]! as? Float else {
      self.showAlertWithTitle("Error", message: "Please enter an amount for your activity!")
      return
    }
    var date = values["Date"]! as? NSDate
    if date == nil {
      date = NSDate()
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
        self.activity!.amount = abs(amount) * factor
        self.activity!.date = date!
        self.activity!.update()
      }
    } else {
      print("No selected account found in the settings.")
    }

    if let callback = self.onSave {
      callback(self, self.activity)
    }
    
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func cancelButtonPressed(sender: UIButton) {
    if let callback = self.onCancel {
      callback(self)
    }
    
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func updateTextFieldColor() {
    if let row = form.rowByTag("Amount") as? DecimalRow {
      if self.selectedActivityType == 1 {
        row.cell.textField.textColor = UIColor.redColor()
      } else {
        row.cell.textField.textColor = UIColor.greenColor()
      }
    }
  }
  
  func updateSegmentColor(segmentedControl: UISegmentedControl) {
    if segmentedControl.selectedSegmentIndex == 0 {
      segmentedControl.tintColor = UIColor(hex: kColorIncome)
    } else {
      segmentedControl.tintColor = UIColor(hex: kColorExpenditure)
    }
  }
}
