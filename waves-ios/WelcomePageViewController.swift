//
//  WelcomePageViewController.swift
//  waves-ios
//
//  Created by Charlie White on 1/16/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

import UIKit

class WelcomePageViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pageViewController: UIPageViewController!
    
    @IBOutlet var pageView: UIView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var button: UIButton!

    private let contentImages = ["walkthrough-intro", "walkthrough-1","walkthrough-2","walkthrough-3","walkthrough-4", "walkthrough-5"]
    private let buttonImages = ["intro-page-btn", "walkthrough-1-btn","walkthrough-2-btn","walkthrough-3-btn","walkthrough-4-btn", "walkthrough-5-btn"]

    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.pageControl.numberOfPages = contentImages.count
        
        createPageViewController()
        setupPageControl()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    
    func createPageViewController() {
        pageViewController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        let firstController = getItemController(0)!
        let startingViewControllers: NSArray = [firstController]
        self.pageViewController.setViewControllers(startingViewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        
        self.pageView.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        //self.view.bringSubviewToFront(self.button)
    }

     func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor(red: 227.0/255.0, green: 228.0/255.0, blue: 236.0/255.0, alpha: 1)
        appearance.currentPageIndicatorTintColor = UIColor(red: 145.0/255.0, green: 148.0/255.0, blue: 150.0/255.0, alpha: 1)
        //appearance.backgroundColor = UIColor.darkGrayColor()
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as WelcomeTourViewController
        
        if itemController.itemIndex > 0 {
            return getItemController(itemController.itemIndex-1)
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as WelcomeTourViewController
        
        if itemController.itemIndex+1 < contentImages.count {
            return getItemController(itemController.itemIndex+1)
        }
        
        return nil
    }
    
    private func getItemController(itemIndex: Int) -> WelcomeTourViewController? {
        
        if itemIndex < contentImages.count {
            let pageItemController = WelcomeTourViewController(nibName: "WelcomeTourViewController", bundle: nil)
            pageItemController.itemIndex = itemIndex
            pageItemController.imageName = contentImages[itemIndex]
            return pageItemController
        }
        
        return nil
    }
    
     func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [AnyObject]) {
        let pageItemController = pendingViewControllers.first as WelcomeTourViewController
        self.pageControl.currentPage = pageItemController.itemIndex
        let image = UIImage(named: self.buttonImages[pageItemController.itemIndex])
        self.button.setImage(image, forState: UIControlState.Normal)
    }
    
    
    @IBAction func advance() {
        let currentVC = self.pageViewController.viewControllers.first as WelcomeTourViewController
        let newIndex = currentVC.itemIndex + 1
        if (newIndex == 6) {
            self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        } else {
            let firstController = getItemController(newIndex)!
            let startingViewControllers: NSArray = [firstController]
            self.pageViewController.setViewControllers(startingViewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: { (bool:Bool) in
                self.pageControl.currentPage = newIndex
                let image = UIImage(named: self.buttonImages[newIndex])
                self.button.setImage(image, forState: UIControlState.Normal)
            })
        }
    }


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
