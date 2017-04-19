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
      self.titleLabel.text = title?.uppercased()
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
    titleLabel.text = title?.uppercased() ?? "NO TITLE"
    addSubview(titleLabel)

    backgroundColor = UIColor(hex: kColorBaseBackground)
    titleColor = UIColor(hex: kColorHighlightedText)
    titleFont = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
  }
  
  func setupAutolayout() {
    titleLabel.snp_makeConstraints { make in
      make.leading.equalTo(self.snp_leadingMargin)
      make.bottom.equalTo(self.snp_bottomMargin)
    }
  }
}
