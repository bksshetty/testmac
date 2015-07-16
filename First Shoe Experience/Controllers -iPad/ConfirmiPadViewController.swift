//
//  ConfirmiPadViewController.swift
//  First Shoe Experience
//
//  Created by Openly on 18/05/2015.
//  Copyright (c) 2015 Openly. All rights reserved.
//

import UIKit
import AVFoundation

class ConfirmiPadViewController: UIViewController {
    
    @IBOutlet weak var confirmiPadImage: UIImageView!

    @IBAction func didConfirmPhoto(sender: AnyObject) {
        Mixpanel.sharedInstance().track("Photo Confirmed")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        if (device.hasTorch) {
            device.lockForConfiguration(nil)
            device.torchMode = AVCaptureTorchMode.Off
            device.unlockForConfiguration()
        }
        confirmiPadImage.image = FirstShoes.sharedInstance.loadImage()
    }
}
