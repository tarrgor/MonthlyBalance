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
  var mainMenuViewController: MainMenuViewController!

  var mainMenuOpened: Bool = false

  // Page info for BalanceInfoViewControllers
  let balanceTitles = ["Total balance", "Current month", "Current year"]

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
  
  override func viewDidAppear(animated: Bool) {
    let accounts = Account.findAll()
    if accounts.count == 0 {
      guard let createAccountViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CreateAccountViewController")
      else {
        print("Error")
        return
      }
      
      self.navigationController?.presentViewController(createAccountViewController, animated: true, completion: nil)
    }
  }

  override func updateViewConstraints() {
    self.gradientLayer.frame = self.gradientBackgroundView.layer.bounds

    // Relocate number pad 

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

    openAmountPad(.Income)
  }

  @IBAction func expenditureButtonPressed(sender: UIButton) {
    incomeButton.enabled = false
    expenditureButton.enabled = false

    openAmountPad(.Expenditure)
  }

  @IBAction func mainMenuButtonPressed(sender: UIBarButtonItem) {
    if (self.mainMenuOpened) {
      closeMainMenu()
    } else {
      openMainMenu()
    }
  }

  // MARK: - Private methods

  private func openMainMenu() {
    let menuWidth = self.navigationController!.view.bounds.size.width * 0.54

    self.mainMenuViewController = MainMenuViewController()
    self.mainMenuViewController.view.frame = CGRect(x: -menuWidth,
        y: 0, width: menuWidth, height: self.navigationController!.view.bounds.size.height)
    self.navigationController!.addChildViewController(self.mainMenuViewController)

    self.navigationController!.view.addSubview(self.mainMenuViewController.view)

    UIView.animateWithDuration(0.3, delay: 0.0, options: [], animations: {
      self.navigationController!.view.frame.origin.x += menuWidth
    }, completion: nil)

    self.mainMenuOpened = true
  }

  private func closeMainMenu() {
    UIView.animateWithDuration(0.3, delay: 0.0, options: [], animations: {
      self.navigationController!.view.frame.origin.x = 0
    }, completion: {
      _ in
      self.mainMenuViewController.view.removeFromSuperview()
      self.mainMenuViewController.removeFromParentViewController()
    })

    self.mainMenuOpened = false
  }

  private func gradientBackgroundLayer(size: CGSize) -> CAGradientLayer {
    let colors = [UIColor(hex: kGradientBackgroundColor1).CGColor, UIColor(hex: kGradientBackgroundColor2).CGColor]
    let locations = [0.0, 1.0]

    let layer = CAGradientLayer()
    layer.colors = colors
    layer.locations = locations
    layer.zPosition = -1
    layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)

    return layer
  }
}





