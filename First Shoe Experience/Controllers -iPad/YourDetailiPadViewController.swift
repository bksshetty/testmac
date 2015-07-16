//
//  YourDetailiPadViewController.swift
//  First Shoe Experience
//
//  Created by Openly on 20/05/2015.
//  Copyright (c) 2015 Openly. All rights reserved.
//

import UIKit

class YourDetailiPadViewController: UIViewController, UITextFieldDelegate {

    var prevVC: ReviewiPadScreenViewController?;
    @IBOutlet weak var yourName: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var yourSurname: UITextField!
    @IBOutlet weak var checkbox: UIButton!
    @IBOutlet weak var male: UIButton!
    @IBOutlet weak var female: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    var isChecked = true ;
    
    let checkedImage = UIImage(named: "black-tick")
    let unCheckedImage = UIImage(named: "unchecked_checkbox@2x")

    
    @IBAction func didClickBoy(sender: AnyObject) {
        FirstShoes.sharedInstance.YourGender("Male")
        female.backgroundColor = UIColor .whiteColor()
        male.backgroundColor = UIColor (red: (255/255.0), green: (196/255.0), blue: (0/255.0), alpha: 1.0)
    }
    
    @IBAction func didClickGirl(sender: AnyObject) {
        FirstShoes.sharedInstance.YourGender("Female")
        male.backgroundColor = UIColor .whiteColor()
        female.backgroundColor = UIColor (red: (255/255.0), green: (196/255.0), blue: (0/255.0), alpha: 1.0)
    }
    
    @IBAction func didClickCheckbox(sender: AnyObject) {
        isChecked = !isChecked ;
        if(isChecked){
            FirstShoes.sharedInstance.promo_code = true ;
            checkbox.setBackgroundImage(checkedImage, forState: UIControlState.Normal) ;
            checkbox.setBackgroundImage(checkedImage, forState: UIControlState.Highlighted) ;
            checkbox.layer.borderColor = UIColor  (red: (255/255.0), green: (196/255.0), blue: (0/255.0), alpha: 1.0).CGColor;
            checkbox.layer.borderWidth = 1 ;
        }else{
            FirstShoes.sharedInstance.promo_code = false ;
            checkbox.setBackgroundImage(unCheckedImage, forState: UIControlState.Normal) ;
            checkbox.layer.borderWidth = 0 ;
        }
    }
    
    @IBAction func didClickNext(sender: AnyObject) {
        FirstShoes.sharedInstance.YourName(yourName.text)
        FirstShoes.sharedInstance.YourSurname(yourSurname.text)
        FirstShoes.sharedInstance.YourEmail(emailField.text)
        
        if(self.prevVC == nil){
            var destVC : AddressDetails2iPadViewController = self.storyboard?.instantiateViewControllerWithIdentifier("address_iPadScreen")! as! AddressDetails2iPadViewController;
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
    
    @IBAction func didClickEmailField(sender: AnyObject) {
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
    
    func dismissKeyboard() {
        yourName.resignFirstResponder()
        yourSurname.resignFirstResponder()
        emailField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isChecked = false ;
        
        
        
        if (FirstShoes.sharedInstance.getYourGender() == "Male"){
            FirstShoes.sharedInstance.YourGender("Male")
            female.backgroundColor = UIColor .whiteColor()
            male.backgroundColor = UIColor (red: (255/255.0), green: (196/255.0), blue: (0/255.0), alpha: 1.0)
        }else if (FirstShoes.sharedInstance.getYourGender() == "Female"){
            FirstShoes.sharedInstance.YourGender("Female")
            male.backgroundColor = UIColor .whiteColor()
            female.backgroundColor = UIColor (red: (255/255.0), green: (196/255.0), blue: (0/255.0), alpha: 1.0)
        }else{
            male.backgroundColor = UIColor .whiteColor()
            female.backgroundColor = UIColor .whiteColor()
        }
        yourName.text = FirstShoes.sharedInstance.getYourName()
        yourSurname.text = FirstShoes.sharedInstance.getSurame()
        emailField.text = FirstShoes.sharedInstance.getYourEmail()
        var tapGesture = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tapGesture)
        
        if (checkIfTextfieldsEmpty() == false){
            nextButton.enabled = false
            nextButton.backgroundColor = UIColor  (red: (164/255.0), green: (162/255.0), blue: (161/255.0), alpha: 1.0);
            
        }else{
            nextButton.enabled = true
            nextButton.backgroundColor = UIColor  (red: (255/255.0), green: (196/255.0), blue: (0/255.0), alpha: 1.0);
        }
        
        yourName.layer.sublayerTransform = CATransform3DMakeTranslation(18, 0, 0);
        yourSurname.layer.sublayerTransform = CATransform3DMakeTranslation(18, 0, 0);
        emailField.layer.sublayerTransform = CATransform3DMakeTranslation(18, 0, 0);

    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
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
    
    // validating the email field
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let range = testStr.rangeOfString(emailRegEx, options:.RegularExpressionSearch)
        let result = range != nil ? true : false
        return result
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
