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
  var mode: ViewControllerMode = .add
  var selectedEventType = 0

  let viewTitles = [ "Add new event", "Edit event" ]

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Setup navigation bar
    let saveButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonPressed(_:)))
    setupNavigationItemWithTitle(kTitleManageEvents, backButtonSelector: #selector(cancelButtonPressed(_:)), rightItem: saveButtonItem)
    
    let formatter = NumberFormatter()
    formatter.numberStyle = NumberFormatter.Style.currency

    // Check if controller is called in "edit" mode
    if self.event != nil {
      self.mode = .edit
    }

    // Setup the form
    FormUtil.setupForm(self)

    form +++
    
    Section("Manage Event") { section in
      FormUtil.configureSectionHeader(section, title: viewTitles[mode.rawValue])
    }

    <<< LabelRow() {
      $0.title = kExplanationEvent
    }

    form +++
      
    Section("Title") { section in
      FormUtil.configureSectionHeader(section, title: "Title")
    }
      
    <<< TextRow("Title") {
      $0.title = "Title"
      $0.placeholder = "Title"
        
      if self.mode == .edit {
        $0.value = self.event!.title
      }
    }

    form +++
      
    Section("Event") { section in
      FormUtil.configureSectionHeader(section, title: "Event")
    }
      
    <<< SegmentedRow<String>("Type") {
      $0.options = [ "Income", "Expenditure" ]
    }.cellUpdate() { cell, row in
      if self.mode == .edit {
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
        
      if self.mode == .edit {
        $0.value = abs(self.event!.amount!.doubleValue)
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
    
    <<< SwitchRow("Recurring") {
      $0.title = "Recurring"
    }
    
    form +++
    
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

  func saveButtonPressed(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  func cancelButtonPressed(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)    
  }
  
  func updateTextFieldColor() {
    if let row = form.rowBy(tag: "amount") as? DecimalRow {
      if self.selectedEventType == 1 {
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
