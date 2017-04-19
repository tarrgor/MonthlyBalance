//
//  EditActivityTableViewController.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 12.01.16.
//  Copyright © 2016 Karrmarr Software. All rights reserved.
//

import UIKit

//typealias EditActivityOnSave = (EditActivityTableViewController, Activity?) -> ()
//typealias EditActivityOnCancel = (EditActivityTableViewController) -> ()

class EditActivityTableViewController : UITableViewController {
  
  let viewTitles = [ "Add new activity", "Edit activity" ]
  
  var activity: Activity?
  
  var mode: ViewControllerMode = .add
  
  var onSave: EditActivityOnSave?
  var onCancel: EditActivityOnCancel?
  
  var dateFormatter: DateFormatter = DateFormatter()
  
  var datePickerView: MBDatePickerView?
  
  @IBOutlet weak var titleTextField: UITextField!
  
  @IBOutlet weak var amountLabel: MBAmountLabel!
  
  @IBOutlet weak var dateButton: UIButton!
  
  @IBOutlet weak var titleLabel: UILabel!
  
  override func viewDidLoad() {
    // Add a gesture recognizer to remove keyboard when tapped somewhere
    let tap = UITapGestureRecognizer(target: self, action: #selector(EditActivityTableViewController.viewTapped))
    self.view.addGestureRecognizer(tap);
    
    // Setup navigation bar
    let saveButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(EditActivityTableViewController.saveButtonPressed(_:)))
    setupNavigationItemWithTitle(kTitleManageActivities, backButtonSelector: #selector(cancelButtonPressed(_:)), rightItem: saveButtonItem)
    
    // Configure date formatter
    dateFormatter.locale = Locale.autoupdatingCurrent
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .none
    
    // Check if controller is called in "edit" mode
    if self.activity != nil {
      self.mode = .edit
      self.titleLabel.text = self.viewTitles[1]
      
      self.titleTextField.text = self.activity!.title
      self.amountLabel.amount = Double(self.activity!.amount!)
      
      let dateStr = self.dateFormatter.string(from: self.activity!.date! as Date)
      self.dateButton.setTitle(dateStr, for: UIControlState())
    } else {
      self.titleLabel.text = self.viewTitles[0]
      
      let dateStr = self.dateFormatter.string(from: Date())
      self.dateButton.setTitle(dateStr, for: UIControlState())
    }
  }
  
  @IBAction func saveButtonPressed(_ sender: UIButton) {
    let title = self.titleTextField.text
    if title == nil || title?.characters.count == 0 {
      self.showAlertWithTitle("Error!", message: "Please enter a title.")
      return
    }
    
    if let account = self.settings?.selectedAccount {
      let amount = self.amountLabel.amount
      let title = self.titleTextField.text
      let dateStr = self.dateButton.titleLabel?.text
      var date: Date? = dateStr != nil ? dateFormatter.date(from: dateStr!) : Date()
      
      if date == nil {
        date = Date()
      }

      if self.activity == nil {
        self.activity = account.addActivityForDate(date!, title: title!, icon: "", amount: amount)
      } else {
        account.recalculateTotalsForUpdateActivity(self.activity!, newAmount: amount, newDate: date!)
        
        self.activity!.title = title
        self.activity!.amount = amount as NSNumber
        self.activity!.date = date
        self.activity!.update()
      }
    } else {
      print("No selected account found in the settings.")
    }
    
    if let callback = self.onSave {
      //callback(self, self.activity)
    }
    
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func cancelButtonPressed(_ sender: UIButton) {
    if let callback = self.onCancel {
      //callback(self)
    }
    
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func incomeButtonPressed(_ sender: UIButton) {
    openAmountPadInMode(.income, okHandler: { amountPad in
      self.amountLabel.amount = amountPad.finalAmount
      self.closeAmountPad(amountPad)
    }, cancelHandler: { amountPad in
      self.closeAmountPad(amountPad)
    })
  }
  
  @IBAction func expenditureButtonPressed(_ sender: UIButton) {
    openAmountPadInMode(.expenditure, okHandler: { amountPad in
      self.amountLabel.amount = amountPad.finalAmount
      self.closeAmountPad(amountPad)
    }, cancelHandler: { amountPad in
      self.closeAmountPad(amountPad)
    })
  }
  
  @IBAction func dateButtonPressed(_ sender: UIButton) {
    if self.datePickerView == nil {
      showDatePicker()
    } else {
      hideDatePicker()
    }
  }
  
  func viewTapped() {
    self.titleTextField.resignFirstResponder()
  }

  fileprivate func showDatePicker() {
    var activityDate: Date? = nil
    if let date = self.activity?.date {
      activityDate = date as Date
    } else {
      activityDate = Date()
    }
    
    self.datePickerView = createDatePickerViewWithDate(activityDate!)
    
    // animate datePicker into View
    self.datePickerView!.frame.origin.y += self.datePickerView!.frame.size.height
    UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [ .curveEaseOut ], animations: {
      self.datePickerView!.frame.origin.y -= self.datePickerView!.frame.size.height
      }, completion: nil)
    
    self.view.addSubview(self.datePickerView!)
  }

  fileprivate func hideDatePicker() {
    // animate datePicker out of View
    UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
      self.datePickerView!.frame.origin.y += self.datePickerView!.frame.size.height
      }, completion: { _ in
        self.datePickerView?.removeFromSuperview()
        self.datePickerView = nil
    })
  }
  
  fileprivate func createDatePickerViewWithDate(_ date: Date) -> MBDatePickerView {
    let rect = CGRect(x: 0, y: self.view.bounds.size.height * 0.65, width: self.view.bounds.width, height: self.view.bounds.size.height - self.view.bounds.size.height * 0.65)
    let blurEffect = UIBlurEffect(style: .extraLight)
    let picker = MBDatePickerView(effect: blurEffect)
    picker.frame = rect
    picker.date = date
    picker.onCancel = {
      self.hideDatePicker()
    }
    picker.onSelect = { date in
      self.hideDatePicker()
      
      let dateStr = DateFormatter.localizedString(from: date as Date, dateStyle: .short, timeStyle: .none)
      self.dateButton.setTitle(dateStr, for: UIControlState())
    }
    
    return picker
  }
  
}

extension EditActivityTableViewController : UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.titleTextField.resignFirstResponder()
    return true
  }
}
