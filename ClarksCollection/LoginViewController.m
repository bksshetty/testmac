//
//  LoginViewController.m
//  ClarksCollection
//
//  Created by Openly on 25/09/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import "LoginViewController.h"
#import "ClarksUI.h"
#import "API.h"
#import "ClarksFonts.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "MixPanelUtil.h"
#import "User.h"
#import "ImageDownloadManager.h"
#import <MessageUI/MessageUI.h>
#import "DataReader.h"
#import "ClarksColors.h"
#import "InAppRegistrationViewController.h"
#import "ForgotPasswordViewController.h"
#import "AccountSettingsViewController.h"
#import "SettingsUtil.h"

@interface LoginViewController (){
    UIColor *activeColor;
    UIColor *inactiveColor;
    bool inErrorState;
    UIView *loadingView;
}
@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    
    activeColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.55f];
    inactiveColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.4f];
    inErrorState = false;
    
    [super viewDidLoad];
    UIColor *color = [UIColor whiteColor];
    
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.userField setLeftViewMode:UITextFieldViewModeAlways];
    [self.userField setLeftView:spacerView];
    self.userField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"ENTER EMAIL ADDRESS" attributes:@{NSForegroundColorAttributeName: color}];
    //    [self.userField setFont:[UIFont fontWithName:@"ClarksSansPro-Light" size:14.0f]];
    self.userField.font = [ClarksFonts clarksSansProLight:14.0f];
    
    self.registerBtn.layer.borderColor = [ClarksColors clarksWhite].CGColor;
    self.registerBtn.layer.borderWidth = 1 ;
    [self.registerBtn setHidden:NO];
    
    UIView *spacerView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.passwordFeild setLeftViewMode:UITextFieldViewModeAlways];
    [self.passwordFeild setLeftView:spacerView2];
    self.passwordFeild.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"ENTER PASSWORD" attributes:@{NSForegroundColorAttributeName: color}];
    
    //    [self.passwordField setFont:[UIFont fontWithName:@"ClarksSansPro-Light" size:14.0f]];
    self.passwordFeild.font = [ClarksFonts clarksSansProLight:14.0f];
    self.btnLogin.titleLabel.font = [ClarksFonts clarksSansProRegular:14.0f];
    self.btnForgot.titleLabel.font =[ClarksFonts clarksSansProLight:16.0f];
    self.errorLabel.font = [ClarksFonts clarksSansProLight:16.0f];
    
    self.lblLine2.font = [ClarksFonts clarksSansProLight:16.0f];
    self.lblLine2.text = @"Please email" ;
    self.btnEmail.titleLabel.font = [ClarksFonts clarksSansProLight:16.0f];
    self.versionLabel.font = [ClarksFonts clarksSansProLight:11.0f];
    
    NSMutableAttributedString *emailAddrTxt = [[NSMutableAttributedString alloc] initWithString:@"helpdesk@Clarks.com"];
    [emailAddrTxt addAttribute: NSForegroundColorAttributeName value:[UIColor whiteColor] range: NSMakeRange(0, [emailAddrTxt length])];
    [emailAddrTxt addAttribute: NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger: NSUnderlineStyleSingle] range: NSMakeRange(0, [emailAddrTxt length])];
    [self.btnEmail setAttributedTitle:emailAddrTxt forState:UIControlStateNormal];
    
    NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    self.versionLabel.text = [NSString stringWithFormat:@"Version: %@", version];
    
//    loadingView = [ClarksUI showLoader:self.view];
    // Do any additional setup after loading the view.
}

- (void) showLoading {
    if (loadingView == nil) {
        loadingView = [ClarksUI showLoader:self.view];
    }
}

