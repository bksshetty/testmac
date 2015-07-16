//
//  PersonaliseiPadViewController.swift
//  First Shoe Experience
//
//  Created by Openly on 18/05/2015.
//  Copyright (c) 2015 Openly. All rights reserved.
//

import UIKit

class PersonaliseiPadViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate {
    var prevVC: ReviewiPadScreenViewController?;
    var previousVC: MainHomeiPadScreenViewController?;
    var size = ["1", "1 1/2", "2", "2 1/2", "3", "3 1/2", "4", "4 1/2", "5", "5 1/2", "6", "6 1/2","7","7 1/2"];
    var fitting = [" E"," F"," G"," H"] ;
    var pickerViewContents:[[String]] = [];

    
    @IBOutlet weak var pickerView: UIView!
    @IBOutlet weak var boyButton: UIButton!
    @IBOutlet weak var girlButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var sizeAndFittingField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var pickerBizCat: UIPickerView!
    
    @IBAction func didClickGirl(sender: AnyObject) {
        FirstShoes.sharedInstance.ChildGender("Girl");
        boyButton.backgroundColor = UIColor .whiteColor()
        girlButton.backgroundColor = UIColor (red: (255/255.0), green: (196/255.0), blue: (0/255.0), alpha: 1.0)
    }
    
    @IBAction func didClickBoy(sender: AnyObject) {
        FirstShoes.sharedInstance.ChildGender("Boy");
        girlButton.backgroundColor = UIColor .whiteColor()
        boyButton.backgroundColor = UIColor (red: (255/255.0), green: (196/255.0), blue: (0/255.0), alpha: 1.0)
        
    }
    
