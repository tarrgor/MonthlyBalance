//
// Created by Thorsten Klusemann on 14.02.16.
// Copyright (c) 2016 Karrmarr Software. All rights reserved.
//

import UIKit
import Eureka

class FormUtil {

  static func setupForm(form: FormViewController) {
    form.tableView?.backgroundColor = UIColor(hex: kColorBaseBackground)
    form.tableView?.separatorStyle = UITableViewCellSeparatorStyle.None
    
    TextRow.defaultCellSetup = { cell, row in
      let r = row as TextRow
      r.placeholderColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
    }
    TextRow.defaultCellUpdate = { cell, row in
      let c = cell as TextCell
      c.backgroundColor = UIColor(hex: kColorSecondBackground)
      c.textLabel?.textColor = UIColor.whiteColor()
      c.textField.textColor = UIColor(hex: kColorBaseBackground)
      c.tintColor = UIColor(hex: kColorHighlightedText)
    }
    PasswordRow.defaultCellSetup = { cell, row in
      let r = row as PasswordRow
      r.placeholderColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
    }
    PasswordRow.defaultCellUpdate = { cell, row in
      let c = cell as PasswordCell
      c.backgroundColor = UIColor(hex: kColorSecondBackground)
      c.textLabel?.textColor = UIColor.whiteColor()
      c.textField.textColor = UIColor(hex: kColorBaseBackground)
      c.tintColor = UIColor(hex: kColorHighlightedText)
    }
    LabelRow.defaultCellSetup = { cell, row in
      let c = cell as LabelCell
      c.height = { return 40 }
    }
    LabelRow.defaultCellUpdate = { cell, row in
      let c = cell as LabelCell
      c.backgroundColor = UIColor(hex: kColorBaseBackground)
      c.textLabel?.textColor = UIColor.whiteColor()
      c.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 14)
      c.textLabel?.numberOfLines = 2
    }
    SegmentedRow<String>.defaultCellUpdate = { cell, row in
      let c = cell as SegmentedCell<String>
      c.backgroundColor = UIColor(hex: kColorSecondBackground)
      c.segmentedControl.tintColor = UIColor.whiteColor()
    }
    DecimalRow.defaultCellUpdate = { cell, row in
      let c = cell as DecimalCell
      c.backgroundColor = UIColor(hex: kColorSecondBackground)
      c.textLabel?.textColor = UIColor.whiteColor()
      c.textField.textColor = UIColor(hex: kColorBaseBackground)
      c.tintColor = UIColor(hex: kColorHighlightedText)
    }
    MBDateRow.defaultCellSetup = { cell, row in
      let c = cell as MBDateCell
      c.backgroundColor = UIColor(hex: kColorSecondBackground)
      c.tintColor = UIColor(hex: kColorHighlightedText)
    }
    MBDateRow.defaultCellUpdate = { cell, row in
      let c = cell as MBDateCell
      c.textLabel?.textColor = UIColor.whiteColor()      
    }
    SwitchRow.defaultCellSetup = { cell, row in
      let c = cell as SwitchCell
      c.backgroundColor = UIColor(hex: kColorSecondBackground)
      c.tintColor = UIColor(hex: kColorHighlightedText)
      c.switchControl?.onTintColor = UIColor(hex: kColorSwitchOnTintColor)
    }
    SwitchRow.defaultCellUpdate = { cell, row in
      let c = cell as SwitchCell
      c.textLabel?.textColor = UIColor.whiteColor()
    }
    IntRow.defaultCellSetup = { cell, row in
      let c = cell as IntCell
      c.backgroundColor = UIColor(hex: kColorSecondBackground)
      c.tintColor = UIColor(hex: kColorHighlightedText)
    }
    IntRow.defaultCellUpdate = { cell, row in
      let c = cell as IntCell
      c.textLabel?.textColor = UIColor.whiteColor()
      c.textField.textColor = UIColor(hex: kColorBaseBackground)
    }
  }

  static func configureSectionHeader(section: Section, title: String, height: CGFloat = 40) {
    var header = HeaderFooterView<MBSectionHeaderView>(HeaderFooterProvider.Class)

    header.height = { return height }
    header.onSetupView = { view, section, form in
      view.title = title
    }

    section.header = header
  }
}
