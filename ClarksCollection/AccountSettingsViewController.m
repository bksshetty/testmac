//
//  AccountSettingsViewController.m
//  ClarksCollection
//
//  Created by Openly on 28/07/2015.
//  Copyright (c) 2015 Clarks. All rights reserved.
//

#import "AccountSettingsViewController.h"
#import "ClarksColors.h"
#import "ClarksUI.h"
#import "API.h"
#import "Reachability.h"
#import "MixPanelUtil.h"
#import "AppDelegate.h"


@interface AccountSettingsViewController ()

@end

@implementation AccountSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *spacerView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.firstNameField setLeftViewMode:UITextFieldViewModeAlways];
    [self.firstNameField setLeftView:spacerView1];
    
    UIView *spacerView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.lastNameField setLeftViewMode:UITextFieldViewModeAlways];
    [self.lastNameField setLeftView:spacerView2];
    
    UIView *spacerView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.emailField setLeftViewMode:UITextFieldViewModeAlways];
    [self.emailField setLeftView:spacerView3];
    
    UIView *spacerView5 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.passwordFiled setLeftViewMode:UITextFieldViewModeAlways];
    [self.passwordFiled setLeftView:spacerView5];
    
    UIView *spacerView6 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.updatePassField setLeftViewMode:UITextFieldViewModeAlways];
    [self.updatePassField setLeftView:spacerView6];
    
    UIView *spacerView7 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.currentPassField setLeftViewMode:UITextFieldViewModeAlways];
    [self.currentPassField setLeftView:spacerView7];
    
    [self.firstNameField setEnabled:YES];
    [self.lastNameField setEnabled:YES];
    [self.emailField setEnabled:YES];
    [self.passwordFiled setEnabled:NO];
    
    self.currentPassField.hidden = YES;
    self.updatePassField.hidden = YES ;
    self.updatePassLbl.hidden = YES ;
    self.forgotBtn.hidden = YES ;
    
    self.currentPassField.delegate = self ;
    self.updatePassField.delegate = self ;
    self.passwordFiled.delegate = self ;
    self.emailField.delegate = self ;
    self.firstNameField.delegate = self ;
    self.lastNameField.delegate = self ;
    
    self.saveBtn.enabled = NO ;
    self.saveBtn.backgroundColor = [ClarksColors clarksMediumGrey];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    if([appDelegate.verificationStatus isEqualToString:@"BLOCKED"]){
        self.backButton.hidden = YES ;
        
    }else{
        self.backButton.hidden = NO ;
    }
    
    CGRect f = self.changeBtn.frame;
    [ClarksUI reposition:self.saveBtn x:f.origin.x y:450];
    
    [[MixPanelUtil instance] track:@"accountSetting"];
    
    UIView *loader = [ClarksUI showLoader:self.view];
    [[API instance] get:@"app-user/get-active-user" onComplete:^(NSDictionary *results) {
        [loader removeFromSuperview];
        if(results == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                      message:@"No network connectivity or server down"
                                                      delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alert show];
            return;
        }
        NSString *strResult = [results valueForKey:@"status"];
        if ([strResult isEqualToString:@"success"]) {
            NSDictionary *user = [results valueForKey:@"user"];
            self.firstNameField.text = [user valueForKey:@"firstName"];
            self.lastNameField.text = [user valueForKey:@"lastName"];
            self.emailField.text = [user valueForKey:@"email"];
            self.email = [user valueForKey:@"email"];
            appDelegate.verificationStatus = [user valueForKey:@"emailVerificationStatus"] ;
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                      message:@"Not Authorised"
                                                      delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alert show];
        }
        
    }];
    
    if ([appDelegate.verificationStatus isEqualToString:@"DONE"]){
        self.verifyBtn.enabled = NO ;
        self.verifyBtn.backgroundColor = [ClarksColors clarksMediumGrey];
        [self.verifyBtn setTitle:@"VERIFIED" forState:UIControlStateNormal] ;
        self.verifyLbl.hidden = YES ;
    }else if([appDelegate.verificationStatus isEqualToString:@"INITIATED"]){
        self.verifyBtn.enabled = NO ;
        self.verifyBtn.backgroundColor = [ClarksColors clarksMediumGrey];
        self.verifyLbl.hidden = NO ;
    }else{
        self.verifyBtn.enabled = YES ;
        self.verifyBtn.backgroundColor = [ClarksColors clarksGreen];
        self.verifyLbl.hidden = YES ;
    }
    
    // Adding action when the user taps outside text fields.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
   
}

