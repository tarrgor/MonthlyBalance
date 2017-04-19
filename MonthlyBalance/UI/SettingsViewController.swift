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
    let saveButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(SettingsViewController.saveButtonPressed(_:)))
    setupNavigationItemWithTitle(kTitleSettings, backButtonSelector: #selector(backButtonPressed(_:)), rightItem: saveButtonItem)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    initializeFormFields()
  }

  // MARK: - Actions
  
  func backButtonPressed(_ sender: UIBarButtonItem) {
    self.navigationController?.popToRootViewController(animated: true)
  }
  
  func saveButtonPressed(_ sender: UIBarButtonItem) {
    updateSettings()
    self.navigationController?.popToRootViewController(animated: true)
  }

  // Private methods

  fileprivate func initializeFormFields() {
      self.defaultTitleIncomeTextField.text = self.settings?.defaultTitleIncome
      self.defaultTitleExpenditureTextField.text = self.settings?.defaultTitleExpenditure
  }

  fileprivate func updateSettings() {
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

  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 42.0
  }

  override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    guard let headerView = view as? UITableViewHeaderFooterView else {
      return
    }

    headerView.textLabel!.textColor = UIColor.white
    headerView.textLabel!.font = UIFont(name: kMainFontName, size: 20)
    headerView.textLabel!.text = headerTitles[section]

    let separator = UIView(frame: CGRect(x: 20, y: headerView.bounds.size.height - 1,
      width: headerView.bounds.size.width - 20, height: 1))
    separator.backgroundColor = UIColor.white
    headerView.addSubview(separator)
  }

}
