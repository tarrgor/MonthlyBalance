//
// Created by Thorsten Klusemann on 25.11.15.
// Copyright (c) 2015 Karrmarr Software. All rights reserved.
//

import UIKit

class MainMenuView : UIView {

  var headerLabel: UILabel!
  var lineView: UIView!

  var homeMenuItem: UIButton!

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.backgroundColor = UIColor(hex: "#85B1F7")

    createMenuItems()
    setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  // MARK: - Private methods

  private func createMenuItems() {
    self.headerLabel = UILabel(frame: CGRectZero)
    self.headerLabel.font = UIFont(name: kMenuFontName, size: 24)
    self.headerLabel.text = "Main menu"
    self.headerLabel.textColor = UIColor.whiteColor()
    self.headerLabel.sizeToFit()
    self.headerLabel.translatesAutoresizingMaskIntoConstraints = false

    self.addSubview(self.headerLabel)

    self.lineView = UIView(frame: CGRectZero)
    self.lineView.backgroundColor = UIColor.whiteColor()
    self.lineView.translatesAutoresizingMaskIntoConstraints = false

    self.addSubview(self.lineView)

    self.homeMenuItem = UIButton.menuItemButton("Home")
    self.addSubview(homeMenuItem)
  }

  private func setupConstraints() {
    self.addConstraint(NSLayoutConstraint(item: self.headerLabel, attribute: .Top, relatedBy: .Equal,
        toItem: self, attribute: .Top, multiplier: 1, constant: 22))
    self.addConstraint(NSLayoutConstraint(item: self.headerLabel, attribute: .Leading, relatedBy: .Equal,
        toItem: self, attribute: .Leading, multiplier: 1, constant: 16))

    self.addConstraint(NSLayoutConstraint(item: self.lineView, attribute: .Top, relatedBy: .Equal,
        toItem: self.headerLabel, attribute: .Bottom, multiplier: 1, constant: 6))
    self.addConstraint(NSLayoutConstraint(item: self.lineView, attribute: .Leading, relatedBy: .Equal,
        toItem: self, attribute: .Leading, multiplier: 1, constant: 0))
    self.lineView.addConstraint(NSLayoutConstraint(item: self.lineView, attribute: .Height, relatedBy: .Equal,
        toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 1))
    self.lineView.addConstraint(NSLayoutConstraint(item: self.lineView, attribute: .Width, relatedBy: .Equal,
        toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 200))

    self.addConstraint(NSLayoutConstraint(item: self.homeMenuItem, attribute: .Top, relatedBy: .Equal,
        toItem: self.lineView, attribute: .Bottom, multiplier: 1, constant: 26))
    self.addConstraint(NSLayoutConstraint(item: self.homeMenuItem, attribute: .Leading, relatedBy: .Equal,
        toItem: self.headerLabel, attribute: .Leading, multiplier: 1, constant: 0))
  }
}
