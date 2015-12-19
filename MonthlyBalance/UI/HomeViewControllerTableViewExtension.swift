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
    guard let count = self.selectedAccount?.activities?.count else {
      print("Invalid data: Number of elements in TableView cannot be determined.")
      return 0
    }
    return count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(kIdActivityCell) as! ActivityTableViewCell

    guard let activity: Activity = self.selectedAccount?.activities?.allObjects[indexPath.row] as? Activity
    else {
      cell.titleLabel.text = "ERROR!"
      setSelectedBackgroundColorForCell(cell)
      return cell
    }
    
    cell.titleLabel.text = activity.title
    cell.timeLabel.text = "Time"
    cell.iconImageView.image = UIImage()

    guard let currencyAmount = try? CurrencyUtil.formattedValue(Double(activity.amount!))
    else {
      cell.amountLabel.text = "ERR!"
      setSelectedBackgroundColorForCell(cell)
      return cell
    }
  
    cell.amountLabel.text = currencyAmount
    
    setSelectedBackgroundColorForCell(cell)
    
    return cell
  }
  
  // MARK: - Private methods
  private func setSelectedBackgroundColorForCell(cell: UITableViewCell) {
    cell.selectedBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: cell.bounds.size.height))
    cell.selectedBackgroundView?.backgroundColor = UIColor(hex: kColorTableViewSelection)
  }
}
