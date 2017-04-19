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
    
    // white status bar
    UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent

    // remove line below the navigation bar
    if let navigationBar = self.navigationController?.navigationBar {
      navigationBar.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
      navigationBar.shadowImage = UIImage()
    }
    
    // initialize Page View Controller
    initializePageViewController()
  }
  
  override func viewDidAppear(_ animated: Bool) {
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

  @IBAction func incomeButtonTouchDown(_ sender: UIButton) {
    sender.backgroundColor = UIColor(hex: kColorHighlightedButtonBackground)
  }

  @IBAction func expenditureButtonTouchDown(_ sender: UIButton) {
    sender.backgroundColor = UIColor(hex: kColorHighlightedButtonBackground)
  }

  @IBAction func incomeButtonPressed(_ sender: UIButton) {
    incomeButton.isEnabled = false
    expenditureButton.isEnabled = false

    openAmountPadInMode(.income, okHandler: amountPadDidPressOk, cancelHandler: nil, maskRect: {
      avc in
      return CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: avc.view.bounds.size.height - self.incomeButton.bounds.size.height - 3)
    })
  }

  @IBAction func expenditureButtonPressed(_ sender: UIButton) {
    incomeButton.isEnabled = false
    expenditureButton.isEnabled = false

    openAmountPadInMode(.expenditure, okHandler: amountPadDidPressOk, cancelHandler: nil, maskRect: {
      avc in
      return CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: avc.view.bounds.size.height - self.incomeButton.bounds.size.height - 3)
    })
  }

  @IBAction func mainMenuButtonPressed(_ sender: UIBarButtonItem) {
    if let svc = self.slideMenuViewController {
      if svc.menuOpened {
        svc.closeMenu(true)
      } else {
        svc.openMenu(true)
      }
    }
  }

  // MARK: - Private methods

  fileprivate func checkSelectedAccount() {
    if self.settings?.selectedAccount == nil {
      let createAccountViewController = CreateAccountFormViewController()
      createAccountViewController.onCreateAccount = { viewController, account in
        self.initializePageViewController()
      }
      
      //self.navigationController?.present(createAccountViewController, animated: true, completion: nil)
      self.navigationController?.pushViewController(createAccountViewController, animated: true)
    }
    
    if let account = self.settings?.selectedAccount {
      account.updateData()
    }
  }
  
  fileprivate func updateActivityTableView() {
    self.activityTableView.reloadData()
    let count = tableView(self.activityTableView, numberOfRowsInSection: 0)
    if count > 0 {
      let indexPath = IndexPath(row: count - 1, section: 0)
      self.activityTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
  }
}

extension HomeViewController {
  func didChangeAccountSelection(_ account: Account) {
    self.settings?.selectedAccount = account
    self.settings?.save()
    self.activityTableView.reloadData()
    updateAccountOnPageViewController()
  }
}

extension HomeViewController : UITableViewDataSource, UITableViewDelegate {
  // MARK: - UITableViewDataSource, UITableViewDelegate
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let count = self.settings?.selectedAccount?.latestActivities(5).count else {
      print("Invalid data: Number of elements in TableView cannot be determined.")
      return 0
    }
    return count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: kIdActivityCell) as! ActivityTableViewCell
    
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
  fileprivate func setSelectedBackgroundColorForCell(_ cell: UITableViewCell) {
    cell.selectedBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: cell.bounds.size.height))
    cell.selectedBackgroundView?.backgroundColor = UIColor(hex: kColorTableViewSelection)
  }
}

extension HomeViewController {
  
  func amountPadDidPressOk(_ amountPad: AmountPadViewController) {
    let title = amountPad.mode == .income ? self.settings?.defaultTitleIncome :
        self.settings?.defaultTitleExpenditure
    self.settings?.selectedAccount?.addActivityForDate(Date(), title: title!, icon: "", amount: amountPad.finalAmount)
    self.activityTableView.reloadData()
    
    closeAmountPad(amountPad) {
      self.resetButtons()
      self.updateAccountOnPageViewController()
    }
  }
  
  func amountPadDidPressCancel(_ amountPad: AmountPadViewController) {
    closeAmountPad(amountPad) {
      self.resetButtons()
    }
  }
  
  func resetButtons() {
    incomeButton.isEnabled = true
    expenditureButton.isEnabled = true
    
    incomeButton.backgroundColor = UIColor(hex: kColorButtonBackground)
    expenditureButton.backgroundColor = UIColor(hex: kColorButtonBackground)
  }
}

extension HomeViewController : UIPageViewControllerDataSource {
  
  // MARK: - PageViewController DataSource
  
  func presentationCount(for pageViewController: UIPageViewController) -> Int {
    return BalanceInfoType.count()
  }
  
  func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    return 0
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    let balanceInfoViewController = viewController as! BalanceInfoViewController
    var index = balanceInfoViewController.pageIndex
    
    if index == 0 || index == NSNotFound {
      return nil
    }
    
    index -= 1
    return self.balanceInfoViewControllerAtIndex(index)
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    let balanceInfoViewController = viewController as! BalanceInfoViewController
    var index = balanceInfoViewController.pageIndex
    
    if index == (BalanceInfoType.count() - 1) || index == NSNotFound {
      return nil
    }
    
    index += 1
    return self.balanceInfoViewControllerAtIndex(index)
  }
  
  // MARK: - Helper methods for PageViewController
  
  func balanceInfoViewControllerAtIndex(_ index: Int) -> BalanceInfoViewController? {
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
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.horizontal, options: [:])
    pageViewController.view.backgroundColor = UIColor(hex: kColorBaseBackground)
    pageViewController.dataSource = self
    
    let startPage = self.balanceInfoViewControllerAtIndex(0)
    pageViewController.setViewControllers([startPage!], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
    
    // add page view controller as a child view controller
    self.addChildViewController(pageViewController)
    
    pageViewController.view.frame = CGRect(x: 0, y: 0, width: self.balanceInfoContainerView.bounds.size.width, height: self.balanceInfoContainerView.bounds.size.height)
    self.balanceInfoContainerView.addSubview(pageViewController.view)
    
    pageViewController.didMove(toParentViewController: self)
    
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


