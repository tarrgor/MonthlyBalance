//
//  ViewController.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 08.11.15.
//  Copyright © 2015 Karrmarr Software. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, AccountManagementDelegate {

  @IBOutlet weak var balanceInfoContainerView: UIView!

  @IBOutlet weak var gradientBackgroundView: UIView!

  @IBOutlet weak var incomeButton: UIButton!

  @IBOutlet weak var expenditureButton: UIButton!

  var balancePageViewController: UIPageViewController!
  var gradientLayer: CAGradientLayer!

  var mainMenuOpened: Bool = false

  var selectedAccount: Account?
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // load settings
    self.loadSettings()
    
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
      guard let createAccountViewController = self.storyboard?.instantiateViewControllerWithIdentifier(kIdCreateAccountViewController)
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
    sender.backgroundColor = UIColor(hex: kColorHighlightedButtonBackground)
  }

  @IBAction func expenditureButtonTouchDown(sender: UIButton) {
    sender.backgroundColor = UIColor(hex: kColorHighlightedButtonBackground)
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
    if let svc = self.slideMenuViewController {
      if svc.menuOpened {
        svc.closeMenu(true)
      } else {
        svc.openMenu(true)
      }
    }
  }
  
  // MARK: - AccountManagementDelegate
  
  func didChangeAccountSelection(account: Account) {
    print("Account selection changed to \(account.name!)")
    self.selectedAccount = account
    self.saveSettings()
  }
  
  // MARK: - Private methods

  private func gradientBackgroundLayer(size: CGSize) -> CAGradientLayer {
    let colors = [UIColor(hex: kColorGradientBackground1).CGColor, UIColor(hex: kColorGradientBackground2).CGColor]
    let locations = [0.0, 1.0]

    let layer = CAGradientLayer()
    layer.colors = colors
    layer.locations = locations
    layer.zPosition = -1
    layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)

    return layer
  }
  
  private func loadSettings() {
    let defaults = NSUserDefaults.standardUserDefaults()
    if let accountName = defaults.stringForKey("selectedAccount") {
      if let account = Account.findByName(accountName).first {
        self.selectedAccount = account
      } else {
        let accounts = Account.findAll()
        self.selectedAccount = accounts.first
        saveSettings()
      }
    }
    print("Selected Account from settings: \(self.selectedAccount?.name)")
  }
  
  private func saveSettings() {
    let defaults = NSUserDefaults.standardUserDefaults()
    if let account = self.selectedAccount {
      defaults.setValue(account.name!, forKey: "selectedAccount")
    }
    defaults.synchronize()
  }
}





