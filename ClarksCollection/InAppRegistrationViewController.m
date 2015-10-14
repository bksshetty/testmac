//
//  InAppRegistrationViewController.m
//  ClarksCollection
//
//  Created by Openly on 17/07/2015.
//  Copyright (c) 2015 Clarks. All rights reserved.
//

#import "InAppRegistrationViewController.h"
#import "ClarksColors.h"
#import "KeyboardInsetScrollView.h"
#import "API.h"
#import "ClarksUI.h"
#import "MixPanelUtil.h"
#import "Reachability.h"
#import "SettingsUtil.h"

@interface InAppRegistrationViewController()

@end

@implementation InAppRegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.regionDropDownBtn setTitle:@"SELECT YOUR REGION" forState:UIControlStateNormal];
    
    // Adding left padding of 20px to all the text fields.
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
    [self.passwordField setLeftViewMode:UITextFieldViewModeAlways];
    [self.passwordField setLeftView:spacerView5];
    
    UIView *spacerView6 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.reEnterField setLeftViewMode:UITextFieldViewModeAlways];
    [self.reEnterField setLeftView:spacerView6];
 
    // Setting up delgates for all the textfields and adding secure editing for password fields.
    self.firstNameField.delegate=self;
    self.lastNameField.delegate=self ;
    self.emailField.delegate=self;
    
    self.passwordField.delegate=self ;
    self.passwordField.secureTextEntry = YES;
    
    self.reEnterField.delegate=self ;
    self.reEnterField.secureTextEntry = YES;
    
    // Dropdown view properties.
    self.dropdownView.hidden = YES;
    self.dropdownView.layer.borderWidth = 1 ;
    self.dropdownView.layer.borderColor = [ClarksColors clarksMediumGrey].CGColor;
    
    // Confirm view properties.
    self.confirmView.hidden = YES ;
    self.confirmView.backgroundColor = [ClarksColors clarkLightGrey];
    self.confirmView.alpha = 0.9 ;
    self.okBtn.layer.borderWidth = 1;
    self.okBtn.layer.borderColor = [ClarksColors clarksButtonGreen].CGColor;
    
    // Adding action when the user taps outside text fields.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    [[MixPanelUtil instance] track:@"inAppRegistrationButtonClicked"];
    
    UIView *loader = [ClarksUI showLoader:self.view];
    [[API instance]get:@"regions" onComplete:^(NSDictionary *results) {
        [loader removeFromSuperview];
        if(results == nil) {
            [[[SettingsUtil alloc] init] CMSNullErrorMethod] ;
        }
        NSString *strResult = [results valueForKey:@"status"];
        if ([strResult isEqualToString:@"success"]) {
            NSDictionary *res = [results valueForKey:@"regions"];
            self.region_res = res ;
            //[self.region_res valueForKey:@"name"];
            [self createButton:res];
        }
    }] ;
    
    // Adding background color for the entire screen/view.
    self.view.backgroundColor = [ClarksColors clarkLightGrey] ;
}

// Create dropdown buttons.
-(void)createButton: (NSDictionary *)results {
    int i = 0 ;
    self.btnArray = [[NSMutableArray alloc] init];
    for (NSDictionary *regions in results) {
        if(![[regions valueForKey:@"name"]isEqualToString:@"GLOBAL"]){
            CGRect rect = CGRectMake(0,50+i*50, 621, 50);
            UIButton *btn = [[UIButton alloc] initWithFrame: rect];
            btn.backgroundColor = [ClarksColors clarksWhite] ;
            [btn setTitle:[regions valueForKey:@"name"] forState:UIControlStateNormal];
            btn.titleLabel.text = [regions valueForKey:@"name"];
            [btn setTitleColor:[ClarksColors clarksMediumGrey] forState:UIControlStateNormal];
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            btn.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
            
            [btn addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.btnArray addObject:btn];
            [self.dropdownView addSubview:btn];
            i++;
        }
    }
}