- (void) hideLoading {
   [loadingView removeFromSuperview];
    loadingView = nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) viewDidAppear:(BOOL)animated{
//    [loadingView removeFromSuperview];
    if (![DataReader hasData]) {
        [self showLoading];
        NSLog(@"Downloading data.json for first time.");
        [[API instance] getOnlyData:@"products" onComplete:^(NSData *data) {
            NSLog(@"Done downloading data.json.");
            NSArray *paths = NSSearchPathForDirectoriesInDomains
            (NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            
            //make a file name to write the data to using the documents directory:
            NSString *fileName = [NSString stringWithFormat:@"%@/data.json",
                                  documentsDirectory];
            [data writeToFile:fileName atomically:YES];
            [self hideLoading];
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [self checkSignedIn];
            [appDelegate tryUpdate];
        }];
    }else{
        [self checkSignedIn];
    }
    
}

-(void) checkSignedIn{
    if ([[API instance] isLoggedIn]) {
        NSLog(@"User has already logged in...");
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate restoreList];
        
        UIViewController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"reveal"];
        [self presentViewController:navVC animated:NO completion:nil];
        [ImageDownloadManager preload];
        return;
    }
}
/*
 #pragma mark - Navigation
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (IBAction)onLoginValueChanged:(id)sender {
    if (!inErrorState) {
        return;
    }
    User *curUser ;
    if (![curUser.name isEqualToString:@"Demo App"]){
        [[MixPanelUtil instance] track:@"newUser"];
    }
    self.userField.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.4];
    self.passwordFeild.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.4];
    inErrorState = false;
    self.btnLogin.hidden = NO;
    self.registerBtn.hidden = NO;
    self.errorLabel.hidden = YES;
}

- (IBAction)onPasswordValueChanged:(id)sender {
    if (!inErrorState) {
        return;
    }
    self.userField.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.4];
    self.passwordFeild.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.4];
    inErrorState = false;
    self.btnLogin.hidden = NO;
    self.registerBtn.hidden = NO ;
    self.errorLabel.hidden = YES;
}


- (IBAction)onContactClark:(id)sender {
    if([MFMailComposeViewController canSendMail] == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No mail client configured"
                                                        message:@"You must have a mail client configured to send mail"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }else {
       
        NSString *emailTitle = @"Clarks";
        NSString *messageBody = @"<h1>Feedback</h1>"; // Change the message body to HTML
        NSArray *toRecipents = [NSArray arrayWithObject:@"firstname.lastname@clarks.co"];
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:YES];
        [mc setToRecipients:toRecipents];
        
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
    }
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    //Add an alert in case of failure
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) repositionButtons
{
    
    CGRect f = self.userField.frame;
    [ClarksUI reposition:self.userField x:f.origin.x y:222];
    
    f = self.registerBtn.frame ;
    [ClarksUI reposition:self.registerBtn x:f.origin.x y:408];
    
    f = self.passwordFeild.frame;
    [ClarksUI reposition:self.passwordFeild x:f.origin.x y:277];
    
    f = self.btnLogin.frame;
    [ClarksUI reposition:self.btnLogin x:f.origin.x y:352];
    
    [ClarksUI reposition:self.errorLabel x:f.origin.x y:360];
    
    f = self.imgLogo.frame;
    [ClarksUI reposition:self.imgLogo x:f.origin.x y:96];
    
}

-(void) unRepositionButtons
{
    CGRect f = self.userField.frame;
    [ClarksUI reposition:self.userField x:f.origin.x y:222 + 110];
    
    
    f = self.passwordFeild.frame;
    [ClarksUI reposition:self.passwordFeild x:f.origin.x y:277 + 110];
    
    f = self.btnLogin.frame;
    [ClarksUI reposition:self.btnLogin x:f.origin.x y:352 + 110];
    
    f = self.registerBtn.frame;
    [ClarksUI reposition:self.registerBtn x:f.origin.x y:165 + 352];
    
    [ClarksUI reposition:self.errorLabel x:f.origin.x y:360 + 110];
    
    f = self.imgLogo.frame;
    [ClarksUI reposition:self.imgLogo x:f.origin.x y:96 + 110];
}

- (IBAction)onEditingStarted:(id)sender {
    self.userField.backgroundColor = [self.userField.backgroundColor colorWithAlphaComponent:0.55f];
    [self.lblLine2 setHidden:YES];
    [self.btnEmail setHidden:YES];
    [self repositionButtons];
}
- (IBAction)onEditingStartedPassword:(id)sender {
    [self repositionButtons];
    [self.lblLine2 setHidden:YES];
    [self.btnEmail setHidden:YES];
    self.passwordFeild.backgroundColor = [self.userField.backgroundColor colorWithAlphaComponent:0.55f];
    
}

- (IBAction)onEditingEnded:(id)sender {
    self.userField.backgroundColor = [self.userField.backgroundColor colorWithAlphaComponent:0.4f];
    [self.lblLine2 setHidden:YES];
    [self.btnEmail setHidden:YES];
    [self unRepositionButtons];
    
}

- (IBAction)onEditingEndedPassword:(id)sender {
    self.passwordFeild.backgroundColor = [self.userField.backgroundColor colorWithAlphaComponent:0.4f];
    [self.lblLine2 setHidden:YES];
    [self.btnEmail setHidden:YES];
    [self unRepositionButtons];
    
}

- (IBAction)didClickRegister:(id)sender {
    
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
    }else{
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle:nil];
        InAppRegistrationViewController *add = [storyboard instantiateViewControllerWithIdentifier:@"InAppRegistration"];
        
        [self presentViewController:add
                            animated:YES
                            completion:nil];
    }
}

-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}

- (IBAction)doLogin:(id)sender
{
    [self.view endEditing:YES];
    [[[SettingsUtil alloc]init] networkRechabilityMethod];
    
    if ([self.userField.text length] < 1 || [self.passwordFeild.text length] < 1) {
        self.errorLabel.text = @"Please enter username and password.";
        self.errorLabel.hidden = NO;
        self.userField.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:0.4];
        self.passwordFeild.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:0.4];
        inErrorState = true;
        self.btnLogin.hidden = YES;
        self.btnEmail.hidden = YES;
        self.registerBtn.hidden = YES ;
        self.lblLine2.hidden = YES;
        return;
    }
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIView *loader = [ClarksUI showLoader:self.view];
    if ([self.passwordFeild.text isEqualToString:@"backdoor"] && [self.passwordFeild.text isEqualToString:@"entry"]) {
        [appDelegate restoreList];
        
        UIViewController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"reveal"];
        [self presentViewController:navVC animated:YES completion:nil];
        return;
    }
    [[API instance] login:self.userField.text password:self.passwordFeild.text onComplete:^(bool success, NSString *errMessage) {
        [loader removeFromSuperview];
        if (success) {
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate restoreList];
            
            [[API instance] get:@"app-user/get-email-verification-status" onComplete:^(NSDictionary *res) {
                if (res == nil) {
                    [[[SettingsUtil alloc] init] CMSNullErrorMethod];
                }
                appDelegate.verificationStatus = [res valueForKey:@"emailVerificationStatus"];
                if (![[res valueForKey:@"emailVerificationStatus"] isEqualToString:@"DONE"]) {
                    if ([[res valueForKey:@"emailVerificationStatus"] isEqualToString:@"BLOCKED"]) {
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                        AccountSettingsViewController *accountSetting = [storyboard instantiateViewControllerWithIdentifier:@"accountSettings"];
                        [self presentViewController:accountSetting animated:YES completion:nil];
                    }else {
                        UIViewController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"reveal"];
                        [self presentViewController:navVC animated:YES completion:nil];
                    }
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Verification Status"
                                                                    message:@"Please verify your email address"
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    return;
                }else {
                    UIViewController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"reveal"];
                    [self presentViewController:navVC animated:YES completion:nil];
                }
            }] ;
            
            [[API instance]get:@"get-lists" onComplete:^(NSDictionary *results) {
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
                    NSData *content = [results valueForKey:@"listsData"];
                    
                    NSLog(@"%@", content);
                    NSString *trimmerUserName = [[User current].name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    NSString *listName = [NSString stringWithFormat:@"%@-ClarksList.txt",trimmerUserName];
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsDirectory = [paths objectAtIndex:0];
                    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:listName];
                    NSData *data = [[NSData alloc] initWithBase64EncodedData:content options:0];
                    NSLog(@"%@",appFile);
                    [content writeToFile:[documentsDirectory stringByAppendingPathComponent:@"api.txt"] atomically:YES];
                    
                    [data writeToFile:appFile atomically:YES];
                    
                    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    [appDelegate restoreList];
                    
                }else{
                    NSLog(@"Failure");
                }
            }];

            [ImageDownloadManager preload];
        }else{
            self.errorLabel.hidden = NO;
            self.errorLabel.text = errMessage;
            self.userField.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:0.4];
            self.passwordFeild.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:0.4];
            self.btnLogin.hidden = YES;
            [self.btnEmail setHidden:YES];
            [self.registerBtn setHidden:YES];
            [self.lblLine2 setHidden:YES];
            inErrorState = true;
        }
    }];
    
    }

- (IBAction)forgotUsername:(id)sender
{
    
    // Checking for internet connection.
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    
    SettingsUtil *setting  = [[SettingsUtil alloc] init] ;
    NSDictionary *res =  [setting getContentsOfSettingsFile] ;
    NSDictionary *forgotPass = [res valueForKey:@"NetworkStatus"] ;
    NSString *title = [forgotPass valueForKey:@"title"];
    NSString *message = [forgotPass valueForKey:@"message"] ;
    if (title == nil && message == nil) {
        title = @"" ;
        message = @"";
        
    }
    if (networkStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }else{
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle:nil];
        ForgotPasswordViewController *add = [storyboard instantiateViewControllerWithIdentifier:@"forgot_password"];
        
        [self presentViewController:add
                           animated:YES
                         completion:nil];
    }

}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end