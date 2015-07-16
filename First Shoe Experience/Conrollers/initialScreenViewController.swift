//
//  initialScreenViewController.swift
//  FirstShoeExperience
//
//  Created by Openly on 25/03/2015.
//  Copyright (c) 2015 Openly. All rights reserved.
//

import UIKit
import AVFoundation

 

class initialScreenViewController: UIViewController {
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var littleFootBtn: UIButton!
    @IBOutlet weak var myFirstShoes: UILabel!
    
    
    @IBOutlet weak var photoView: UIView!
    @IBAction func didClickLittleFoothealthLab(sender: AnyObject) {
        Mixpanel.sharedInstance().track("View Footpath Lab")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraBtn.layer.borderColor = UIColor ( red : (165/255.0) , green : (165/255.0) , blue : (165/255.0) , alpha : 1.0).CGColor
        cameraBtn.layer.borderWidth = 1
        littleFootBtn.layer.borderColor = UIColor ( red : (165/255.0) , green : (165/255.0) , blue : (165/255.0) , alpha : 1.0).CGColor
        littleFootBtn.layer.borderWidth = 1
    }
}
