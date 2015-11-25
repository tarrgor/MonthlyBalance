//
// Created by Thorsten Klusemann on 25.11.15.
// Copyright (c) 2015 Karrmarr Software. All rights reserved.
//

import UIKit

class MainMenuViewController : UIViewController {

  // MARK: - Initialization
  override func loadView() {
    self.view = MainMenuView(frame: CGRect(x: 0, y: 0, width: 414, height: 744))
  }

}
