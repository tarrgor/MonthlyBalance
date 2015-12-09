//
//  HomeViewControllerPageViewExtension.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 19.11.15.
//  Copyright © 2015 Karrmarr Software. All rights reserved.
//

import UIKit

extension HomeViewController : UIPageViewControllerDataSource {
  
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

  func initializePageViewController() {
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
}
