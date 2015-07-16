//
//  personaliseViewController.swift
//  FirstShoeExperience
//
//  Created by Openly on 01/04/2015.
//  Copyright (c) 2015 Openly. All rights reserved.
//

import UIKit
import QuartzCore

class personaliseViewController: UIViewController,UIPickerViewDelegate, UITextFieldDelegate{
    // Initialising all variables
    var prevVC: ReviewViewController?;
    var previousVC: MainHomeScreenViewController?;
    var size = ["1", "1 1/2", "2", "2 1/2", "3", "3 1/2", "4", "4 1/2", "5", "5 1/2", "6", "6 1/2","7","7 1/2"];
    var fitting = [" E"," F"," G"," H"] ;
    var pickerViewContents:[[String]] = [];
    
    // Initialising all IBOutlets
    @IBOutlet weak var pickerView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var boy: UIButton!
    @IBOutlet weak var girl: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var sizeAndFitting: UITextField!
    @IBOutlet var pickerBizCat: UIPickerView! = UIPickerView()
    
    
    // Implementing all IBActions
    @IBAction func shoeAndFitting(sizeAndFitting: UITextField) {
        
        pickerBizCat.showsSelectionIndicator = true
        dateField.resignFirstResponder()
        nameField.resignFirstResponder()
        dateField.layer.borderWidth = 0;
        textFieldShouldBeginEditing(sizeAndFitting) ;
    }
    
    @IBAction func quitPickerVIew(sender: AnyObject) {
        pickerBizCat.hidden = true
        pickerView.hidden = true
    }
    @IBAction func didSelectNamefeild(sender: UITextField) {
        nameField.layer.borderColor = UIColor  (red: (255/255.0), green: (196/255.0), blue: (0/255.0), alpha: 1.0).CGColor;
        nameField.layer.borderWidth = 1;
        sizeAndFitting.layer.borderWidth = 0;
        dateField.layer.borderWidth = 0 ;
        dateField.resignFirstResponder()
        sizeAndFitting.resignFirstResponder()
        
    }
    
