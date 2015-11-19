//
//  ViewController.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 08.11.15.
//  Copyright © 2015 Karrmarr Software. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

  @IBOutlet weak var balanceInfoContainerView: UIView!
  
  @IBOutlet weak var gradientBackgroundView: UIView!
  
  var balancePageViewController: UIPageViewController!
  var gradientLayer: CAGradientLayer!
  
  // Page info for BalanceInfoViewControllers
  let balanceTitles = [ "Total balance", "Current month", "Current year" ]
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // remove line below the navigation bar
    if let navigationBar = self.navigationController?.navigationBar {
      navigationBar.setBackgroundImage(UIImage(), forBarPosition: UIBarPosition.Any, barMetrics: UIBarMetrics.Default)
      navigationBar.shadowImage = UIImage()
    }
    
    // Setup background gradient
    let layer = self.gradientBackgroundView.layer
    self.gradientLayer = gradientBackgroundLayer(layer.frame.size)
    layer.addSublayer(self.gradientLayer)

    // initialize Page View Controller
    initializePageViewController()
  }
  
  override func updateViewConstraints() {
    self.gradientLayer.frame = self.gradientBackgroundView.layer.bounds
    
    super.updateViewConstraints()
  }
  
  // MARK: - Private methods
    
  private func gradientBackgroundLayer(size: CGSize) -> CAGradientLayer {
    let colors = [ UIColor(hex: kGradientBackgroundColor1).CGColor, UIColor(hex: kGradientBackgroundColor2).CGColor ]
    let locations = [ 0.0, 1.0 ]
    
    let layer = CAGradientLayer()
    layer.colors = colors
    layer.locations = locations
    layer.zPosition = -1
    layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    
    return layer
  }
}





