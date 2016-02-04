//
//  Commons.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 16.01.16.
//  Copyright © 2016 Karrmarr Software. All rights reserved.
//

import UIKit

enum ViewControllerMode: Int {
  case Add = 0, Edit
}

enum UIUserInterfaceIdiom : Int
{
  case Unspecified
  case Phone
  case Pad
}

struct ScreenSize
{
  static let SCREEN_WIDTH         = UIScreen.mainScreen().bounds.size.width
  static let SCREEN_HEIGHT        = UIScreen.mainScreen().bounds.size.height
  static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
  static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
  static let IS_IPHONE_4_OR_LESS  = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
  static let IS_IPHONE_5          = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
  static let IS_IPHONE_6          = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
  static let IS_IPHONE_6P         = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
  static let IS_IPAD              = UIDevice.currentDevice().userInterfaceIdiom == .Pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
}

func delay(ms: Int64, block: () -> ()) {
  let time = dispatch_time(DISPATCH_TIME_NOW, ms * 1000)
  dispatch_after(time, dispatch_get_main_queue(), block)
}


