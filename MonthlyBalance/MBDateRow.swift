//
//  MBDateRow.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 16.02.16.
//  Copyright © 2016 Karrmarr Software. All rights reserved.
//

import UIKit
import Eureka

final class MBDateRow : Row<NSDate, MBDateCell>, RowType {

  required init(tag: String?) {
    super.init(tag: tag)
    displayValueFor = dateToString
  }
  
  func dateToString(date: NSDate?) -> String {
    cell.dateButton.setTitle(date?.displayText, forState: .Normal)
    return ""
  }
}
