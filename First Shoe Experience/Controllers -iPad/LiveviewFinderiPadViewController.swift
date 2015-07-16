//
//  LiveviewFinderiPadViewController.swift
//  First Shoe Experience
//
//  Created by Openly on 18/05/2015.
//  Copyright (c) 2015 Openly. All rights reserved.
//

import UIKit
import AVFoundation


class LiveviewFinderiPadViewController: UIViewController {

    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var flashImage: UIImageView!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var cameraButton: UIButton!
    
    var captureSession : AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var previewLayer : AVCaptureVideoPreviewLayer?
    var capImg: UIImage?
    var backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo);
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    
    
    @IBAction func onFlashClick(sender: AnyObject) {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        if (device.hasTorch) {
            device.lockForConfiguration(nil)
            if (device.torchMode == AVCaptureTorchMode.On) {
                Mixpanel.sharedInstance().track("Flash on")
                flashButton.setTitle("Flash On", forState: UIControlState.Normal)
                flashImage.image = UIImage(named: "flash-grey-on");
                device.torchMode = AVCaptureTorchMode.Off
            } else {
                Mixpanel.sharedInstance().track("Flash off")
                flashImage.image = UIImage(named: "flash-grey-off");
                flashButton.setTitle("Flash Off", forState: UIControlState.Normal)
                device.setTorchModeOnWithLevel(1.0, error: nil)
            }
            device.unlockForConfiguration()
        }
    }
    
    @IBAction func didTakePhoto(sender: AnyObject) {
        cameraButton.enabled = false
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
                    var destVC : ConfirmiPadViewController = self.storyboard?.instantiateViewControllerWithIdentifier("confirm_iPadScreen")! as! ConfirmiPadViewController;
                    self.presentViewController(destVC, animated: true, completion: { () -> Void in
                    })
                    
                }
            })
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill;
        previewLayer?.bounds = previewView.layer.bounds
        previewLayer!.position=CGPointMake(CGRectGetMidX(previewView.layer.bounds), CGRectGetMidY(previewView.layer.bounds));
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Mixpanel.sharedInstance().track("Camera Preview")
        cameraButton.enabled = true
        captureSession = AVCaptureSession()
        captureSession!.sessionPreset = AVCaptureSessionPresetPhoto
        cameraButton.layer.borderColor = UIColor (red: (228/255.0), green: (226/255.0), blue: (227/255.0), alpha: 1.0).CGColor ;
        cameraButton.layer.borderWidth = 4 ;
        
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
    }
}
