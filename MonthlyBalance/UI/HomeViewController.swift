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

  @IBOutlet weak var activityTableView: UITableView!
  
  var balancePageViewController: UIPageViewController!

  var mainMenuOpened: Bool = false

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // remove line below the navigation bar
    if let navigationBar = self.navigationController?.navigationBar {
      navigationBar.setBackgroundImage(UIImage(), forBarPosition: UIBarPosition.Any, barMetrics: UIBarMetrics.Default)
      navigationBar.shadowImage = UIImage()
    }

    // Setup background gradient
    self.gradientBackgroundView.addGradientBackgroundLayer(UIColor(hex: kColorGradientBackground1), color2: UIColor(hex: kColorGradientBackground2))
  }
  
  override func viewDidAppear(animated: Bool) {
    checkSelectedAccount()

    // initialize Page View Controller
    initializePageViewController()
  }

  override func viewDidLayoutSubviews() {
    if let gradientLayer = self.gradientBackgroundView.gradientBackgroundLayer {
      self.gradientBackgroundView.layer.frame = self.gradientBackgroundView.frame
      gradientLayer.frame = self.gradientBackgroundView.bounds
    }

    super.viewDidLayoutSubviews()
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

  // MARK: - Private methods

  private func checkSelectedAccount() {
    if self.settings?.selectedAccount == nil {
      guard let createAccountViewController = self.storyboard?.instantiateViewControllerWithIdentifier(kIdCreateAccountViewController)
      else {
        print("Error")
        return
      }

      self.navigationController?.presentViewController(createAccountViewController, animated: true, completion: nil)
    }
  }
}

extension HomeViewController : AccountManagementDelegate {
  // MARK: - AccountManagementDelegate
  
  func didChangeAccountSelection(account: Account) {
    self.settings?.selectedAccount = account
    self.settings?.save()
    self.activityTableView.reloadData()
    updateAccountOnPageViewController()
  }
}

extension HomeViewController : UITableViewDataSource, UITableViewDelegate {
  // MARK: - UITableViewDataSource, UITableViewDelegate
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let count = self.settings?.selectedAccount?.activities?.count else {
      print("Invalid data: Number of elements in TableView cannot be determined.")
      return 0
    }
    return count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(kIdActivityCell) as! ActivityTableViewCell
    
    guard let activity: Activity = self.settings?.selectedAccount?.activities?.allObjects[indexPath.row] as? Activity
      else {
        cell.titleLabel.text = "ERROR!"
        setSelectedBackgroundColorForCell(cell)
        return cell
    }
    
    cell.titleLabel.text = activity.title
    cell.timeLabel.text = "Time"
    cell.iconImageView.image = UIImage()
    
    guard let currencyAmount = try? CurrencyUtil.formattedValue(Double(activity.amount!))
      else {
        cell.amountLabel.text = "ERR!"
        setSelectedBackgroundColorForCell(cell)
        return cell
    }
    
    cell.amountLabel.text = currencyAmount
    
    setSelectedBackgroundColorForCell(cell)
    
    return cell
  }
  
  // MARK: - Private methods
  private func setSelectedBackgroundColorForCell(cell: UITableViewCell) {
    cell.selectedBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: cell.bounds.size.height))
    cell.selectedBackgroundView?.backgroundColor = UIColor(hex: kColorTableViewSelection)
  }
}

extension HomeViewController : AmountPadDelegate {
  
  func amountPadDidPressOk(amountPad: AmountPadViewController) {
    let title = amountPad.mode == .Income ? self.settings?.defaultTitleIncome :
        self.settings?.defaultTitleExpenditure
    let finalAmount: Double = Double(amountPad.amount) + Double(amountPad.digits) / 100
    self.settings?.selectedAccount?.addActivityForDate(NSDate(), title: title!, icon: "", amount: finalAmount)
    self.activityTableView.reloadData()
    
    closeAmountPad(amountPad)
  }
  
  func amountPadDidPressCancel(amountPad: AmountPadViewController) {
    closeAmountPad(amountPad)
  }
  
