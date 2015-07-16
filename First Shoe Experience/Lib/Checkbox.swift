//
//  Checkbox.swift
//  FirstShoeExperience
//
//  Created by Openly on 15/04/2015.
//  Copyright (c) 2015 Openly. All rights reserved.
//

import UIKit

class Checkbox: UIButton {
    
    //images
    let checkedImage = UIImage(named: "tick")
    let unCheckedImage = UIImage(named: "unchecked_checkbox@2x")
    
    var isChecked:Bool = true {
        didSet{
            if isChecked == true {
                self.layer.borderColor = UIColor  (red: (255/255.0), green: (196/255.0), blue: (0/255.0), alpha: 1.0).CGColor;
                self.layer.borderWidth = 1 ;
                FirstShoes.sharedInstance.promo_code = true
                self.setImage(checkedImage, forState: .Normal)
            }else{
                self.layer.borderWidth = 0 ;
                self.setImage(unCheckedImage, forState: .Normal)
                FirstShoes.sharedInstance.promo_code = false
                
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        self.isChecked = false
    }
    
    func buttonClicked(sender: UIButton){
        if(sender == self){
            if isChecked == true {
                FirstShoes.sharedInstance.promo_code = true
                isChecked = false
            }
            else
            {
                isChecked = true
                FirstShoes.sharedInstance.promo_code = false
            }
        }
    }
}
