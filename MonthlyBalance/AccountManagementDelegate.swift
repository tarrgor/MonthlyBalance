//
//  AccountManagementDelegate.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 13.12.15.
//  Copyright © 2015 Karrmarr Software. All rights reserved.
//

import Foundation

protocol AccountManagementDelegate {
  
  func didChangeAccountSelection(account: Account)
  
}