//
//  ParentsFormViewController.swift
//  FirstShoeExperience
//
//  Created by Openly on 13/04/2015.
//  Copyright (c) 2015 Openly. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
class ParentsFormViewController: UIViewController, UITextFieldDelegate {
    
    var prevVC: ReviewViewController?;
    
    @IBOutlet weak var yourName: UITextField!
    @IBOutlet weak var yourSurname: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var checkboxButton: UIButton!
    var isChecked = true ;
    
    let checkedImage = UIImage(named: "black-tick")
    let unCheckedImage = UIImage(named: "unchecked_checkbox@2x")
    
    
    @IBAction func didClickMale(sender: AnyObject) {
        FirstShoes.sharedInstance.YourGender("Male")
        femaleButton.backgroundColor = UIColor .whiteColor()
        maleButton.backgroundColor = UIColor (red: (255/255.0), green: (196/255.0), blue: (0/255.0), alpha: 1.0)

    }
    @IBAction func didClickFemale(sender: AnyObject) {
        FirstShoes.sharedInstance.YourGender("Female")
        maleButton.backgroundColor = UIColor .whiteColor()
        femaleButton.backgroundColor = UIColor (red: (255/255.0), green: (196/255.0), blue: (0/255.0), alpha: 1.0)

    }
    
    @IBAction func didClickCheckbox(sender: AnyObject) {
        isChecked = !isChecked ;
        if(isChecked){
            FirstShoes.sharedInstance.promo_code = true ;
            checkboxButton.setBackgroundImage(checkedImage, forState: UIControlState.Normal) ;
            checkboxButton.setBackgroundImage(checkedImage, forState: UIControlState.Highlighted) ;
            checkboxButton.layer.borderColor = UIColor  (red: (255/255.0), green: (196/255.0), blue: (0/255.0), alpha: 1.0).CGColor;
            checkboxButton.layer.borderWidth = 1 ;
        }else{
            FirstShoes.sharedInstance.promo_code = false ;
            checkboxButton.setBackgroundImage(unCheckedImage, forState: UIControlState.Normal) ;
            checkboxButton.layer.borderWidth = 0 ;
        }
    }
    
    @IBAction func didClickNext(sender: AnyObject) {
        
        FirstShoes.sharedInstance.YourName(yourName.text)
        FirstShoes.sharedInstance.YourSurname(yourSurname.text)
        FirstShoes.sharedInstance.YourEmail(emailField.text)
//        let cb =  Checkbox();
//        FirstShoes.sharedInstance.promo_code = cb.isChecked ;
        if(self.prevVC == nil){
            var destVC : AddressDetails2ViewController = self.storyboard?.instantiateViewControllerWithIdentifier("address_screen")! as! AddressDetails2ViewController;
            //destVC.firstShoes = FirstShoes.sharedInstance
            self.presentViewController(destVC, animated: true, completion: { () -> Void in
            })
        }else{
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
            });
            
        }
    }
    
    @IBAction func didClickBack(sender: AnyObject) {
        if (self.prevVC != nil){
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
            });
        }
    }
    func dismissKeyboard() {
        yourName.resignFirstResponder()
        yourSurname.resignFirstResponder()
        emailField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isChecked = false ;
        yourName.text = FirstShoes.sharedInstance.getYourName()
        yourSurname.text = FirstShoes.sharedInstance.getSurame()
        emailField.text = FirstShoes.sharedInstance.getYourEmail()
        
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
        yourName.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0);
        yourSurname.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0);
        emailField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0);
    }
    
    @IBAction func checkValidEmail(sender: AnyObject) {
        if(isValidEmail(emailField.text) != true){
           var errorAlert = UIAlertView()
            errorAlert.title = "This is not a valid email address format"
            errorAlert.message = "Please enter a valid email address"
            emailField.layer.borderColor = UIColor .redColor().CGColor
            emailField.layer.borderWidth = 1;
    
            errorAlert.addButtonWithTitle("OK");
            errorAlert.delegate = self
            errorAlert.show()
            nextButton.enabled = false
            nextButton.backgroundColor = UIColor  (red: (164/255.0), green: (162/255.0), blue: (161/255.0), alpha: 1.0);
        }
    }
    
    // validating the email field 
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let range = testStr.rangeOfString(emailRegEx, options:.RegularExpressionSearch)
        let result = range != nil ? true : false
        return result
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        UITextField.appearance().tintColor = UIColor(red: (255/255.0), green: (196/255.0), blue: (0/255.0), alpha: 1.0)
        textField.layer.borderColor = UIColor  (red: (255/255.0), green: (196/255.0), blue: (0/255.0), alpha: 1.0).CGColor;
        textField.layer.borderWidth = 1;
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if (checkIfTextfieldsEmpty() == true) {
            nextButton.enabled = true;
            nextButton.backgroundColor = UIColor  (red: (255/255.0), green: (196/255.0), blue: (0/255.0), alpha: 1.0);
        }else{
            nextButton.enabled = false;
            nextButton.backgroundColor = UIColor  (red: (164/255.0), green: (162/255.0), blue: (161/255.0), alpha: 1.0);
        }
        textField.layer.borderWidth = 0;
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func checkIfTextfieldsEmpty() -> Bool{
        if(yourName.text == "" || yourSurname.text == "" || isValidEmail(emailField.text) != true){
            return false ;
        }
        else{
            return true;
        }
    }
}
