//
//  EditEventFormViewController.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 27.02.16.
//  Copyright © 2016 Karrmarr Software. All rights reserved.
//

import UIKit
import Eureka

class EditEventFormViewController : FormViewController {
  
  var event: ScheduledEvent?
  var mode: ViewControllerMode = .Add
  var selectedEventType = 0

  let viewTitles = [ "Add new event", "Edit event" ]

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Setup navigation bar
    let saveButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveButtonPressed:")
    setupNavigationItemWithTitle(kTitleManageEvents, backButtonSelector: "cancelButtonPressed:", rightItem: saveButtonItem)
    
    let formatter = NSNumberFormatter()
    formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle

    // Check if controller is called in "edit" mode
    if self.event != nil {
      self.mode = .Edit
    }

    // Setup the form
    FormUtil.setupForm(self)

    form +++=
    
    Section("Manage Event") { section in
      FormUtil.configureSectionHeader(section, title: viewTitles[mode.rawValue])
    }

    <<< LabelRow() {
      $0.title = kExplanationEvent
    }

    form +++=
      
    Section("Title") { section in
      FormUtil.configureSectionHeader(section, title: "Title")
    }
      
    <<< TextRow("Title") {
      $0.title = "Title"
      $0.placeholder = "Title"
        
      if self.mode == .Edit {
        $0.value = self.event!.title
      }
    }

    form +++=
      
    Section("Event") { section in
      FormUtil.configureSectionHeader(section, title: "Event")
    }
      
    <<< SegmentedRow<String>("Type") {
      $0.options = [ "Income", "Expenditure" ]
    }.cellUpdate() { cell, row in
      if self.mode == .Edit {
        if Float(self.event!.amount!) > 0 {
          cell.segmentedControl.selectedSegmentIndex = 0
          self.selectedEventType = 0
        } else {
          cell.segmentedControl.selectedSegmentIndex = 1
          self.selectedEventType = 1
        }
        self.updateTextFieldColor()
        self.updateSegmentColor(cell.segmentedControl)
      } else {
        cell.segmentedControl.selectedSegmentIndex = 1
        self.selectedEventType = 1
        self.updateTextFieldColor()
        self.updateSegmentColor(cell.segmentedControl)
      }
    }.onChange({ row in
      self.selectedEventType = row.cell.segmentedControl.selectedSegmentIndex
      self.updateSegmentColor(row.cell.segmentedControl)
      self.updateTextFieldColor()
    })
      
    <<< DecimalRow("Amount") {
      $0.title = "Amount"
      $0.formatter = formatter
        
      if self.mode == .Edit {
        $0.value = abs(Float(self.event!.amount!))
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
    
    <<< SwitchRow("Recurring") {
      $0.title = "Recurring"
    }
    
    form +++=
    
    Section("Schedule") { section in
      FormUtil.configureSectionHeader(section, title: "Schedule")
    }

    <<< IntRow("DayOfMonth") {
      $0.title = "Day of month"
    }

    <<< IntRow("Interval") {
      $0.title = "Interval"
    }
  }

  func saveButtonPressed(sender: UIButton) {
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func cancelButtonPressed(sender: UIButton) {
    self.navigationController?.popViewControllerAnimated(true)    
  }
  
  func updateTextFieldColor() {
    if let row = form.rowByTag("Amount") as? DecimalRow {
      if self.selectedEventType == 1 {
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