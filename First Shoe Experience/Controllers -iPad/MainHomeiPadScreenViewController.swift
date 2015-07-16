//
//  MainHomeiPadScreenViewController.swift
//  First Shoe Experience
//
//  Created by Openly on 18/05/2015.
//  Copyright (c) 2015 Openly. All rights reserved.
//

import UIKit

class MainHomeiPadScreenViewController: UIViewController {

    
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var childNamelbl: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var ageValue: UILabel!
    @IBOutlet weak var sizeLbl: UILabel!
    @IBOutlet weak var sizeValue: UILabel!
    @IBOutlet weak var confirmView: UIView!
    @IBOutlet weak var checkView: UIView!
    @IBOutlet weak var checkViewChildName: UILabel!
    @IBOutlet weak var checkViewChildAge: UILabel!
    @IBOutlet weak var checkViewChildAgeValue: UILabel!
    @IBOutlet weak var checkViewChildSize: UILabel!
    @IBOutlet weak var checkViewChildSizeValue: UILabel!
    @IBOutlet weak var checkViewImage: UIImageView!
    
    @IBAction func didClickCamera(sender: AnyObject) {
        confirmView.hidden = false
    }
    @IBAction func didClickEdit(sender: AnyObject) {
        
    }
    @IBAction func didClickOrder(sender: UIButton) {
        checkView.hidden = false
        checkViewImage.image = FirstShoes.sharedInstance.loadImage()
        if (FirstShoes.sharedInstance.getChildName() == ""){
            checkViewChildName.text = "My First Shoes"
        }
        else{
            checkViewChildName.text = FirstShoes.sharedInstance.getChildName()
        }
        if (FirstShoes.sharedInstance.getChildAge() == ""){
            checkViewChildAge.hidden = true
            checkViewChildAgeValue.hidden = true
        }
        else{
            checkViewChildAge.hidden = false
            checkViewChildAgeValue.hidden = false
            checkViewChildAgeValue.text = FirstShoes.sharedInstance.getChildAge()
        }
        if (FirstShoes.sharedInstance.getChildShoeSizeAndFitting() == ""){
            checkViewChildSize.hidden = true
            checkViewChildSizeValue.hidden = true
        }
        else{
            checkViewChildSize.hidden = false
            checkViewChildSizeValue.hidden = false
            checkViewChildSizeValue.text = FirstShoes.sharedInstance.getChildShoeSizeAndFitting()
        }

    }
    @IBAction func didClickMakeChanges(sender: AnyObject) {
        checkView.hidden = true
    }
    @IBAction func didClickNo(sender: AnyObject) {
        confirmView.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        refresh() ;
    }
    
    func refresh(){
        if (FirstShoes.sharedInstance.getChildName() == ""){
            childNamelbl.text = "My First Shoes"
        }
        else{
            childNamelbl.text = FirstShoes.sharedInstance.getChildName()
        }
        if (FirstShoes.sharedInstance.getChildAge() == ""){
            ageLbl.hidden = true
            ageValue.hidden = true ;
        }else{
            ageLbl.hidden = false
            ageValue.hidden = false
            ageValue.text = FirstShoes.sharedInstance.getChildAge()
        }
        if (FirstShoes.sharedInstance.getChildShoeSizeAndFitting() == ""){
            sizeLbl.hidden = true ;
            sizeValue.hidden = true ;
        }else{
            sizeLbl.hidden = false ;
            sizeValue.hidden = false ;
            sizeValue.text = FirstShoes.sharedInstance.getChildShoeSizeAndFitting()
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        childImageView.image = FirstShoes.sharedInstance.getImage()
        refresh()
        confirmView.hidden = true
        checkView.hidden = true
        
    }
}
