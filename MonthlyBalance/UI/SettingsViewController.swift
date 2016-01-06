//
//  SettingsViewController.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 30.12.15.
//  Copyright © 2015 Karrmarr Software. All rights reserved.
//

import UIKit

class SettingsViewController : UITableViewController {

  @IBOutlet weak var defaultTitleIncomeTextField: UITextField!
  @IBOutlet weak var defaultTitleExpenditureTextField: UITextField!
  
  override func viewDidLoad() {
    self.navigationItem.title = kTitleSettings
    self.navigationItem.leftItemsSupplementBackButton = false
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: kTitleBackButton, style: UIBarButtonItemStyle.Plain, target: self, action: "backButtonPressed:")
    self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveButtonPressed:")
    self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    initializeFormFields()
  }

  // MARK: - Actions
  
  func backButtonPressed(sender: UIBarButtonItem) {
    self.navigationController?.popToRootViewControllerAnimated(true)
  }
  
  func saveButtonPressed(sender: UIBarButtonItem) {
    updateSettings()
    self.navigationController?.popToRootViewControllerAnimated(true)
  }

  // Private methods

  private func initializeFormFields() {
      self.defaultTitleIncomeTextField.text = self.settings?.defaultTitleIncome
      self.defaultTitleExpenditureTextField.text = self.settings?.defaultTitleExpenditure
  }

  private func updateSettings() {
    if let defaultTitleIncome = self.defaultTitleIncomeTextField.text {
      self.settings?.defaultTitleIncome = defaultTitleIncome
    }
    if let defaultTitleExpenditure = self.defaultTitleExpenditureTextField.text {
      self.settings?.defaultTitleExpenditure = defaultTitleExpenditure
    }
    self.settings?.save()
  }
}

extension SettingsViewController {

  var headerTitles: [String] {
    return [ "Default titles" ]
  }

  override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 42.0
  }

  override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    guard let headerView = view as? UITableViewHeaderFooterView else {
      return
    }

    headerView.textLabel!.textColor = UIColor.whiteColor()
    headerView.textLabel!.font = UIFont(name: kMainFontName, size: 20)
    headerView.textLabel!.text = headerTitles[section]

    let separator = UIView(frame: CGRect(x: 20, y: headerView.bounds.size.height - 1,
      width: headerView.bounds.size.width - 20, height: 1))
    separator.backgroundColor = UIColor.whiteColor()
    headerView.addSubview(separator)
  }

}
