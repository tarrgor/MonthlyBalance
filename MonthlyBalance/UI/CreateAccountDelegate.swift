//
//  CreateAccountDelegate.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 16.01.16.
//  Copyright © 2016 Karrmarr Software. All rights reserved.
//

import Foundation

protocol CreateAccountDelegate {
  func createAccountViewControllerDidCreateAccount(viewController: CreateAccountViewController, account: Account)
}