    @IBAction func doneButtonClicked(sender: AnyObject) {
        FirstShoes.sharedInstance.ChildName(nameField.text);
        FirstShoes.sharedInstance.ChildDOB(dateField.text);
        FirstShoes.sharedInstance.ChildShoeSizeAndFitting(sizeAndFittingField.text)
            
        if(self.prevVC == nil && self.previousVC == nil){
            var destVC : MainHomeiPadScreenViewController = self.storyboard?.instantiateViewControllerWithIdentifier("main_home_iPad_screen")! as! MainHomeiPadScreenViewController;
            dateField.text = FirstShoes.sharedInstance.getChildDOB();
            self.presentViewController(destVC, animated: true, completion: { () -> Void in
            })
        }else{
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                
            });
        }
        
    }

    @IBAction func didSelectNameField(sender: AnyObject) {
        nameField.layer.borderColor = UIColor  (red: (255/255.0), green: (196/255.0), blue: (0/255.0), alpha: 1.0).CGColor;
        nameField.layer.borderWidth = 1;
        sizeAndFittingField.layer.borderWidth = 0;
        dateField.layer.borderWidth = 0 ;
        dateField.resignFirstResponder()
        sizeAndFittingField.resignFirstResponder()
    }
    
    @IBAction func didSelectSizeandFitting(sender: AnyObject) {
        pickerBizCat.showsSelectionIndicator = true
        dateField.resignFirstResponder()
        nameField.resignFirstResponder()
        dateField.layer.borderWidth = 0;
        textFieldShouldBeginEditing(sizeAndFittingField) ;
        
    }
    
    
    @IBAction func quitPickerView(sender: AnyObject) {
        pickerBizCat.hidden = true
        pickerView.hidden = true
        sizeAndFittingField.layer.borderWidth = 0;
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
        sizeAndFittingField.text = pickerViewContents[0][pickerBizCat.selectedRowInComponent(0)] + pickerViewContents[1][pickerBizCat.selectedRowInComponent(1)]
        //pickerBizCat.hidden = true;
    }

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        sizeAndFittingField.text = "1 E"
        sizeAndFittingField.layer.borderColor = UIColor  (red: (255/255.0), green: (196/255.0), blue: (0/255.0), alpha: 1.0).CGColor;
        sizeAndFittingField.layer.borderWidth = 1;
        nameField.layer.borderWidth = 0;
        dateField.layer.borderWidth = 0;
        nameField.resignFirstResponder()
        dateField.resignFirstResponder()
        pickerBizCat.backgroundColor = UIColor .whiteColor()
        pickerBizCat.hidden = false
        pickerView.hidden = false
        return false
    }
    
    @IBAction func didSelectDateField(sender: UITextField) {
        sizeAndFittingField.layer.borderWidth = 0
        nameField.layer.borderWidth = 0
        nameField.resignFirstResponder()
        sizeAndFittingField.resignFirstResponder()
        dateField.layer.borderColor = UIColor  (red: (255/255.0), green: (196/255.0), blue: (0/255.0), alpha: 1.0).CGColor;
        dateField.layer.borderWidth = 1;
        pickerBizCat.hidden = true
        pickerView.hidden = true

        
        let inputView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 290))
        inputView.backgroundColor = UIColor .whiteColor()
        
        let done = createDoneButton()
        
        inputView.addSubview(done) // add Button to UIView
        
        done.addTarget(self, action: "onDoneButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside) // set button click event
        
        
        var datePickerView  : UIDatePicker = UIDatePicker(frame: CGRectMake(0, 50, self.view.frame.width, 250))
        datePickerView.datePickerMode = UIDatePickerMode.Date
        datePickerView.backgroundColor = UIColor .whiteColor()
        inputView.addSubview(datePickerView) // add date picker to UIView
        sender.inputView = inputView
        datePickerView.maximumDate = NSDate()
        datePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
        
        handleDatePicker(datePickerView)
    }
    
    func createDoneButton()->UIButton{
        let done = UIButton(frame: CGRectMake((self.view.frame.size.width) - 60, 5, 60, 30))
        done.setTitle("Done", forState: UIControlState.Normal)
        done.setTitle("Done", forState: UIControlState.Highlighted)
        done.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        done.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        return done
    }
    
    func onDoneButtonPressed(sender:UIButton)
    {
        dateField.resignFirstResponder() // To resign the inputView on clicking done.
        dateField.layer.borderWidth = 0
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
        sizeAndFittingField.resignFirstResponder()
        nameField.resignFirstResponder()
        nameField.layer.borderWidth = 0;
        dateField.layer.borderWidth = 0;
        pickerView.hidden = true
        sizeAndFittingField.layer.borderWidth = 0;
    }
    
    func checkIfFieldsAreEmpty() -> Bool{
        if dateField != nil && nameField != nil && sizeAndFittingField != nil {
            return false
        }
        else {
            return true
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        var tapGesture = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tapGesture)
        pickerView.hidden = true
        nameField.text = FirstShoes.sharedInstance.getChildName()
        dateField.text = FirstShoes.sharedInstance.getChildDOB()
        sizeAndFittingField.text = FirstShoes.sharedInstance.getChildShoeSizeAndFitting()
        if (FirstShoes.sharedInstance.getChildGender() == "Boy"){
            FirstShoes.sharedInstance.ChildGender("Boy");
            girlButton.backgroundColor = UIColor .whiteColor()
            boyButton.backgroundColor = UIColor (red: (255/255.0), green: (196/255.0), blue: (0/255.0), alpha: 1.0)
        }else if (FirstShoes.sharedInstance.getChildGender() == "Girl"){
            FirstShoes.sharedInstance.ChildGender("Girl");
            boyButton.backgroundColor = UIColor .whiteColor()
            girlButton.backgroundColor = UIColor (red: (255/255.0), green: (196/255.0), blue: (0/255.0), alpha: 1.0)
        }else{
            boyButton.backgroundColor = UIColor .whiteColor()
            girlButton.backgroundColor = UIColor .whiteColor()
        }
        nameField.becomeFirstResponder()
        nameField.layer.borderColor = UIColor  (red: (255/255.0), green: (196/255.0), blue: (0/255.0), alpha: 1.0).CGColor;
        nameField.layer.borderWidth = 1;
        dateField.layer.sublayerTransform = CATransform3DMakeTranslation(18, 0, 0);
        nameField.layer.sublayerTransform = CATransform3DMakeTranslation(18, 0, 0);
        sizeAndFittingField.layer.sublayerTransform = CATransform3DMakeTranslation(18, 0, 0);
        pickerViewContents = [size,fitting];
        sizeAndFittingField.delegate = self
        pickerBizCat.delegate = self
        pickerBizCat.hidden = true;
    }
}
