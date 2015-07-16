//
//  CustomKeyboard.swift
//  FirstShoeExperience
//
//  Created by Openly on 23/04/2015.
//  Copyright (c) 2015 Openly. All rights reserved.
//

import Foundation
import UIKit

class CustomKeyboard : UITextField {
    override func awakeFromNib() {
        self.addTarget(self, action: "textFieldClicked:", forControlEvents: UIControlEvents.EditingDidBegin);
    }
    
    func textFieldClicked(textField : UITextField){
        
    }
    func createButton()->UIButton{
        var button:UIButton;
        button = UIButton(frame: CGRectMake(0, 0, 30, 30))
        button.setTitle("Done", forState: UIControlState.Normal)
        
        return button
    }
    
}