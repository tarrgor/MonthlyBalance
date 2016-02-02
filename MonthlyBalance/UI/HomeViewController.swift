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
  
  var balancePageViewController: UIPageViewController?

  var mainMenuOpened: Bool = false

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // remove line below the navigation bar
    if let navigationBar = self.navigationController?.navigationBar {
      navigationBar.setBackgroundImage(UIImage(), forBarPosition: UIBarPosition.Any, barMetrics: UIBarMetrics.Default)
      navigationBar.shadowImage = UIImage()
    }
    
    // initialize Page View Controller
    initializePageViewController()
  }
  
  override func viewDidAppear(animated: Bool) {
    checkSelectedAccount()

    updateAccountOnPageViewController()
    updateActivityTableView()
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

    openAmountPadInMode(.Income, delegate: self, maskRect: {
      avc in
      return CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: avc.view.bounds.size.height - self.incomeButton.bounds.size.height - 3)
    })
  }

  @IBAction func expenditureButtonPressed(sender: UIButton) {
    incomeButton.enabled = false
    expenditureButton.enabled = false

    openAmountPadInMode(.Expenditure, delegate: self, maskRect: {
      avc in
      return CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: avc.view.bounds.size.height - self.incomeButton.bounds.size.height - 3)
    })
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
      guard let createAccountViewController = self.storyboard?.instantiateViewControllerWithIdentifier(kIdCreateAccountViewController) as? CreateAccountViewController
      else {
        print("Error")
        return
      }

      createAccountViewController.delegate = self
      
      self.navigationController?.presentViewController(createAccountViewController, animated: true, completion: nil)
    }
  }
  
  private func updateActivityTableView() {
    self.activityTableView.reloadData()
    let count = tableView(self.activityTableView, numberOfRowsInSection: 0)
    if count > 0 {
      let indexPath = NSIndexPath(forRow: count - 1, inSection: 0)
      self.activityTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
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

extension HomeViewController : CreateAccountDelegate {
  
  func createAccountViewControllerDidCreateAccount(viewController: CreateAccountViewController, account: Account) {
    initializePageViewController()
  }
}

extension HomeViewController : UITableViewDataSource, UITableViewDelegate {
  // MARK: - UITableViewDataSource, UITableViewDelegate
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let count = self.settings?.selectedAccount?.latestActivities(5).count else {
      print("Invalid data: Number of elements in TableView cannot be determined.")
      return 0
    }
    return count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(kIdActivityCell) as! ActivityTableViewCell
    
    guard let activity: Activity = self.settings?.selectedAccount?.latestActivities(5)[indexPath.row]
      else {
        cell.titleLabel.text = "ERROR!"
        setSelectedBackgroundColorForCell(cell)
        return cell
    }
    
    cell.titleLabel.text = activity.title
    cell.timeLabel.text = activity.date?.displayText
    cell.iconImageView.image = UIImage()
    
    guard let amount = activity.amount
      else {
        cell.amountLabel.text = "ERR!"
        setSelectedBackgroundColorForCell(cell)
        return cell
    }
    
    cell.amountLabel.amount = Double(amount)
    
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
    self.settings?.selectedAccount?.addActivityForDate(NSDate(), title: title!, icon: "", amount: amountPad.finalAmount)
    self.activityTableView.reloadData()
    
    closeAmountPad(amountPad) {
      self.resetButtons()
      self.updateAccountOnPageViewController()
    }
  }
  
  func amountPadDidPressCancel(amountPad: AmountPadViewController) {
    closeAmountPad(amountPad) {
      self.resetButtons()
    }
  }
  
  func resetButtons() {
    incomeButton.enabled = true
    expenditureButton.enabled = true
    
    incomeButton.backgroundColor = UIColor(hex: kColorButtonBackground)
    expenditureButton.backgroundColor = UIColor(hex: kColorButtonBackground)
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
    if self.balancePageViewController != nil {
      let viewControllers = self.balancePageViewController!.childViewControllers
      viewControllers.forEach { viewController in
        if let bvc = viewController as? BalanceInfoViewController {
          bvc.account = self.settings?.selectedAccount
          bvc.view.setNeedsDisplay()
        }
      }
    }
  }
}


