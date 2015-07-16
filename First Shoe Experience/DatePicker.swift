//
//  DatePicker.swift
//  First Shoe Experience
//
//  Created by Openly on 20/05/2015.
//  Copyright (c) 2015 Openly. All rights reserved.
//

import Foundation
import UIKit

class DatePicker{
    static let datePicker = DatePicker()
    
    let inputView = UIView(frame: CGRectMake(0, 0,, 202))
    
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
        inputView!.hidden = true // To resign the inputView on clicking done.
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd yyyy"
        dateField.text = dateFormatter.stringFromDate(sender.date)
        var date = dateFormatter.dateFromString(dateField.text)
        FirstShoes.sharedInstance.ChildAge(FirstShoes.sharedInstance.getAge(date!));
    }
    
    func getDatePickerView(inputView: UIView)-> UIView{
        inputView.backgroundColor = UIColor .whiteColor()
        let done = createDoneButton()
        inputView.addSubview(done) // add Button to UIView
        done.addTarget(self, action: "onDoneButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside) // set button click event
        var datePickerView  : UIDatePicker = UIDatePicker(frame: CGRectMake(0, 30, 0, 0))
        datePickerView.datePickerMode = UIDatePickerMode.Date
        datePickerView.backgroundColor = UIColor .whiteColor()
        inputView.addSubview(datePickerView) // add date picker to UIView
        datePickerView.maximumDate = NSDate()
        datePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
        
        handleDatePicker(datePickerView)
        
        return inputView
    }
}