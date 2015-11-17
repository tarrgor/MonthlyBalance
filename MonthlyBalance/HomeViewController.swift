//
//  ViewController.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 08.11.15.
//  Copyright © 2015 Karrmarr Software. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIPageViewControllerDataSource {

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

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: - Helper methods for PageViewController
  
  func balanceInfoViewControllerAtIndex(index: Int) -> BalanceInfoViewController? {
    if index < 0 || index >= self.balanceTitles.count {
      return nil
    }
    
    let viewController = BalanceInfoViewController()
    let view = viewController.view as! BalanceInfoView
    
    view.headline = self.balanceTitles[index]
    viewController.pageIndex = index
    
    return viewController
  }
  
  override func updateViewConstraints() {
    self.gradientLayer.frame = self.gradientBackgroundView.layer.bounds
    
    super.updateViewConstraints()
  }
  
  // MARK: - PageViewController DataSource
  
  func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
    return self.balanceTitles.count
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
    
    if index == (self.balanceTitles.count - 1) || index == NSNotFound {
      return nil
    }
    
    index++
    return self.balanceInfoViewControllerAtIndex(index)
  }
    
  // MARK: - Private methods
  
  private func initializePageViewController() {
    // Initialize page view controller
    let pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: [:])
    pageViewController.view.backgroundColor = UIColor(hex: kBaseBackgroundColor)
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





