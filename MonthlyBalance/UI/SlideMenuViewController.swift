//
//  SlideMenuViewController.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 09.12.15.
//  Copyright © 2015 Karrmarr Software. All rights reserved.
//

import UIKit

class SlideMenuViewController : UIViewController {
  
  var menuViewController : UIViewController!
  var contentViewController : UIViewController!
  
  var menuWidth: CGFloat = 0
  
  var menuOpened: Bool {
    return self.contentViewController.view.frame.origin.x > 0
  }
  
  // MARK: Initialization
  
  init(menuViewController: UIViewController, contentViewController: UIViewController) {
    super.init(nibName: nil, bundle: nil)
    
    self.menuViewController = menuViewController
    self.contentViewController = contentViewController
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    self.addChildViewController(contentViewController)
    self.contentViewController.view.frame = self.view.bounds
    self.view.addSubview(self.contentViewController.view)
    self.contentViewController.didMove(toParentViewController: self)
    
    if self.menuWidth == 0 {
      self.menuWidth = self.view.bounds.size.width * 0.6
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.contentViewController.beginAppearanceTransition(true, animated: animated)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    self.contentViewController.endAppearanceTransition()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    self.contentViewController.beginAppearanceTransition(false, animated: animated)
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    self.contentViewController.endAppearanceTransition()
  }
  
  // MARK: Menu actions
  
  func openMenu(_ animated: Bool) {
    self.loadMenuViewController()
    
    let duration = animated ? 0.3 : 0
    var contentFrame = self.contentViewController.view.frame
    contentFrame.origin.x += self.menuWidth
    self.menuViewController.beginAppearanceTransition(true, animated: animated)
    
    UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions(), animations: {
      self.contentViewController.view.frame = contentFrame
      self.addShadowToContentView()
    }, completion: {_ in
      self.menuViewController.endAppearanceTransition()
    })
  }
  
  func closeMenu(_ animated: Bool) {
    let duration = animated ? 0.3 : 0
    var contentFrame = self.contentViewController.view.frame
    contentFrame.origin.x = 0
    self.menuViewController.beginAppearanceTransition(false, animated: animated)
    
    UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions(), animations: {
      self.contentViewController.view.frame = contentFrame
    }, completion: {_ in
      self.menuViewController.endAppearanceTransition()
      self.removeShadowFromContentView()
    })
  }
  
  // Private methods
  
  fileprivate func loadMenuViewController() {
    self.addChildViewController(self.menuViewController)
    self.menuViewController.view.frame = CGRect(x: 0, y: 0, width: self.menuWidth, height: self.view.bounds.size.height)
    self.view.insertSubview(self.menuViewController.view, at: 0)
    self.menuViewController.didMove(toParentViewController: self)
  }
  
  fileprivate func addShadowToContentView() {
    let layer = self.contentViewController.view.layer
    
    layer.masksToBounds = false
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.4
    layer.shadowRadius = 5
    layer.shadowPath = UIBezierPath(rect: self.contentViewController.view.bounds).cgPath
    layer.shadowOffset = CGSize(width: -2.5, height: 3)
  }
  
  fileprivate func removeShadowFromContentView() {
    let layer = self.contentViewController.view.layer
    
    layer.masksToBounds = true
  }
}
