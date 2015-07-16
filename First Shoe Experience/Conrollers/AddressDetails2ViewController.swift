//
//  AddressDetails2ViewController.swift
//  FirstShoeExperience
//
//  Created by Openly on 13/04/2015.
//  Copyright (c) 2015 Openly. All rights reserved.
//

import UIKit
import QuartzCore

class AddressDetails2ViewController: UIViewController, UITextFieldDelegate {

    var prevVC: ReviewViewController?;
    @IBOutlet weak var firstLineField: UITextField!
    @IBOutlet weak var secondLineField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var postcodeField: UITextField!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    // var firstShoes = FirstShoes.sharedInstance
    
    func dismissKeyboard() {
        firstLineField.resignFirstResponder()
        secondLineField.resignFirstResponder()
        cityField.resignFirstResponder()
        postcodeField.resignFirstResponder()
    }
    
    @IBAction func didClickBack(sender: AnyObject) {
        if (self.prevVC != nil){
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                
            });
        }
    }

    @IBAction func didClickNext(sender: AnyObject) {
        FirstShoes.sharedInstance.AddressLine1(firstLineField.text)
        FirstShoes.sharedInstance.AddressLine2(secondLineField.text)
        FirstShoes.sharedInstance.City(cityField.text)
        FirstShoes.sharedInstance.setPostCode(postcodeField.text)
        if(self.prevVC == nil){
            var destVC : ReviewViewController = self.storyboard?.instantiateViewControllerWithIdentifier("review_screen")! as! ReviewViewController;
            //destVC.firstShoes = FirstShoes.sharedInstance
            self.presentViewController(destVC, animated: true, completion: { () -> Void in
            })
        }else
        {
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                
            });
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        firstLineField.text = FirstShoes.sharedInstance.getAddressLine1()
        secondLineField.text = FirstShoes.sharedInstance.getAddressLine2()
        cityField.text = FirstShoes.sharedInstance.getCity()
        postcodeField.text = FirstShoes.sharedInstance.getPostcode()
        if (checkIfTextfieldsEmpty() == false){
            nextButton.enabled = false
            nextButton.backgroundColor = UIColor  (red: (164/255.0), green: (162/255.0), blue: (161/255.0), alpha: 1.0);
           
        }else{
            nextButton.enabled = true
             nextButton.backgroundColor = UIColor  (red: (255/255.0), green: (196/255.0), blue: (0/255.0), alpha: 1.0);
        }
        
        
        var tapGesture = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tapGesture)
        topView.layer.borderWidth = 1
        topView.layer.borderColor = UIColor (red: (211/255.0), green: (211/255.0), blue: (211/255.0), alpha: 1.0).CGColor;
        firstLineField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0);
        secondLineField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0);
        cityField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0);
        postcodeField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0);
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        UITextField.appearance().tintColor = UIColor(red: (255/255.0), green: (196/255.0), blue: (0/255.0), alpha: 1.0)
        textField.layer.borderColor = UIColor  (red: (255/255.0), green: (196/255.0), blue: (0/255.0), alpha: 1.0).CGColor;
        textField.layer.borderWidth = 1;
        animateViewMoving(true, moveValue: 70)
       // self.view.contentMode = CGPointMake(0, textField.frame.origin.y);
    }
    
    func checkIfTextfieldsEmpty() -> Bool{
        if(firstLineField.text == "" || cityField.text == "" || postcodeField.text == ""){
            return false ;
        }
        else{
            return true;
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.layer.borderWidth = 0;
        animateViewMoving(false, moveValue: 70)
        
        if (checkIfTextfieldsEmpty() == true) {
            nextButton.enabled = true;
            nextButton.backgroundColor = UIColor  (red: (255/255.0), green: (196/255.0), blue: (0/255.0), alpha: 1.0);
        }else{
            nextButton.enabled = false;
            nextButton.backgroundColor = UIColor  (red: (164/255.0), green: (162/255.0), blue: (161/255.0), alpha: 1.0);
        }
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        var movementDuration:NSTimeInterval = 0.3
        var movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }

       override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
