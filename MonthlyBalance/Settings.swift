//
//  Settings.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 30.12.15.
//  Copyright © 2015 Karrmarr Software. All rights reserved.
//

import Foundation

let kSettingSelectedAccount = "selectedAccount"

class Settings {

  var selectedAccount: Account?
  
  init() {
    load()
  }
  
  func load() {
    let defaults = NSUserDefaults.standardUserDefaults()
    if let accountName = defaults.stringForKey(kSettingSelectedAccount) {
      if let account = Account.findByName(accountName).first {
        self.selectedAccount = account
      } else {
        let accounts = Account.findAll()
        self.selectedAccount = accounts.first
        save()
      }
    }
  }
  
  func save() {
    let defaults = NSUserDefaults.standardUserDefaults()
    if let account = self.selectedAccount {
      defaults.setValue(account.name!, forKey: "selectedAccount")
    }
    defaults.synchronize()
  }
}