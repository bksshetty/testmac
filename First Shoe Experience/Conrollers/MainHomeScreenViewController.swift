//
//  OrderPrintViewController.swift
//  FirstShoeExperience
//
//  Created by Openly on 13/04/2015.
//  Copyright (c) 2015 Openly. All rights reserved.
//

import UIKit

class MainHomeScreenViewController: UIViewController {

    
    @IBOutlet weak var makeChangesOrDeleteView: UIView!
    @IBOutlet weak var mainHomeScreenView: UIView!
    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var mainImageVIew: UIImageView!
    @IBOutlet weak var childName: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var sizeLbl: UILabel!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var littleFootBtn: UIButton!
    @IBOutlet weak var editPic: UIButton!
    @IBOutlet weak var confirmPhotoView: UIView!
    @IBOutlet weak var editPhotoView: UIView!
    
    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var makeChangesButton: UIButton!
    @IBOutlet weak var confirmImageView: UIImageView!
    @IBOutlet weak var checkVersionNamelbl: UILabel!
    @IBOutlet weak var checkVersionAgelbl: UILabel!
    @IBOutlet weak var checkVersionAgeValue: UILabel!
    @IBOutlet weak var checkVersionSizeValue: UILabel!
    @IBOutlet weak var checkVersionSizelbl: UILabel!

    @IBAction func didSelectShare(sender: AnyObject) {
        Mixpanel.sharedInstance().track("Share initiated")
        self.presentViewController(ShareDetails.shareInstance.shareImageDetails(), animated: true, completion: nil)
    }
    
    @IBAction func didClickCamera(sender: AnyObject) {
        editPhotoView.hidden = false
    }
    
    @IBAction func didSelectProceed(sender: AnyObject) {
    }
    
    
    @IBAction func didSelectMakeChanges(sender: AnyObject) {
        confirmPhotoView.hidden = true
    }
    
    
    @IBAction func didSelectOrderPrint(sender: AnyObject) {
        confirmPhotoView.hidden = false
        confirmImageView.image = FirstShoes.sharedInstance.loadImage()
        if (FirstShoes.sharedInstance.getChildName() == ""){
            checkVersionNamelbl.text = "My First Shoes"
        }
        else{
            checkVersionNamelbl.text = FirstShoes.sharedInstance.getChildName()
        }
        if (FirstShoes.sharedInstance.getChildAge() == ""){
            checkVersionAgelbl.hidden = true
            checkVersionAgeValue.hidden = true
        }
        else{
            checkVersionAgelbl.hidden = false
            checkVersionAgeValue.hidden = false
            checkVersionAgeValue.text = FirstShoes.sharedInstance.getChildAge()
        }
        if (FirstShoes.sharedInstance.getChildShoeSizeAndFitting() == ""){
            checkVersionSizelbl.hidden = true
            checkVersionSizeValue.hidden = true
        }
        else{
            checkVersionSizelbl.hidden = false
            checkVersionSizeValue.hidden = false
            checkVersionSizeValue.text = FirstShoes.sharedInstance.getChildShoeSizeAndFitting()
        }
        
    }
    
    @IBAction func dontDeletePhoto(sender: AnyObject) {
        editPhotoView.hidden = true
    }
    
    @IBAction func didCLickEdit(sender: AnyObject) {
        editPhotoView.hidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if (UIScreen.mainScreen().bounds.height <= 480){
            var mainHomeScreenViewWidthConstraint = NSLayoutConstraint (item: mainHomeScreenView,
                attribute: NSLayoutAttribute.Width,
                relatedBy: NSLayoutRelation.Equal,
                toItem: nil,
                attribute: NSLayoutAttribute.NotAnAttribute,
                multiplier: 1,
                constant: 226)
           
            var makeChangesOrDeleteViewConstraint = NSLayoutConstraint (item: makeChangesOrDeleteView,
                attribute: NSLayoutAttribute.Width,
                relatedBy: NSLayoutRelation.Equal,
                toItem: nil,
                attribute: NSLayoutAttribute.NotAnAttribute,
                multiplier: 1,
                constant: 226)
            
            var constraints = [mainHomeScreenViewWidthConstraint,makeChangesOrDeleteViewConstraint
            ];
            self.view.addConstraints(constraints)
            self.view.addSubview(mainHomeScreenView)
            self.view.layoutIfNeeded()
        }
        mainImageVIew.image = FirstShoes.sharedInstance.loadImage()
        
        
        refresh()
        confirmPhotoView.hidden = true
        cameraBtn.layer.borderColor = UIColor ( red : (165/255.0) , green : (165/255.0) , blue : (165/255.0) , alpha : 1.0).CGColor
        cameraBtn.layer.borderWidth = 1
        littleFootBtn.layer.borderColor = UIColor ( red : (165/255.0) , green : (165/255.0) , blue : (165/255.0) , alpha : 1.0).CGColor
        littleFootBtn.layer.borderWidth = 1
        editPhotoView.hidden = true

    }

    override func viewDidAppear(animated: Bool) {
        refresh() ;
    }
    
    func refresh(){
        if (FirstShoes.sharedInstance.getChildName() == ""){
            childName.text = "My First Shoes"
        }
        else{
            childName.text = FirstShoes.sharedInstance.getChildName()
        }
        if (FirstShoes.sharedInstance.getChildAge() == ""){
            age.hidden = true
            ageLbl.hidden = true ;
        }else{
            age.hidden = false
            ageLbl.hidden = false
            ageLbl.text = FirstShoes.sharedInstance.getChildAge()
        }
        if (FirstShoes.sharedInstance.getChildShoeSizeAndFitting() == ""){
            size.hidden = true ;
            sizeLbl.hidden = true ;
        }else{
            size.hidden = false ;
            sizeLbl.hidden = false ;
            sizeLbl.text = FirstShoes.sharedInstance.getChildShoeSizeAndFitting()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.destinationViewController is personaliseViewController){
            var destVc: personaliseViewController =  segue.destinationViewController as! personaliseViewController;
            
            destVc.previousVC = self;
        }
    }
}
