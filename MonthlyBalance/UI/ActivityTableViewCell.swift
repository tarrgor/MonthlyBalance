//
//  ActivityTableViewCell.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 17.11.15.
//  Copyright © 2015 Karrmarr Software. All rights reserved.
//

import UIKit

class ActivityTableViewCell : UITableViewCell {
  
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var timeLabel: UILabel!
  @IBOutlet var iconImageView: UIImageView!
  @IBOutlet var amountLabel: MBAmountLabel!

}
