//
//  EventTableViewCell.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 06.01.16.
//  Copyright © 2016 Karrmarr Software. All rights reserved.
//

import UIKit

class EventTableViewCell : UITableViewCell {
  
  @IBOutlet weak var eventImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var scheduleLabel: UILabel!
  @IBOutlet weak var nextLabel: UILabel!
  @IBOutlet weak var amountLabel: UILabel!
}
