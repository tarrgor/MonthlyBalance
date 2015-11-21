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
  
  @IBOutlet weak var incomeButton: UIButton!
  
  @IBOutlet weak var expenditureButton: UIButton!
  
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

  @IBAction func incomeButtonTouchDown(sender: UIButton) {
    sender.backgroundColor = UIColor(hex: "#97BDFF")
  }
  
  @IBAction func expenditureButtonTouchDown(sender: UIButton) {
    sender.backgroundColor = UIColor(hex: "#97BDFF")
  }
  
  @IBAction func incomeButtonPressed(sender: UIButton) {
    incomeButton.enabled = false
    expenditureButton.enabled = false
    
    let amountPadViewController = AmountPadViewController()
    self.addChildViewController(amountPadViewController)
    self.view.addSubview(amountPadViewController.view)
    
    let amountPadHeight = self.view.bounds.size.height * 0.75;
    amountPadViewController.view.frame = CGRect(x: 0, y: self.view.bounds.size.height + 100, width: self.view.bounds.size.width, height: amountPadHeight)
    
    let maskLayer = CAShapeLayer()
    let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: amountPadViewController.view.bounds.size.height - self.incomeButton.bounds.size.height - 3))
    maskLayer.path = path.CGPath
    
    amountPadViewController.view.layer.mask = maskLayer
    
    UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 10, options: [], animations: {
      let ypos = self.view.bounds.size.height - amountPadViewController.view.bounds.size.height
      amountPadViewController.view.frame.origin = CGPoint(x: 0, y: ypos)
    }, completion: nil)
  }

  @IBAction func expenditureButtonPressed(sender: UIButton) {
    incomeButton.enabled = false
    expenditureButton.enabled = false
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





