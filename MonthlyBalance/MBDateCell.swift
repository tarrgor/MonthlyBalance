//
//  MBDateCell.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 16.02.16.
//  Copyright © 2016 Karrmarr Software. All rights reserved.
//

import UIKit
import Eureka

class MBDateCell : Cell<Date>, CellType {
  
  var dateButton: UIButton!
  var datePickerView: MBDatePickerView? = nil
  
  required init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func setup() {
    height = { 40 }
    super.setup()
    
    selectionStyle = .none
    
    dateButton = UIButton(type: .system)
    dateButton.frame = CGRect(x: 100, y: 10, width: 80, height: 20)
    dateButton.addTarget(self, action: #selector(dateButtonPressed(_:)), for: .touchUpInside)
    self.contentView.addSubview(dateButton)

    dateButton.snp.makeConstraints { make in
      make.topMargin.equalTo(self.contentView)
      make.trailingMargin.equalTo(self.contentView).inset(10)
    }
  }
  
  func dateButtonPressed(_ sender: UIButton) {
    showDatePicker()
  }
  
  fileprivate func showDatePicker() {
    if self.datePickerView != nil {
      return
    }
    
    let activityDate: Date? = self.row.value
    
    self.datePickerView = createDatePickerViewWithDate(activityDate!)
    
    // animate datePicker into View
    self.datePickerView!.frame.origin.y += self.datePickerView!.frame.size.height
    UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [ .curveEaseOut ], animations: {
      self.datePickerView!.frame.origin.y -= self.datePickerView!.frame.size.height
      }, completion: nil)
    
    self.formViewController()!.view.addSubview(self.datePickerView!)
  }
  
  fileprivate func hideDatePicker() {
    if self.datePickerView == nil {
      return
    }
    
    // animate datePicker out of View
    UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
      self.datePickerView!.frame.origin.y += self.datePickerView!.frame.size.height
      }, completion: { _ in
        self.datePickerView?.removeFromSuperview()
        self.datePickerView = nil
    })
  }

  fileprivate func createDatePickerViewWithDate(_ date: Date) -> MBDatePickerView {
    let rect = CGRect(x: 0, y: self.formViewController()!.view.bounds.size.height * 0.65, width: self.formViewController()!.view.bounds.width, height: self.formViewController()!.view.bounds.size.height - self.formViewController()!.view.bounds.size.height * 0.65)
    let blurEffect = UIBlurEffect(style: .extraLight)
    let picker = MBDatePickerView(effect: blurEffect)
    picker.frame = rect
    picker.date = date
    picker.onCancel = {
      self.hideDatePicker()
    }
    picker.onSelect = { date in
      self.hideDatePicker()
      
      self.row.value = date
      self.row.displayValueFor?(date)
    }
    
    return picker
  }
}
