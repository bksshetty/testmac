//
//  confirmPhotoViewController.swift
//  FirstShoeExperience
//
//  Created by Openly on 06/04/2015.
//  Copyright (c) 2015 Openly. All rights reserved.
//

import UIKit
import AVFoundation
import UIKit
import OpenGLES

class confirmPhotoViewController: UIViewController {
    @IBOutlet weak var confirmImage: UIImageView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var takeAgainView: UIView!
    @IBOutlet weak var useThisView: UIView!
    @IBOutlet weak var useThisOneBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var takeAgainBottomConstraint: NSLayoutConstraint!
    
    var image = UIImage()
    
    @IBAction func didConfirmPhoto(sender: AnyObject) {
        var destVC : personaliseViewController = self.storyboard?.instantiateViewControllerWithIdentifier("personalise_screen")! as! personaliseViewController;
        self.presentViewController(destVC, animated: true, completion: { () -> Void in
        })
        Mixpanel.sharedInstance().track("Picture confirmed")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        if (device.hasTorch) {
                device.lockForConfiguration(nil)
                device.torchMode = AVCaptureTorchMode.Off
                device.unlockForConfiguration()
        }
        confirmImage.image = FirstShoes.sharedInstance.loadImage()
        topView.layer.borderWidth = 1
        topView.layer.borderColor = UIColor (red: (211/255.0), green: (211/255.0), blue: (211/255.0), alpha: 1.0).CGColor;
    }
}