    // functions related to UIPickerView
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int{
        return pickerViewContents.count
    }
    
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int{
        return pickerViewContents[component].count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!{
        return pickerViewContents[component][row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        sizeAndFitting.text = pickerViewContents[0][pickerBizCat.selectedRowInComponent(0)] + pickerViewContents[1][pickerBizCat.selectedRowInComponent(1)]
        //pickerBizCat.hidden = true;
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        sizeAndFitting.text = "1 E"
        sizeAndFitting.layer.borderColor = UIColor  (red: (255/255.0), green: (196/255.0), blue: (0/255.0), alpha: 1.0).CGColor;
        sizeAndFitting.layer.borderWidth = 1;
        nameField.layer.borderWidth = 0;
        dateField.layer.borderWidth = 0;
        nameField.resignFirstResponder()
        dateField.resignFirstResponder()
        pickerBizCat.backgroundColor = UIColor .whiteColor()
        pickerBizCat.hidden = false
        pickerView.hidden = false
        return false
    }
    
    @IBAction func dateField(sender: UITextField) {
        sizeAndFitting.layer.borderWidth = 0
        nameField.layer.borderWidth = 0
        nameField.resignFirstResponder()
        sizeAndFitting.resignFirstResponder()
        pickerBizCat.hidden = true
        pickerView.hidden = true
        
        dateField.layer.borderColor = UIColor  (red: (255/255.0), green: (196/255.0), blue: (0/255.0), alpha: 1.0).CGColor;
        dateField.layer.borderWidth = 1;
        
        
        let inputView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 202))
        inputView.backgroundColor = UIColor .whiteColor()
        
        let done = createDoneButton()
        
        inputView.addSubview(done) // add Button to UIView
        
        done.addTarget(self, action: "onDoneButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside) // set button click event

        
        var datePickerView  : UIDatePicker = UIDatePicker(frame: CGRectMake(0, 30, 0, 0))
        datePickerView.datePickerMode = UIDatePickerMode.Date
        datePickerView.backgroundColor = UIColor .whiteColor()
        inputView.addSubview(datePickerView) // add date picker to UIView
        sender.inputView = inputView
        datePickerView.maximumDate = NSDate()
        datePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
        
        handleDatePicker(datePickerView)
        
    }
    
    func createDoneButton()->UIButton{
        let done = UIButton(frame: CGRectMake((self.view.frame.size.width) - 60, 5, 60, 25))
        done.setTitle("Done", forState: UIControlState.Normal)
        done.setTitle("Done", forState: UIControlState.Highlighted)
        done.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        done.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        return done
    }
    
    func onDoneButtonPressed(sender:UIButton)
    {
        dateField.resignFirstResponder() // To resign the inputView on clicking done.
    }
    
    
    @IBAction func didClickBack(sender: AnyObject) {
        if (self.prevVC != nil){
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                
            });
        }
    }
    
    @IBAction func didClickBoy(sender: AnyObject) {
        pickerBizCat.hidden = true
        sizeAndFitting.layer.borderWidth = 0;
        FirstShoes.sharedInstance.ChildGender("Boy");
        girl.backgroundColor = UIColor .whiteColor()
        boy.backgroundColor = UIColor (red: (255/255.0), green: (196/255.0), blue: (0/255.0), alpha: 1.0)
    }
    @IBAction func didClickGirl(sender: AnyObject) {
        sizeAndFitting.layer.borderWidth = 0;
        pickerBizCat.hidden = true
        FirstShoes.sharedInstance.ChildGender("Girl");
        boy.backgroundColor = UIColor .whiteColor()
        girl.backgroundColor = UIColor (red: (255/255.0), green: (196/255.0), blue: (0/255.0), alpha: 1.0)
    }
    
    
    
    func handleDatePicker(sender: UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd yyyy"
        dateField.text = dateFormatter.stringFromDate(sender.date)
        var date = dateFormatter.dateFromString(dateField.text)
        FirstShoes.sharedInstance.ChildAge(FirstShoes.sharedInstance.getAge(date!));
    }
    
    
    
    func dismissKeyboard() {
        dateField.resignFirstResponder()
        sizeAndFitting.resignFirstResponder()
        nameField.resignFirstResponder()
        pickerBizCat.hidden = true
        nameField.layer.borderWidth = 0;
        dateField.layer.borderWidth = 0;
        pickerView.hidden = true
        sizeAndFitting.layer.borderWidth = 0;
    }
    
    func checkIfFieldsAreEmpty() -> Bool{
        if dateField != nil && nameField != nil && sizeAndFitting != nil {
            return false
        }
        else {
            return true
        }
    }
    
    @IBAction func doneButtonClicked(sender: AnyObject) {
        if checkIfFieldsAreEmpty() == true {
            doneButton.enabled = false
        }
        else {
            doneButton.enabled = true
            FirstShoes.sharedInstance.ChildName(nameField.text);
            FirstShoes.sharedInstance.ChildDOB(dateField.text);
            FirstShoes.sharedInstance.ChildShoeSizeAndFitting(sizeAndFitting.text)
            
            if(self.prevVC == nil && self.previousVC == nil){
                var destVC : MainHomeScreenViewController = self.storyboard?.instantiateViewControllerWithIdentifier("main_home_screen")! as! MainHomeScreenViewController;
                dateField.text = FirstShoes.sharedInstance.getChildDOB();
                self.presentViewController(destVC, animated: true, completion: { () -> Void in
                })
            }else{
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    
                });
                
            }
        }
        
    }
    
    override func viewDidLoad() {
        
        
        nameField.text = FirstShoes.sharedInstance.getChildName()
        dateField.text = FirstShoes.sharedInstance.getChildDOB()
        sizeAndFitting.text = FirstShoes.sharedInstance.getChildShoeSizeAndFitting()
        //nameField.delegate = self
        pickerView.hidden = true
        var tapGesture = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tapGesture)
        dateField.attributedPlaceholder = NSAttributedString(string:"mm/dd/yyyy",
            attributes:[NSForegroundColorAttributeName: UIColor .grayColor()])
        sizeAndFitting.attributedPlaceholder = NSAttributedString(string:"Shoe size and fitting",
            attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
        super.viewDidLoad()
        topView.layer.borderWidth = 1
        topView.layer.borderColor = UIColor (red: (211/255.0), green: (211/255.0), blue: (211/255.0), alpha: 1.0).CGColor;
        nameField.becomeFirstResponder()
        nameField.layer.borderColor = UIColor  (red: (255/255.0), green: (196/255.0), blue: (0/255.0), alpha: 1.0).CGColor;
        nameField.layer.borderWidth = 1;
        dateField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0);
        nameField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0);
        sizeAndFitting.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0);
        pickerViewContents = [size,fitting];
        sizeAndFitting.delegate = self
        pickerBizCat.delegate = self
        pickerBizCat.hidden = true;
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        nameField.tintColor =  UIColor(red: (255/255.0), green: (196/255.0), blue: (0/255.0), alpha: 1.0)
        dateField.tintColor =  UIColor(red: (255/255.0), green: (196/255.0), blue: (0/255.0), alpha: 1.0)
        sizeAndFitting.tintColor =  UIColor(red: (255/255.0), green: (196/255.0), blue: (0/255.0), alpha: 1.0)
        animateViewMoving(true, moveValue: 100)
    }
    func textFieldDidEndEditing(textField: UITextField) {
        textField.layer.borderWidth = 0;
        animateViewMoving(false, moveValue: 100)
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
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true);
        nameField.resignFirstResponder()
        return false;
    }
    
}
