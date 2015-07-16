//
//  ReviewiPadScreenViewController.swift
//  First Shoe Experience
//
//  Created by Openly on 18/05/2015.
//  Copyright (c) 2015 Openly. All rights reserved.
//

import UIKit

class ReviewiPadScreenViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var childNamelbl: UILabel!
    @IBOutlet weak var childDOBlbl: UILabel!
    @IBOutlet weak var shoeSizelbl: UILabel!
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var yourNamelbl: UILabel!
    @IBOutlet weak var yourGenderlbl: UILabel!
    @IBOutlet weak var yourEmaillbl: UILabel!
    @IBOutlet weak var addressLine1lbl: UILabel!
    @IBOutlet weak var addressLine2lbl: UILabel!
    @IBOutlet weak var citylbl: UILabel!
    @IBOutlet weak var postcodeLbl: UILabel!
    var completeAlert = UIAlertView()
    var networkErrorAlert = UIAlertView()

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width:600, height:1080)
    }
    @IBAction func didClickChildEdit(sender: AnyObject) {
        Mixpanel.sharedInstance().track("Child details edit")
    }
    
    @IBAction func didClickParentsEdit(sender: AnyObject) {
        Mixpanel.sharedInstance().track("Parents details edit")
    }
    
    @IBAction func didClickEmailEdit(sender: AnyObject) {
        Mixpanel.sharedInstance().track("Email edit")
    }
    
    @IBAction func didClickAddressEdit(sender: AnyObject) {
        Mixpanel.sharedInstance().track("Address edit")
    }
    
    @IBAction func didClickOrder(sender: AnyObject) {
        let reachability: Reachability = Reachability.reachabilityForInternetConnection()
        let networkStatus: Int = reachability.currentReachabilityStatus.hashValue ;
        
        if networkStatus == 0 {
            
            self.networkErrorAlert.title = "No internet connection" ;
            self.networkErrorAlert.message = " You need to be connected to order a print" ;
            self.networkErrorAlert.addButtonWithTitle("OK");
            self.networkErrorAlert.show() ;
            
        }else{
            
            
            var overlay:UIView = UIHelper.showLoader(self.view);
            
            Mixpanel.sharedInstance().track("Print order initiated")
            
            orderButton.enabled = false;
            orderButton.alpha = 0.5;
            var dict:NSDictionary = [
                // The captured image
                "image": UIImageJPEGRepresentation( FirstShoes.sharedInstance.getImage(), 1.0).base64EncodedStringWithOptions(NSDataBase64EncodingOptions.allZeros),
                "child_name":FirstShoes.sharedInstance.getChildName(),
                "date_of_birth":FirstShoes.sharedInstance.getChildDOB(),
                "size_and_fitting":FirstShoes.sharedInstance.getChildShoeSizeAndFitting(),
                "child_gender":FirstShoes.sharedInstance.getChildGender(),
                "parent_first_name":FirstShoes.sharedInstance.yourFirstName,
                "parent_last_name":FirstShoes.sharedInstance.yourSurname,
                "parent_email":FirstShoes.sharedInstance.getYourEmail(),
                "parent_enable_promo":FirstShoes.sharedInstance.promo_code,
                "address_line_one":FirstShoes.sharedInstance.getAddressLine1(),
                "address_line_two":FirstShoes.sharedInstance.getAddressLine2(),
                "city":FirstShoes.sharedInstance.getCity(),
                "postal_code":FirstShoes.sharedInstance.getPostcode(),
                "personal_device":true,
            ];
            
            API.instance().post("upload-photo",
                params: dict as [NSObject : AnyObject],
                onComplete: { (data:[NSObject : AnyObject]!) -> Void in
                    overlay.removeFromSuperview();
                    println("This is the description :" + data.description);
                    
                    if(data.description == "[message: Photo uploaded successfully]"){
                        
                        Mixpanel.sharedInstance().track("Print order initiated")
                        
                        self.completeAlert.title = "Thank you for your Order"
                        self.completeAlert.message = "Your free print is being processed and a confirmation email will be sent to you with further details"
                        self.completeAlert.addButtonWithTitle("OK");
                        
                        self.completeAlert.show()
                        var destVC : First_Shoes_Experience.FinaliPadScreenViewController = self.storyboard?.instantiateViewControllerWithIdentifier("final_iPadScreen")! as! First_Shoes_Experience.FinaliPadScreenViewController;
                        self.presentViewController(destVC, animated: true, completion: { () -> Void in
                        })
                        
                    }
                    else{
                        Mixpanel.sharedInstance().track("Print order failed")
                        
                        self.completeAlert.title = "Oops somthing went wrong!!!"
                        self.completeAlert.message = "Try again"
                        self.completeAlert.addButtonWithTitle("Back to home screen");
                        self.completeAlert.show()
                        
                    }
            })
        }
    }

    func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int){
        if(buttonIndex == 0){
            var destVC : LiveviewFinderiPadViewController = self.storyboard?.instantiateViewControllerWithIdentifier("liveviewfinder_iPadScreen")! as! LiveviewFinderiPadViewController;
            self.presentViewController(destVC, animated: true, completion: { () -> Void in
            })
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orderButton.alpha = 1.0
        orderButton.enabled = true ;
        //completeAlert.delegate = self
        completeAlert.delegate = self
        refresh()
        self.view.addSubview(scrollView)
        scrollView.scrollEnabled = true
        scrollView.contentSize = CGSizeMake(600, 1080)
        scrollView.userInteractionEnabled = true
        scrollView.exclusiveTouch = true
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        orderButton.alpha = 1.0
        orderButton.enabled = true ;
        refresh()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.destinationViewController is personaliseViewController){
            var destVc: PersonaliseiPadViewController =  segue.destinationViewController as! PersonaliseiPadViewController;
            destVc.prevVC = self;
        }
        if(segue.destinationViewController is ParentsFormViewController){
            var destVc: YourDetailiPadViewController =  segue.destinationViewController as! YourDetailiPadViewController;
            destVc.prevVC = self;
        }
        if(segue.destinationViewController is AddressDetails2ViewController){
            var destVc: AddressDetails2iPadViewController =  segue.destinationViewController as! AddressDetails2iPadViewController;
            destVc.prevVC = self;
        }
    }
    
    func refresh (){
        if (FirstShoes.sharedInstance.childName == ""){
            childNamelbl.text = "Not mentioned"
            childNamelbl.textColor = UIColor (red: (182/255.0), green: (181/255.0), blue: (180/255.0), alpha: 1.0)
        }else{
            childNamelbl.text = FirstShoes.sharedInstance.getChildName()
            childNamelbl.textColor = UIColor (red: (54/255.0), green: (54/255.0), blue: (54/255.0), alpha: 1.0)
        }
        
        if (FirstShoes.sharedInstance.childDOB == ""){
            childDOBlbl.text = "Not mentioned"
            childDOBlbl.textColor = UIColor (red: (182/255.0), green: (181/255.0), blue: (180/255.0), alpha: 1.0)
        }else{
            childDOBlbl.text = FirstShoes.sharedInstance.getChildDOB()
            childDOBlbl.textColor = UIColor (red: (54/255.0), green: (54/255.0), blue: (54/255.0), alpha: 1.0)
        }
        
        if (FirstShoes.sharedInstance.childShoeSizeAndFitting == ""){
            shoeSizelbl.text = "Not mentioned"
            shoeSizelbl.textColor = UIColor (red: (182/255.0), green: (181/255.0), blue: (180/255.0), alpha: 1.0)
        }else{
            shoeSizelbl.text = FirstShoes.sharedInstance.getChildShoeSizeAndFitting()
            shoeSizelbl.textColor = UIColor (red: (54/255.0), green: (54/255.0), blue: (54/255.0), alpha: 1.0)
        }
        
        if (FirstShoes.sharedInstance.childGender == ""){
            genderLbl.text = "Not mentioned"
            genderLbl.textColor = UIColor (red: (182/255.0), green: (181/255.0), blue: (180/255.0), alpha: 1.0)
        }else{
            genderLbl.text = FirstShoes.sharedInstance.getChildGender()
            genderLbl.textColor = UIColor (red: (54/255.0), green: (54/255.0), blue: (54/255.0), alpha: 1.0)
        }
        
        yourNamelbl.text = FirstShoes.sharedInstance.yourFirstName + " " + FirstShoes.sharedInstance.yourSurname
        yourNamelbl.textColor = UIColor (red: (54/255.0), green: (54/255.0), blue: (54/255.0), alpha: 1.0)
        
        yourGenderlbl.text = FirstShoes.sharedInstance.getYourGender()
        yourGenderlbl.textColor = UIColor (red: (54/255.0), green: (54/255.0), blue: (54/255.0), alpha: 1.0)
        
        yourEmaillbl.text = FirstShoes.sharedInstance.getYourEmail()
        yourEmaillbl.textColor = UIColor (red: (54/255.0), green: (54/255.0), blue: (54/255.0), alpha: 1.0)
        
        addressLine1lbl.text = FirstShoes.sharedInstance.getAddressLine1()
        addressLine1lbl.textColor = UIColor (red: (54/255.0), green: (54/255.0), blue: (54/255.0), alpha: 1.0)
        
        if (FirstShoes.sharedInstance.addressLine2 == ""){
            addressLine2lbl.text = "Not mentioned"
            addressLine2lbl.textColor = UIColor (red: (182/255.0), green: (181/255.0), blue: (180/255.0), alpha: 1.0)
        }else{
            addressLine2lbl.text = FirstShoes.sharedInstance.getAddressLine2()
            addressLine2lbl.textColor = UIColor (red: (54/255.0), green: (54/255.0), blue: (54/255.0), alpha: 1.0)
        }
        
        citylbl.text = FirstShoes.sharedInstance.getCity()
        citylbl.textColor = UIColor (red: (54/255.0), green: (54/255.0), blue: (54/255.0), alpha: 1.0)
        
        postcodeLbl.text = FirstShoes.sharedInstance.getPostcode()
        postcodeLbl.textColor = UIColor (red: (54/255.0), green: (54/255.0), blue: (54/255.0), alpha: 1.0)
        
    }

    
}