- (void) viewWillAppear:(BOOL)animated{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIView *loader = [ClarksUI showLoader:self.view];
    [[API instance] get:@"app-user/get-active-user" onComplete:^(NSDictionary *results) {
        [loader removeFromSuperview];
        if(results == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"No network connectivity or server down"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        NSString *strResult = [results valueForKey:@"status"];
        if ([strResult isEqualToString:@"success"]) {
            NSDictionary *user = [results valueForKey:@"user"];
            self.firstNameField.text = [user valueForKey:@"firstName"];
            self.lastNameField.text = [user valueForKey:@"lastName"];
            self.emailField.text = [user valueForKey:@"email"];
            self.email = [user valueForKey:@"email"];
            appDelegate.verificationStatus = [user valueForKey:@"emailVerificationStatus"] ;
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Not Authorised"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
    }];
    
    if ([appDelegate.verificationStatus isEqualToString:@"DONE"]){
        self.verifyBtn.enabled = NO ;
        self.verifyBtn.backgroundColor = [ClarksColors clarksMediumGrey];
        [self.verifyBtn setTitle:@"VERIFIED" forState:UIControlStateNormal] ;
        self.verifyLbl.hidden = YES ;
    }else if([appDelegate.verificationStatus isEqualToString:@"INITIATED"]){
        self.verifyBtn.enabled = NO ;
        self.verifyBtn.backgroundColor = [ClarksColors clarksMediumGrey];
        self.verifyLbl.hidden = NO ;
    }else{
        self.verifyBtn.enabled = YES ;
        self.verifyBtn.backgroundColor = [ClarksColors clarksGreen];
        self.verifyLbl.hidden = YES ;
    }
}

// Method to validate a email string.
-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/va ... l-address/
    NSString *stricterFilterString = @".*?[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    //NSString *stricterFilterString1 = @" [A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


- (BOOL)checkIfTextfieldsEmpty{

    if(self.passwordFiled.text.length > 0){
        if([self.updatePassField.text  isEqual: @""] ||
           [self.currentPassField.text isEqual:@""] ||
           ![self NSStringIsValidEmail:self.emailField.text] ||
           self.firstNameField.text.length == 0 ||
           self.lastNameField.text.length == 0 ||
           (self.updatePassField.text.length < 4)
           ) {
            return true;
        }else{
            return false ;
        }
    }else if(![self NSStringIsValidEmail:self.emailField.text] || self.firstNameField.text.length == 0 || self.lastNameField.text.length == 0){
        return true;
    }else{
        return false;
    }
    
   return false ;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if([self checkIfTextfieldsEmpty]){
        self.saveBtn.enabled = false ;
        self.saveBtn.backgroundColor = [ClarksColors clarksMediumGrey];
    }else{
        self.saveBtn.enabled = true ;
        self.saveBtn.backgroundColor = [ClarksColors clarksGreen];
    }
    
    if([textField isEqual:self.emailField]){
        self.verifyBtn.enabled = false ;
        self.verifyBtn.backgroundColor = [ClarksColors clarksMediumGrey];
        self.verifyLbl.hidden = YES ;
    }
    
    if (textField == self.updatePassField || textField == self.currentPassField || textField == self.passwordFiled)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x , (self.view.frame.origin.y - 320), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if([textField isEqual:self.emailField]){
            if (([textField.text isEqualToString:self.email]) &&
                ([appDelegate.verificationStatus isEqualToString:@"NOT_INITIATED"])) {
                
                self.verifyBtn.enabled = false ;
                [self.verifyBtn setTitle:@"VERIFY" forState:UIControlStateNormal ];
                self.verifyBtn.backgroundColor = [ClarksColors clarksGreen];
            }
            if ((![appDelegate.verificationStatus isEqualToString:@"DONE"] ||
                 ![appDelegate.verificationStatus isEqualToString:@"NOT_INITIATED"]) &&
                ([textField.text isEqualToString:self.email])) {
                
                self.verifyLbl.hidden = NO ;
            }
        }
    

    if (textField == self.updatePassField || textField == self.currentPassField || textField == self.passwordFiled)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x , (self.view.frame.origin.y + 320), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
}

// Method to dismiss keyboard on tapping outside the textfields.
-(void)dismissKeyboard {
    [self.passwordFiled resignFirstResponder];
    [self.currentPassField resignFirstResponder];
    [self.updatePassField resignFirstResponder];
    [self.firstNameField resignFirstResponder];
    [self.lastNameField resignFirstResponder];
    [self.emailField resignFirstResponder];
    
//    if([self checkIfTextfieldsEmpty]){
//        self.saveBtn.enabled = false ;
//        self.saveBtn.backgroundColor = [ClarksColors clarksMediumGrey];
//    }else{
//        self.saveBtn.enabled = true ;
//        self.saveBtn.backgroundColor = [ClarksColors clarksGreen];
//    }
}

- (IBAction)didClickVerify:(id)sender {
    self.verifyLbl.hidden = NO ;
    self.verifyBtn.enabled = NO ;
    self.verifyBtn.backgroundColor = [ClarksColors clarksMediumGrey];
    self.backButton.hidden = NO ;
    NSLog(@"Verify Button Clicked");
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                  message:@"You must be connected to the internet to update your password."
                                                  delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alert show];
        return;
    }
    [[API instance] get:@"app-user/verify-email" onComplete:^(NSDictionary *results) {
        if(results == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                      message:@"No network connectivity or server down"
                                                      delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alert show];
            return;
        }
        NSString *strResult = [results valueForKey:@"status"];
        if ([strResult isEqualToString:@"success"]) {
            NSLog(@"Success!!!");
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Verify Email"
                                                      message:@"Verification email sent successfully"
                                                      delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alert show];
            appDelegate.verificationStatus = [results valueForKey:@"emailVerificationStatus"];
            NSLog(@"Verification Status:%@", appDelegate.verificationStatus);
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Verification not successful"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            self.verifyBtn.enabled = true ;
            self.verifyBtn.backgroundColor = [ClarksColors clarksGreen];
            self.verifyLbl.hidden = YES ;
        }
        // this is a comment
    }];

}