// Action on click of dropdown buttons.
-(void) onBtnClick: (UIButton *)btn{
    for (UIButton *button in self.btnArray) {
        if([button.titleLabel.text isEqualToString: btn.titleLabel.text]){
            button.backgroundColor = [ClarksColors clarksButtonGreen];
            [button setTitleColor:[ClarksColors clarksWhite] forState:UIControlStateNormal];
        }else{
            button.backgroundColor = [ClarksColors clarksWhite];
            [button setTitleColor:[ClarksColors clarksMediumGrey] forState:UIControlStateNormal];
        }
    }
    self.dropdownView.hidden = YES;
    [btn setTitleColor:[ClarksColors clarksWhite] forState:UIControlStateNormal];
    [self.regionDropDownBtn setTitle:btn.titleLabel.text forState:UIControlStateNormal];
    self.region_name = btn.titleLabel.text ;
}

// Method to dismiss keyboard on tapping outside the textfields.
-(void)dismissKeyboard {
    [self.firstNameField resignFirstResponder];
    [self.lastNameField resignFirstResponder];
    [self.emailField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.reEnterField resignFirstResponder];
    //self.regionDropDownBtn.titleLabel.text = self.region_name;
    
    self.dropdownView.hidden = YES;
    if([self checkIfTextfieldsEmpty]){
        self.registerButton.enabled = false ;
        self.registerButton.backgroundColor = [ClarksColors clarksMediumGrey];
    }else{
        self.registerButton.enabled = true ;
        self.registerButton.backgroundColor = [ClarksColors clarksButtonGreen];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    if([self.region_name isEqualToString: @""]|| [self.region_name isEqualToString:@"SELECT YOUR REGION"]||self.region_name == nil)
       [self.regionDropDownBtn setTitle:@"SELECT YOUR REGION" forState:UIControlStateNormal];
    else
        [self.regionDropDownBtn setTitle:self.region_name forState:UIControlStateNormal];
}

// Method to check all the necessary conditons (textfields are empty, emailfield validation and password must be 8 characters long).
- (BOOL)checkIfTextfieldsEmpty{
    if([self.firstNameField.text isEqual: @""] ||
       [self.lastNameField.text isEqual: @""] ||
       [self.emailField.text  isEqual: @""] ||
       [self.passwordField.text  isEqual: @""] ||
       [self.reEnterField.text  isEqual: @""]||
       ![self NSStringIsValidEmail:self.emailField.text] ||
       ![self.passwordField.text isEqualToString:self.reEnterField.text] ||
       (self.passwordField.text.length < 4) ||
       [self.regionDropDownBtn.titleLabel.text isEqualToString: @"SELECT YOUR REGION"]||
       [self.regionDropDownBtn.titleLabel.text isEqualToString: @" "]) {
            return true;
        }else{
            return false ;
    }
    return true;
}

- (IBAction)emailFieldValueChanged:(id)sender {
}

// Delegate method to enable or disable the register button on editing begin of textfields.
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
        if([self checkIfTextfieldsEmpty]){
            self.registerButton.enabled = false ;
            self.registerButton.backgroundColor = [ClarksColors clarksMediumGrey];
        }else{
            self.registerButton.enabled = true ;
            self.registerButton.backgroundColor = [ClarksColors clarksButtonGreen];
        }
    self.dropdownView.hidden = YES ;
        if([self.region_name isEqualToString: @""]|| [self.region_name isEqualToString:@"SELECT YOUR REGION"]||self.region_name == nil)
            [self.regionDropDownBtn setTitle:@"SELECT YOUR REGION" forState:UIControlStateNormal];
        else
            [self.regionDropDownBtn setTitle:self.region_name forState:UIControlStateNormal];
    
        if (textField == self.passwordField|| textField == self.reEnterField)
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationBeginsFromCurrentState:YES];
            self.view.frame = CGRectMake(self.view.frame.origin.x , (self.view.frame.origin.y - 320), self.view.frame.size.width, self.view.frame.size.height);
            [UIView commitAnimations];
        }
}

