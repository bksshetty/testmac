//
//  ScrollViewController.swift
//  FirstShoeExperience
//
//  Created by Openly on 21/04/2015.
//  Copyright (c) 2015 Openly. All rights reserved.
//

import UIKit

class ScrollViewController: UIViewController, UIPageViewControllerDataSource {

    var pageViewController = UIPageViewController()
    var pageImages = NSArray()
    
    @IBOutlet weak var cameraButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        //cameraButton.frame.width = CGFoalt (self.view.frame.width/2);
        
        
        
        self.pageImages = NSArray(objects:  "Clarks-FirstShoes-StaticContent-v4-01",
                                            "Clarks-FirstShoes-StaticContent-v4-02",
                                            "Clarks-FirstShoes-StaticContent-v4-03",
                                            "Clarks-FirstShoes-StaticContent-v4-04",
                                            "Clarks-FirstShoes-StaticContent-v4-05",
                                            "Clarks-FirstShoes-StaticContent-v4-06",
                                            "Clarks-FirstShoes-StaticContent-v4-07",
                                            "Clarks-FirstShoes-StaticContent-v4-08",
                                            "Clarks-FirstShoes-StaticContent-v4-09",
                                            "Clarks-FirstShoes-StaticContent-v4-10",
                                            "Clarks-FirstShoes-StaticContent-v4-11",
                                            "Clarks-FirstShoes-StaticContent-v4-12",
                                            "Clarks-FirstShoes-StaticContent-v4-13",
                                            "Clarks-FirstShoes-StaticContent-v4-14",
                                            "Clarks-FirstShoes-StaticContent-v4-15"
        )
        
        
        self.pageViewController = storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        self.pageViewController.dataSource = self
        var startVc = self.viewCOntrollerAtIndex(0) as ContentViewController
        var viewControllers = NSArray(object: startVc);
        
        self.pageViewController.setViewControllers(viewControllers as [AnyObject], direction: .Forward, animated: true, completion: nil)
        self.pageViewController.view.frame = CGRectMake(0, 20, self.view.frame.width, self.view.frame.size.height - 10)
        self.addChildViewController(self.pageViewController)
        
        self.view.addSubview(self.pageViewController.view)
        self.view.bringSubviewToFront(cameraButton)
        self.pageViewController.didMoveToParentViewController(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didClickClose(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        });
    }
    
    func viewCOntrollerAtIndex(index: Int) -> ContentViewController{
        if ((self.pageImages.count == 0) || (index >= self.pageImages.count)){
            return ContentViewController()
        }
        var vc: ContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ContentViewController") as! ContentViewController
        vc.imageFile = self.pageImages[index] as! String
        vc.pageIndex = index;
        return vc;
        
    }
    // Mark - Page View Controller Data Source
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var vc = viewController as! ContentViewController
        var index = vc.pageIndex as Int
        
        if (index == 0) || (index == NSNotFound){
            return nil
        }
        index--
        return self.viewCOntrollerAtIndex(index)
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var vc =  viewController as! ContentViewController
        var index = vc.pageIndex as Int
        
        if (index == NSNotFound){
            return nil
        }
        
        index++
        
        if (index == self.pageImages.count){
            return nil
        }
        
        return self.viewCOntrollerAtIndex(index)
        
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pageImages.count
    }
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0 ;
    }
}
