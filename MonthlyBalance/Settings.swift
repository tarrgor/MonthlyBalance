//
//  Settings.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 30.12.15.
//  Copyright © 2015 Karrmarr Software. All rights reserved.
//

import Foundation

let kSettingSelectedAccount = "selectedAccount"
let kSettingDefaultTitleIncome = "defaultTitleIncome"
let kSettingDefaultTitleExpenditure = "defaultTitleExpenditure"

let kDefaultTitleIncome = "Income"
let kDefaultTitleExpenditure = "Expenditure"

class Settings : NSObject {

  var selectedAccount: Account?
  var defaultTitleIncome: String?
  var defaultTitleExpenditure: String?
  
  override init() {
    super.init()
    load()
  }
  
  func load() {
    let defaults = NSUserDefaults.standardUserDefaults()
    if let accountName = defaults.stringForKey(kSettingSelectedAccount) {
      if let account = Account.findByName(accountName).first {
        self.selectedAccount = account
      }
    }

    if self.selectedAccount == nil {
      let accounts = Account.findAll()
      self.selectedAccount = accounts.first
    }

    self.defaultTitleIncome = defaults.stringForKey(kSettingDefaultTitleIncome)
    if self.defaultTitleIncome == nil {
      self.defaultTitleIncome = kDefaultTitleIncome
    }

    self.defaultTitleExpenditure = defaults.stringForKey(kSettingDefaultTitleExpenditure)
    if self.defaultTitleExpenditure == nil {
      self.defaultTitleExpenditure = kDefaultTitleExpenditure
    }
  }
  
  func save() {
    let defaults = NSUserDefaults.standardUserDefaults()
    if let account = self.selectedAccount {
      defaults.setObject(account.name!, forKey: kSettingSelectedAccount)
    }
    defaults.setObject(self.defaultTitleIncome, forKey: kSettingDefaultTitleIncome)
    defaults.setObject(self.defaultTitleExpenditure, forKey: kSettingDefaultTitleExpenditure)
    defaults.synchronize()
  }
}