// Delegate method to enable or disable the register button on editing end of textfields.
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.passwordField || textField == self.reEnterField)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x , (self.view.frame.origin.y + 320), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    if([self.region_name isEqualToString: @""]|| [self.region_name isEqualToString:@"SELECT YOUR REGION"]||self.region_name == nil)
        [self.regionDropDownBtn setTitle:@"SELECT YOUR REGION" forState:UIControlStateNormal];
    else
        [self.regionDropDownBtn setTitle:self.region_name forState:UIControlStateNormal];
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

// Action method on click of region button in the main view.
- (IBAction)didClickRegionDropDown:(id)sender {
    [self.emailField resignFirstResponder];
    [self.firstNameField resignFirstResponder];
    [self.lastNameField resignFirstResponder];
    self.dropdownView.hidden = NO ;
}

// Action method on click of close button in the confirm view.
- (IBAction)didClickClose:(id)sender {
    //self.confirmView.hidden = YES ;
    [self dismissViewControllerAnimated:NO completion:nil];
}

// Action method on click of OK button in confirm view.
- (IBAction)didClickOk:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

// Action method on click of REGISTER button in main view.
- (IBAction)onClickRegister:(id)sender {
    
    // Checking for internet connection.
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                        message:@"You must be connected to the internet to register."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    UIView *loader = [ClarksUI showLoader:self.view];
    NSString *userName = [NSString stringWithFormat:@"%@ %@", self.firstNameField.text, self.lastNameField.text];
    NSString *region_id ;
   
    NSLog(@"First Name: %@", self.firstNameField.text);
    NSLog(@"Last Name: %@", self.lastNameField.text);
    NSLog(@"Email Address: %@", self.emailField.text);
    NSLog(@"Password: %@", self.passwordField.text);
    NSLog(@"Re enter password: %@", self.reEnterField.text);

    for (NSDictionary *region in self.region_res){
        NSLog(@"%@",self.region_name);
        if([[region valueForKey:@"name"] isEqualToString:self.region_name]){
            region_id = [region valueForKey:@"id"];
       
    NSLog(@"Region: %@", region_id);
    
    // API POST Call with input as data parameters and output json with results.
    [[API instance] post:@"app-user/create"
                    params:@{@"userName":self.emailField.text,
                         @"password": self.passwordField.text,
                         @"confirmPassword":self.reEnterField.text,
                         @"firstName":self.firstNameField.text,
                         @"lastName":self.lastNameField.text,
                         @"region":region_id,
                         @"email":self.emailField.text
                        }
     
                    onComplete:^(NSDictionary *results) {
                        [loader removeFromSuperview];
                        if(results == nil) {
                            [[[SettingsUtil alloc] init] CMSNullErrorMethod] ;
                        }
                        NSString *strResult = [results valueForKey:@"status"];
                        if ([strResult isEqualToString:@"success"]) {
                            NSLog(@"Success!!!");
                            [[MixPanelUtil instance] track:@"userRegistered" args:((NSString *) userName)];
                            [self.confirmView setHidden:NO];
                        }
                        else if ([strResult isEqualToString:@"failed"]){
                            [[MixPanelUtil instance] track:@"registrationFailed"];
                            NSArray *errors  = [results valueForKey:@"errors"] ;
                            NSString *error_msg = @"";
                            for (NSString *error in errors){
                                error_msg = [NSString stringWithFormat:@"%@ %@",error,error_msg];
                                NSLog(@"%@", error);
                            }
                            
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"In-App Registration"
                                                                            message: error_msg
                                                                            delegate:self
                                                                            cancelButtonTitle:@"OK"
                                                                            otherButtonTitles:nil];
                            [alert show];
                        }
                }
     ];
        }
    }

}
@end
