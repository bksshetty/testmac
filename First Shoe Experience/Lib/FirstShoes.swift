//
//  FirstShoes.swift
//  FirstShoeExperience
//
//  Created by Openly on 08/04/2015.
//  Copyright (c) 2015 Openly. All rights reserved.
//

import Foundation
import UIKit

class FirstShoes {
    
    // Initialise all parameters
    static let sharedInstance = FirstShoes()
    var childName = "" ;
    var childDOB  = "" ;
    var childAge = "" ;
    var childShoeSizeAndFitting = "" ;
    var childGender = "" ;
    var yourFirstName = "" ;
    var yourGender = "" ;
    var yourEmail = "" ;
    var addressLine1 = "" ;
    var addressLine2 = "" ;
    var city = "" ;
    var postcode = "" ;
    var imageTaken = UIImage() ;
    var imagePath = "" ;
    var yourSurname = "" ;
    var imageWithBorder = UIImage();
    var promo_code = true ;
    
    // Getters...
    func getImage() ->UIImage{
        return imageTaken ;
    }
    func getAbsoluteImagePath(path: String) -> String{
        let documentsUrl = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first as! NSURL
        let fileAbsoluteUrl = documentsUrl.URLByAppendingPathComponent(path).absoluteURL
        var absolutePath = fileAbsoluteUrl?.absoluteString
        return absolutePath!
    }
    func getImagePath()->String {
        return imagePath ;
    }
    func getChildName()->String {
        return childName;
    }
    func getChildDOB() ->String{
        return childDOB ;
    }
    func getChildGender() ->String{
        return childGender ;
    }
    func getChildShoeSizeAndFitting() ->String{
        return childShoeSizeAndFitting ;
    }
    func getChildAge() -> String{
        return childAge ;
    }
    func getYourName() ->String{
        return yourFirstName ;
    }
    
    func getSurame() ->String{
        return yourSurname ;
    }
    func getYourEmail() ->String{
        return yourEmail ;
    }
    func getYourGender() ->String{
        return yourGender ;
    }
    func getAddressLine1() ->String{
        return addressLine1 ;
    }
    func getAddressLine2() ->String{
        return addressLine2 ;
    }
    func getCity() ->String{
        return city ;
    }
    func getPostcode() ->String{
        return postcode ;
    }

    // Setters..
    
    func setImage(image : UIImage){
        imageTaken = image;
    }
    
    func ImagePath(path : String){
        imagePath = path ;
    }
    func ChildName(name : String){
        childName = name ;
    }
    func ChildDOB(DOB : String){
        childDOB = DOB ;
    }
    func ChildGender(gender : String){
        childGender = gender ;
    }
    func ChildShoeSizeAndFitting(shoeSize : String){
        childShoeSizeAndFitting = shoeSize ;
    }
    func ChildAge(age : String){
        childAge = age ;
    }
    func YourName(name : String){
        yourFirstName = name ;
    }
    func YourSurname(name : String){
        yourSurname = name ;
    }
    func YourEmail(email : String){
        yourEmail = email ;
    }
    func YourGender(gender : String){
        yourGender = gender ;
    }
    func AddressLine1(line1 : String){
        addressLine1 = line1 ;
    }
    func AddressLine2(line2 : String){
        addressLine2 = line2;
    }
    func City(cityName : String){
        city = cityName ;
    }
    func setPostCode(code : String){
        postcode = code ;
    }
    func save(){
        
    }
    func load(){
        
    }
    func saveImage() -> Bool{
        let imagePicker = UIImagePickerController()
        
        let documentsFolderPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]as! String
        let docPath = documentsFolderPath.stringByAppendingPathComponent("firstShoe")
        
        let jpgImageData = UIImageJPEGRepresentation(imageTaken, 1.0)
        let result = jpgImageData.writeToFile(docPath, atomically: true)
        return result
    }
    
    func loadImage() -> UIImage{
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentDirectory = paths[0]as! String
        let myFilePath = documentDirectory.stringByAppendingPathComponent("firstShoe")
        var image = UIImage()
        let manager = NSFileManager.defaultManager()
        if (manager.fileExistsAtPath(myFilePath)) {
            image = UIImage(contentsOfFile: myFilePath)!
        }
        return image;
    }
    
    func getAge(selectedDate :NSDate) -> String{
        var calendar : NSCalendar = NSCalendar.currentCalendar()
        let ageComponents = calendar.components(.CalendarUnitYear | .CalendarUnitMonth,
            fromDate: selectedDate,
            toDate: NSDate(),
            options: nil)
        let age = ageComponents.year
        let months = ageComponents.month
        
        return "\(age) years \(months) months"
    }
    
    
}


