//
//  FinalScreenViewController.swift
//  FirstShoeExperience
//
//  Created by Openly on 17/04/2015.
//  Copyright (c) 2015 Openly. All rights reserved.
//
import CoreGraphics
import UIKit

class FinalScreenViewController: UIViewController {

    @IBOutlet weak var finalView: UIView!
    @IBOutlet weak var footHealthLabButton: UIView!
    @IBOutlet weak var camButton: UIView!
    @IBOutlet weak var shoeSize: UILabel!
    @IBOutlet weak var childAge: UILabel!
    @IBOutlet weak var childName: UILabel!
    @IBOutlet weak var finalImageView: UIImageView!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var southBorder : UIView!
    @IBOutlet weak var cameraButton : UIButton!
    @IBOutlet weak var topViewConstraint: NSLayoutConstraint!
    
    var firstShoes = FirstShoes.sharedInstance
    
    @IBAction func didClickFootHealth(sender: AnyObject) {
        Mixpanel.sharedInstance().track("View Footpath Lab")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Mixpanel.sharedInstance().track("Print Ordered")
        if (UIScreen.mainScreen().bounds.height <= 480){
            topViewConstraint.constant = 84;
            var mainHomeScreenViewWidthConstraint = NSLayoutConstraint (item: finalView,
                attribute: NSLayoutAttribute.Width,
                relatedBy: NSLayoutRelation.Equal,
                toItem: nil,
                attribute: NSLayoutAttribute.NotAnAttribute,
                multiplier: 1,
                constant: 226)
            
            var constraints = [mainHomeScreenViewWidthConstraint];
            self.view.addConstraints(constraints)
        }

        
        
        finalView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI * (-2) / 180.0));
        southBorder.transform = CGAffineTransformMakeRotation(CGFloat(M_PI * (-2) / 180.0));
        finalView.layer.shouldRasterize = true;
        southBorder.layer.shouldRasterize = true
        childName.layer.shouldRasterize = true ;
        childAge.layer.shouldRasterize = true
        size.layer.shouldRasterize = true
        ageLbl.layer.shouldRasterize = true
        shoeSize.layer.shouldRasterize = true
        
        finalImageView.image = FirstShoes.sharedInstance.getImage()
        
        if (FirstShoes.sharedInstance.getChildName() == ""){
            childName.text = "My First Shoes"
        }
        else{
            childName.text = FirstShoes.sharedInstance.getChildName()
        }
        if (FirstShoes.sharedInstance.getChildAge() == ""){
            childAge.hidden = true
            ageLbl.hidden = true ;
        }else{
            childAge.hidden = false
            ageLbl.hidden = false
            childAge.text = FirstShoes.sharedInstance.getChildAge()
        }
        if (FirstShoes.sharedInstance.getChildShoeSizeAndFitting() == ""){
            size.hidden = true ;
            shoeSize.hidden = true ;
        }else{
            size.hidden = false ;
            shoeSize.hidden = false ;
            shoeSize.text = FirstShoes.sharedInstance.getChildShoeSizeAndFitting()
        }
        
        
        if (FirstShoes.sharedInstance.getChildName() == ""){
            childName.text = "My First Shoes"
        }
        else{
            childName.text = FirstShoes.sharedInstance.getChildName()
        }
        if (FirstShoes.sharedInstance.getChildAge() == ""){
            childAge.text = "1 year 3 months "
        }else{
            childAge.text = FirstShoes.sharedInstance.getChildAge()
        }
        if (FirstShoes.sharedInstance.getChildShoeSizeAndFitting() == ""){
            shoeSize.text = "2F"
        }else{
            shoeSize.text = FirstShoes.sharedInstance.getChildShoeSizeAndFitting()
        }
        cameraButton.enabled = false ;
        
        camButton.layer.borderColor = UIColor ( red : (165/255.0) , green : (165/255.0) , blue : (165/255.0) , alpha : 1.0).CGColor
        camButton.layer.borderWidth = 1
        footHealthLabButton.layer.borderColor = UIColor ( red : (165/255.0) , green : (165/255.0) , blue : (165/255.0) , alpha : 1.0).CGColor
        footHealthLabButton.layer.borderWidth = 1
        
        
    }

    @IBAction func didClickShare(sender: AnyObject) {
        Mixpanel.sharedInstance().track("Share initiated")
        self.presentViewController(ShareDetails.shareInstance.shareImageDetails(), animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
