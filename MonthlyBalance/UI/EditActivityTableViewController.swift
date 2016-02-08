//
//  EditActivityTableViewController.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 12.01.16.
//  Copyright © 2016 Karrmarr Software. All rights reserved.
//

import UIKit

typealias EditActivityOnSave = (EditActivityTableViewController, Activity?) -> ()
typealias EditActivityOnCancel = (EditActivityTableViewController) -> ()

class EditActivityTableViewController : UITableViewController {
  
  let viewTitles = [ "Add new activity", "Edit activity" ]
  
  var activity: Activity?
  
  var mode: ViewControllerMode = .Add
  
  var onSave: EditActivityOnSave?
  var onCancel: EditActivityOnCancel?
  
  var dateFormatter: NSDateFormatter = NSDateFormatter()
  
  var datePickerView: MBDatePickerView?
  
  @IBOutlet weak var titleTextField: UITextField!
  
  @IBOutlet weak var amountLabel: MBAmountLabel!
  
  @IBOutlet weak var dateButton: UIButton!
  
  @IBOutlet weak var titleLabel: UILabel!
  
  override func viewDidLoad() {
    // Add a gesture recognizer to remove keyboard when tapped somewhere
    let tap = UITapGestureRecognizer(target: self, action: "viewTapped")
    self.view.addGestureRecognizer(tap);
    
    // Setup navigation bar
    let saveButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveButtonPressed:")
    setupNavigationItemWithTitle(kTitleManageActivities, backButtonSelector: "cancelButtonPressed:", rightItem: saveButtonItem)
    
    // Configure date formatter
    dateFormatter.locale = NSLocale.autoupdatingCurrentLocale()
    dateFormatter.dateStyle = .ShortStyle
    dateFormatter.timeStyle = .NoStyle
    
    // Check if controller is called in "edit" mode
    if self.activity != nil {
      self.mode = .Edit
      self.titleLabel.text = self.viewTitles[1]
      
      self.titleTextField.text = self.activity!.title
      self.amountLabel.amount = Double(self.activity!.amount!)
      
      let dateStr = self.dateFormatter.stringFromDate(self.activity!.date!)
      self.dateButton.setTitle(dateStr, forState: .Normal)
    } else {
      self.titleLabel.text = self.viewTitles[0]
      
      let dateStr = self.dateFormatter.stringFromDate(NSDate())
      self.dateButton.setTitle(dateStr, forState: .Normal)
    }
  }
  
  @IBAction func saveButtonPressed(sender: UIButton) {
    let title = self.titleTextField.text
    if title == nil || title?.characters.count == 0 {
      self.showAlertWithTitle("Error!", message: "Please enter a title.")
      return
    }
    
    if let account = self.settings?.selectedAccount {
      let amount = self.amountLabel.amount
      let title = self.titleTextField.text
      let dateStr = self.dateButton.titleLabel?.text
      var date: NSDate? = dateStr != nil ? dateFormatter.dateFromString(dateStr!) : NSDate()
      
      if date == nil {
        date = NSDate()
      }

      if self.activity == nil {
        self.activity = account.addActivityForDate(date!, title: title!, icon: "", amount: amount)
      } else {
        account.recalculateTotalsForUpdateActivity(self.activity!, newAmount: amount, newDate: date!)
        
        self.activity!.title = title
        self.activity!.amount = amount
        self.activity!.date = date
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
  
  @IBAction func cancelButtonPressed(sender: UIButton) {
    if let callback = self.onCancel {
      callback(self)
    }
    
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  @IBAction func incomeButtonPressed(sender: UIButton) {
    openAmountPadInMode(.Income, okHandler: { amountPad in
      self.amountLabel.amount = amountPad.finalAmount
      self.closeAmountPad(amountPad)
    }, cancelHandler: { amountPad in
      self.closeAmountPad(amountPad)
    })
  }
  
  @IBAction func expenditureButtonPressed(sender: UIButton) {
    openAmountPadInMode(.Expenditure, okHandler: { amountPad in
      self.amountLabel.amount = amountPad.finalAmount
      self.closeAmountPad(amountPad)
    }, cancelHandler: { amountPad in
      self.closeAmountPad(amountPad)
    })
  }
  
  @IBAction func dateButtonPressed(sender: UIButton) {
    if self.datePickerView == nil {
      showDatePicker()
    } else {
      hideDatePicker()
    }
  }
  
  func viewTapped() {
    self.titleTextField.resignFirstResponder()
  }

  private func showDatePicker() {
    var activityDate: NSDate? = nil
    if let date = self.activity?.date {
      activityDate = date
    } else {
      activityDate = NSDate()
    }
    
    self.datePickerView = createDatePickerViewWithDate(activityDate!)
    
    // animate datePicker into View
    self.datePickerView!.frame.origin.y += self.datePickerView!.frame.size.height
    UIView.animateWithDuration(0.6, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [ .CurveEaseOut ], animations: {
      self.datePickerView!.frame.origin.y -= self.datePickerView!.frame.size.height
      }, completion: nil)
    
    self.view.addSubview(self.datePickerView!)
  }

  private func hideDatePicker() {
    // animate datePicker out of View
    UIView.animateWithDuration(0.4, delay: 0.0, options: [], animations: {
      self.datePickerView!.frame.origin.y += self.datePickerView!.frame.size.height
      }, completion: { _ in
        self.datePickerView?.removeFromSuperview()
        self.datePickerView = nil
    })
  }
  
  private func createDatePickerViewWithDate(date: NSDate) -> MBDatePickerView {
    let rect = CGRect(x: 0, y: self.view.bounds.size.height * 0.65, width: self.view.bounds.width, height: self.view.bounds.size.height - self.view.bounds.size.height * 0.65)
    let blurEffect = UIBlurEffect(style: .ExtraLight)
    let picker = MBDatePickerView(effect: blurEffect)
    picker.frame = rect
    picker.date = date
    picker.onCancel = {
      self.hideDatePicker()
    }
    picker.onSelect = { date in
      self.hideDatePicker()
      
      let dateStr = NSDateFormatter.localizedStringFromDate(date, dateStyle: .ShortStyle, timeStyle: .NoStyle)
      self.dateButton.setTitle(dateStr, forState: .Normal)
    }
    
    return picker
  }
  
}

extension EditActivityTableViewController : UITextFieldDelegate {
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    self.titleTextField.resignFirstResponder()
    return true
  }
}
