//
//  HomeViewControllerTableViewExtension.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 17.11.15.
//  Copyright © 2015 Karrmarr Software. All rights reserved.
//

import UIKit

extension HomeViewController : UITableViewDataSource, UITableViewDelegate {
  // MARK: - UITableViewDataSource, UITableViewDelegate
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 8
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(kIdActivityCell) as! ActivityTableViewCell
    
    cell.titleLabel.text = "Title"
    cell.amountLabel.text = "95,00 €"
    cell.timeLabel.text = "Today"
    cell.iconImageView.image = UIImage()
    
    cell.selectedBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: cell.bounds.size.height))
    cell.selectedBackgroundView?.backgroundColor = UIColor(hex: kColorTableViewSelection)
    
    return cell
  }
}
