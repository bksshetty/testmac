//
//  livefinderViewController.swift
//  FirstShoeExperience
//
//  Created by Openly on 31/03/2015.
//  Copyright (c) 2015 Openly. All rights reserved.
//

import UIKit
import AVFoundation
import UIKit
import OpenGLES


class livefinderViewController: UIViewController{
   
   
    @IBOutlet weak var trailingSpaceFlash: NSLayoutConstraint!
    @IBOutlet weak var flashWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var flashImage: UIImageView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var capture: UIButton!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var flash: UIButton!
    
    var captureSession : AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var previewLayer : AVCaptureVideoPreviewLayer?
    var capImg: UIImage?
    var backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo);
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    
    @IBAction func turnFlashOn(sender: AnyObject) {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        if (device.hasTorch) {
            device.lockForConfiguration(nil)
            if (device.torchMode == AVCaptureTorchMode.On) {
                Mixpanel.sharedInstance().track("Flash on")
                flash.setTitle("Flash On", forState: UIControlState.Normal)
                flashImage.image = UIImage(named: "flash-grey-on");
                flashWidthConstraint.constant = 8;
                trailingSpaceFlash.constant = 30;
                device.torchMode = AVCaptureTorchMode.Off
            } else {
                Mixpanel.sharedInstance().track("Flash off")
                trailingSpaceFlash.constant = 38;
                flashImage.image = UIImage(named: "flash-grey-off");
                flashWidthConstraint.constant = 15;
                flash.setTitle("Flash Off", forState: UIControlState.Normal)
                device.setTorchModeOnWithLevel(1.0, error: nil)
            }
            device.unlockForConfiguration()
        }
    }
    
    @IBAction func didTakePhoto(sender: AnyObject) {
        Mixpanel.sharedInstance().track("Picture taken")
        let videoConnection = stillImageOutput!.connectionWithMediaType(AVMediaTypeVideo)
        if videoConnection != nil {
            stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {(sampleBuffer, error) in
                if (sampleBuffer != nil) {
                    var imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    var dataProvider = CGDataProviderCreateWithCFData(imageData)
                    var cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, kCGRenderingIntentDefault)
                    
                    var image = UIImage(CGImage: cgImageRef, scale: 1.0, orientation: UIImageOrientation.Right)
                    self.capImg = image
                    FirstShoes.sharedInstance.setImage(image!)
                    FirstShoes.sharedInstance.saveImage()
                    var destVC : confirmPhotoViewController = self.storyboard?.instantiateViewControllerWithIdentifier("confirm_screen")! as! confirmPhotoViewController;
                    self.presentViewController(destVC, animated: true, completion: { () -> Void in
                    })
                    
                }
            })
        }
    }
    
    func focusTo(value : Float) {
        if let device = backCamera {
            if(device.lockForConfiguration(nil)) {
                device.setFocusModeLockedWithLensPosition(value, completionHandler: { (time) -> Void in
                    //
                })
                device.unlockForConfiguration()
            }
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill;
        previewLayer?.bounds = previewView.layer.bounds
        previewLayer!.position=CGPointMake(CGRectGetMidX(previewView.layer.bounds), CGRectGetMidY(previewView.layer.bounds));
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captureSession = AVCaptureSession()
        captureSession!.sessionPreset = AVCaptureSessionPresetPhoto
        Mixpanel.sharedInstance().track("Camera Preview")
        var err : NSError?
        var input = AVCaptureDeviceInput(device: backCamera, error: &err) ;
        if err == nil && captureSession!.canAddInput(input){
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput!.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
            if captureSession!.canAddOutput(stillImageOutput) {
                captureSession!.addOutput(stillImageOutput)
                captureSession!.addInput(input)
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
                NSLog(NSStringFromCGRect(previewView!.bounds));
                self.previewView.layer.addSublayer(previewLayer)
                captureSession!.sessionPreset = AVCaptureSessionPresetPhoto;
                
                NSLog(NSStringFromCGRect(previewLayer!.bounds));
                
                captureSession!.startRunning()
            }
        }
        self.previewView.clipsToBounds = true;

        topView.backgroundColor = UIColor (red: (237/255.0), green: (236/255.0), blue: (237/255.0), alpha: 1.0) ;
        topView.layer.borderWidth = 1
        topView.layer.borderColor = UIColor (red: (211/255.0), green: (211/255.0), blue: (211/255.0), alpha: 1.0).CGColor;
        
        capture.backgroundColor = UIColor (red: (255/255.0), green: (195/255.0), blue: (0/255.0), alpha: 1.0) ;
        capture.layer.borderColor = UIColor (red: (228/255.0), green: (226/255.0), blue: (227/255.0), alpha: 1.0).CGColor ;
        capture.layer.borderWidth = 4 ;
    }
}
