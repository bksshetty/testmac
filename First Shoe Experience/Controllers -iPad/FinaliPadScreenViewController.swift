//
//  FinaliPadScreenViewController.swift
//  First Shoe Experience
//
//  Created by Openly on 18/05/2015.
//  Copyright (c) 2015 Openly. All rights reserved.
//

import UIKit

class FinaliPadScreenViewController: UIViewController {

    @IBOutlet weak var finalView: UIView!
    @IBOutlet weak var shoeSize: UILabel!
    @IBOutlet weak var childAge: UILabel!
    @IBOutlet weak var childName: UILabel!
    @IBOutlet weak var finalImageView: UIImageView!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var southBorder : UIView!
    
    var successAlert = UIAlertView()
    
    @IBAction func clearMyDetails(sender: AnyObject) {
        
        successAlert.title = "Photo and data have been removed"
        successAlert.addButtonWithTitle("OK")
        successAlert.show()
        reset()

    }
    
    func reset(){
        FirstShoes.sharedInstance.childName = "" ;
        FirstShoes.sharedInstance.childDOB  = "" ;
        FirstShoes.sharedInstance.childAge = "" ;
        FirstShoes.sharedInstance.childShoeSizeAndFitting = "" ;
        FirstShoes.sharedInstance.childGender = "" ;
        FirstShoes.sharedInstance.yourFirstName = "" ;
        FirstShoes.sharedInstance.yourGender = "" ;
        FirstShoes.sharedInstance.yourEmail = "" ;
        FirstShoes.sharedInstance.addressLine1 = "" ;
        FirstShoes.sharedInstance.addressLine2 = "" ;
        FirstShoes.sharedInstance.city = "" ;
        FirstShoes.sharedInstance.postcode = "" ;
        FirstShoes.sharedInstance.imageTaken = UIImage() ;
        FirstShoes.sharedInstance.imagePath = "" ;
        FirstShoes.sharedInstance.yourSurname = "" ;
        FirstShoes.sharedInstance.promo_code =  false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            ageLbl.text = FirstShoes.sharedInstance.getChildAge()
        }
        if (FirstShoes.sharedInstance.getChildShoeSizeAndFitting() == ""){
            size.hidden = true ;
            shoeSize.hidden = true ;
        }else{
            size.hidden = false ;
            shoeSize.hidden = false ;
            size.text = FirstShoes.sharedInstance.getChildShoeSizeAndFitting()
        }

        // Do any additional setup after loading the view.
    }
}
