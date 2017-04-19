//
//  MBDatePickerView.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 20.01.16.
//  Copyright © 2016 Karrmarr Software. All rights reserved.
//

import UIKit

class MBDatePickerView : UIVisualEffectView {
  
  var date: Date = Date() {
    didSet {
      self.datePicker.setDate(self.date, animated: true)
    }
  }
  
  var datePicker: UIDatePicker!
  
  var onCancel: (() -> ())?
  var onSelect: ((Date) -> ())?
  
  override init(effect: UIVisualEffect?) {
    super.init(effect: effect)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  func setup() {
    self.datePicker = UIDatePicker(frame: CGRect.zero)
    self.datePicker.date = self.date
    self.datePicker.datePickerMode = .date
    self.datePicker.translatesAutoresizingMaskIntoConstraints = false
    
    let cancelButton = UIButton(type: .system)
    cancelButton.frame = CGRect.zero
    cancelButton.setTitle("Cancel", for: UIControlState())
    cancelButton.translatesAutoresizingMaskIntoConstraints = false
    cancelButton.addTarget(self, action: #selector(MBDatePickerView.cancelButtonPressed(_:)), for: .touchUpInside)
    
    let selectButton = UIButton(type: .system)
    selectButton.frame = CGRect.zero
    selectButton.setTitle("Select", for: UIControlState())
    selectButton.translatesAutoresizingMaskIntoConstraints = false
    selectButton.addTarget(self, action: #selector(MBDatePickerView.selectButtonPressed(_:)), for: .touchUpInside)
    
    self.addSubview(cancelButton)
    self.addSubview(selectButton)
    self.addSubview(datePicker)
    
    // add constraints
    NSLayoutConstraint.activate([
      cancelButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
      cancelButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),

      selectButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
      selectButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
      
      self.datePicker.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 5),
      self.datePicker.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      self.datePicker.trailingAnchor.constraint(equalTo: self.trailingAnchor)
    ])
  }
  
  func cancelButtonPressed(_ sender: UIButton) {
    if onCancel != nil {
      onCancel!()
    }
  }
  
  func selectButtonPressed(_ sender: UIButton) {
    if onSelect != nil {
      self.date = self.datePicker.date
      onSelect!(self.date)
    }
  }
}
