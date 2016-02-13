//
//  CreateAccountHeaderView.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 13.02.16.
//  Copyright © 2016 Karrmarr Software. All rights reserved.
//

import UIKit
import SnapKit

class MBSectionHeaderView : UIView {
  
  var titleLabel: UILabel!
  var title: String? {
    didSet {
      self.titleLabel.text = title
    }
  }
  var titleColor: UIColor? {
    didSet {
      self.titleLabel.textColor = titleColor
    }
  }
  var titleFont: UIFont? {
    didSet {
      self.titleLabel.font = titleFont
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
    setupAutolayout()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setup() {
    titleLabel = UILabel()
    titleLabel.text = title ?? "No title"
    addSubview(titleLabel)

    backgroundColor = UIColor(hex: kColorBaseBackground)
    titleColor = UIColor.whiteColor()
    titleFont = UIFont(name: kMainFontName, size: 18)
  }
  
  func setupAutolayout() {
    titleLabel.snp_makeConstraints { make in
      make.centerX.equalTo(self)
      make.centerY.equalTo(self)
    }
  }
}
