//
//  MBDateRow.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 16.02.16.
//  Copyright © 2016 Karrmarr Software. All rights reserved.
//

import UIKit
import Eureka

final class MBDateRow : Row<MBDateCell>, RowType {

  required init(tag: String?) {
    super.init(tag: tag)
    displayValueFor = dateToString
  }
  
  func dateToString(_ date: Date?) -> String {
    cell.dateButton.setTitle(date?.displayText, for: UIControlState())
    return ""
  }
}
