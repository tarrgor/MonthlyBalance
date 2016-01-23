//
//  MBDatePickerView.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 20.01.16.
//  Copyright © 2016 Karrmarr Software. All rights reserved.
//

import UIKit

class MBDatePickerView : UIVisualEffectView {
  
  var date: NSDate = NSDate() {
    didSet {
      self.datePicker.setDate(self.date, animated: true)
    }
  }
  
  var datePicker: UIDatePicker!
  
  var onCancel: (() -> ())?
  var onSelect: ((NSDate) -> ())?
  
  override init(effect: UIVisualEffect?) {
    super.init(effect: effect)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  func setup() {
    self.datePicker = UIDatePicker(frame: CGRectZero)
    self.datePicker.date = self.date
    self.datePicker.datePickerMode = .Date
    self.datePicker.translatesAutoresizingMaskIntoConstraints = false
    
    let cancelButton = UIButton(type: .System)
    cancelButton.frame = CGRectZero
    cancelButton.setTitle("Cancel", forState: .Normal)
    cancelButton.translatesAutoresizingMaskIntoConstraints = false
    cancelButton.addTarget(self, action: "cancelButtonPressed:", forControlEvents: .TouchUpInside)
    
    let selectButton = UIButton(type: .System)
    selectButton.frame = CGRectZero
    selectButton.setTitle("Select", forState: .Normal)
    selectButton.translatesAutoresizingMaskIntoConstraints = false
    selectButton.addTarget(self, action: "selectButtonPressed:", forControlEvents: .TouchUpInside)
    
    self.addSubview(cancelButton)
    self.addSubview(selectButton)
    self.addSubview(datePicker)
    
    // add constraints
    NSLayoutConstraint.activateConstraints([
      cancelButton.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 5),
      cancelButton.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 20),

      selectButton.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 5),
      selectButton.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: -20),
      
      self.datePicker.topAnchor.constraintEqualToAnchor(cancelButton.bottomAnchor, constant: 5),
      self.datePicker.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor),
      self.datePicker.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor)
    ])
  }
  
  func cancelButtonPressed(sender: UIButton) {
    if onCancel != nil {
      onCancel!()
    }
  }
  
  func selectButtonPressed(sender: UIButton) {
    if onSelect != nil {
      self.date = self.datePicker.date
      onSelect!(self.date)
    }
  }
}