  func openAmountPad(mode: AmountPadMode) {
    let amountPadViewController = AmountPadViewController()
    amountPadViewController.delegate = self
    amountPadViewController.mode = mode
    self.addChildViewController(amountPadViewController)
    self.view.addSubview(amountPadViewController.view)
    
    let amountPadHeight = self.view.bounds.size.height * 0.75;
    amountPadViewController.view.frame = CGRect(x: 0, y: self.view.bounds.size.height + 100, width: self.view.bounds.size.width, height: amountPadHeight)
    
    let maskLayer = CAShapeLayer()
    let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: amountPadViewController.view.bounds.size.height - self.incomeButton.bounds.size.height - 3))
    maskLayer.path = path.CGPath
    
    amountPadViewController.view.layer.mask = maskLayer
    
    UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
      let ypos = self.view.bounds.size.height - amountPadViewController.view.bounds.size.height
      amountPadViewController.view.frame.origin = CGPoint(x: 0, y: ypos)
      }, completion: nil)
  }
  
  func closeAmountPad(amountPad: AmountPadViewController) {
    animateAmountPadOutOfScreen(amountPad)
    resetButtons()
    amountPad.removeFromParentViewController()
  }
  
  func resetButtons() {
    incomeButton.enabled = true
    expenditureButton.enabled = true
    
    incomeButton.backgroundColor = UIColor(hex: kColorButtonBackground)
    expenditureButton.backgroundColor = UIColor(hex: kColorButtonBackground)
  }
  
  func animateAmountPadOutOfScreen(amountPad: AmountPadViewController) {
    UIView.animateWithDuration(0.3, delay: 0.0, options: [], animations: {
      amountPad.view.frame.origin.y += self.view.frame.size.height
      }, completion: {_ in
        amountPad.view.removeFromSuperview()
    })
  }
}

extension HomeViewController : UIPageViewControllerDataSource {
  
  // MARK: - PageViewController DataSource
  
  func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
    return BalanceInfoType.count()
  }
  
  func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
    return 0
  }
  
  func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
    let balanceInfoViewController = viewController as! BalanceInfoViewController
    var index = balanceInfoViewController.pageIndex
    
    if index == 0 || index == NSNotFound {
      return nil
    }
    
    index--
    return self.balanceInfoViewControllerAtIndex(index)
  }
  
  func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
    let balanceInfoViewController = viewController as! BalanceInfoViewController
    var index = balanceInfoViewController.pageIndex
    
    if index == (BalanceInfoType.count() - 1) || index == NSNotFound {
      return nil
    }
    
    index++
    return self.balanceInfoViewControllerAtIndex(index)
  }
  
  // MARK: - Helper methods for PageViewController
  
  func balanceInfoViewControllerAtIndex(index: Int) -> BalanceInfoViewController? {
    if index < 0 || index >= BalanceInfoType.count() {
      return nil
    }
    
    let viewController = BalanceInfoViewController(type: BalanceInfoType.types()[index], account: self.settings!.selectedAccount!)
    
    viewController.pageIndex = index
    
    return viewController
  }
  
  func initializePageViewController() {
    if self.settings?.selectedAccount == nil {
      return
    }

    // Initialize page view controller
    let pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: [:])
    pageViewController.view.backgroundColor = UIColor(hex: kColorBaseBackground)
    pageViewController.dataSource = self
    
    let startPage = self.balanceInfoViewControllerAtIndex(0)
    pageViewController.setViewControllers([startPage!], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
    
    // add page view controller as a child view controller
    self.addChildViewController(pageViewController)
    
    pageViewController.view.frame = CGRect(x: 0, y: 0, width: self.balanceInfoContainerView.bounds.size.width, height: self.balanceInfoContainerView.bounds.size.height)
    self.balanceInfoContainerView.addSubview(pageViewController.view)
    
    pageViewController.didMoveToParentViewController(self)
    
    self.balancePageViewController = pageViewController
  }
  
  func updateAccountOnPageViewController() {
    let viewControllers = self.balancePageViewController.childViewControllers
    viewControllers.forEach { viewController in
      if let bvc = viewController as? BalanceInfoViewController {
        bvc.account = self.settings?.selectedAccount
        bvc.view.setNeedsDisplay()
      }
    }
  }
}