- (void) processResult: (NSDictionary *)res{
    if(res == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"No network connectivity or server down"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSString *strResult = [res valueForKey:@"status"];
    if ([strResult isEqualToString:@"success"]) {
        NSLog(@"Success!!!");
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.verificationStatus = @"INITIATED" ;
        [[MixPanelUtil instance] track:@"userUpdated"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Update User"
                                                        message:@"User Updated Successfully"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        if(![self.email isEqualToString:self.emailField.text]){
            self.verifyBtn.enabled = NO ;
            self.verifyLbl.hidden = NO ;
            [self.verifyBtn setTitle:@"VERIFY" forState:UIControlStateNormal];
            self.verifyBtn.backgroundColor = [ClarksColors clarksMediumGrey];
        }
        
        
    }else if ([strResult isEqualToString:@"failed"]){
        [[MixPanelUtil instance] track:@"userUpdateFailed"];
        NSArray *errors  = [res valueForKey:@"errors"] ;
        NSString *error_msg = @"";
        for (NSString *error in errors){
            error_msg = [NSString stringWithFormat:@"%@ %@",error,error_msg];
            NSLog(@"%@", error);
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Update User"
                                                        message: error_msg
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

- (IBAction)didClickSave:(id)sender {
    [self.currentPassField resignFirstResponder];
    [self.updatePassField resignFirstResponder];
    self.verifyBtn.hidden = NO ;
    // Checking for internet connection.
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                  message:@"You must be connected to the internet to update your password."
                                                  delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    UIView *loader = [ClarksUI showLoader:self.view];
    
    if (self.currentPassField.text.length == 0) {
        [[API instance] post:@"app-user/update-user"
                      params:@{
                               @"firstName" : self.firstNameField.text ,
                               @"lastName" : self.lastNameField.text,
                               @"email" : self.emailField.text
                               }
                  onComplete:^(NSDictionary *results) {
                      [loader removeFromSuperview];
                      [self processResult:results];
                  }
         ];

    }else{
        NSLog(@"%@", self.updatePassField.text);
        [[API instance] post:@"app-user/update-user"
                      params:@{
                               @"firstName" : self.firstNameField.text ,
                               @"lastName" : self.lastNameField.text,
                               @"email" : self.emailField.text,
                               @"currentPassword": self.currentPassField.text,
                               @"newPassword":self.updatePassField.text
                               }
                  onComplete:^(NSDictionary *results) {
                      [loader removeFromSuperview];
                      [self processResult:results];
                  }
         ];

    }
    
}

- (IBAction)didClickChange:(id)sender {
    
    CGRect f = self.changeBtn.frame;
    [ClarksUI reposition:self.saveBtn x:f.origin.x y:533];
    self.currentPassField.text = self.passwordFiled.text ;
    [self.passwordFiled resignFirstResponder];
    [self.currentPassField resignFirstResponder];
    self.changeBtn.hidden = YES ;
    self.currentPassField.hidden = NO;
    self.updatePassField.hidden = NO ;
    self.updatePassLbl.hidden = NO ;
    self.forgotBtn.hidden = NO ;
    self.passwordLbl.text = @"CURRENT PASSWORD" ;
    [self.currentPassField becomeFirstResponder];
}

- (IBAction)didClickBack:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
