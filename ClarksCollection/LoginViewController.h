//
//  LoginViewController.h
//  ClarksCollection
//
//  Created by Openly on 25/09/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface LoginViewController : UIViewController <MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *passwordFeild;

- (IBAction)doLogin:(id)sender;
- (IBAction)forgotUsername:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
- (IBAction)onLoginValueChanged:(id)sender;
- (IBAction)onPasswordValueChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblLine1;
@property (weak, nonatomic) IBOutlet UILabel *lblLine2;
@property (weak, nonatomic) IBOutlet UIButton *btnEmail;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
- (IBAction)onContactClark:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnForgot;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property BOOL checkMixpanelUser ;

- (IBAction)onEditingStarted:(id)sender;
- (IBAction)onEditingStartedPassword:(id)sender;
- (IBAction)onEditingEnded:(id)sender;
- (IBAction)onEditingEndedPassword:(id)sender;
- (IBAction)didClickRegister:(id)sender;


@property (weak, nonatomic) IBOutlet UIImageView *imgLogo;

-(IBAction)textFieldReturn:(id)sender;
- (void) showLoading;
- (void) hideLoading;
@end
