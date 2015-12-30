//
//  UIViewExtension.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 30.12.15.
//  Copyright © 2015 Karrmarr Software. All rights reserved.
//

import UIKit

extension UIView {
  
  var gradientBackgroundLayer: CAGradientLayer? {
    var resultLayer: CAGradientLayer? = nil
    self.layer.sublayers?.forEach({ sublayer in
      if sublayer.isKindOfClass(CAGradientLayer) {
        resultLayer = (sublayer as! CAGradientLayer)
      }
    })
    return resultLayer
  }
  
  func addGradientBackgroundLayer(color1: UIColor, color2: UIColor) {
    let colors = [color1.CGColor, color2.CGColor]
    let locations = [0.0, 1.0]
    
    let layer = CAGradientLayer()
    layer.colors = colors
    layer.locations = locations
    layer.zPosition = -1
    layer.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
    
    self.layer.addSublayer(layer)
  }
  
}
