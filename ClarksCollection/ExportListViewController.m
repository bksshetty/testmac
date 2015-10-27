//
//  ExportListViewController.m
//  ClarksCollection
//
//  Created by Openly on 13/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "ExportListViewController.h"
#import "ClarksColors.h"
#import "ClarksFonts.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "API.h"
#import "Lists.h"
#import "ItemList.h"
#import "AppDelegate.h"
#import "ClarksUI.h"
#import "AccountSettingsViewController.h"

@interface ExportListViewController ()

@end

@implementation ExportListViewController

- (void)viewDidLoad {
    self.view.backgroundColor = [ClarksColors clarkLightGrey] ;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.lbl1.font = [ClarksFonts clarksSansProThin:40.0f];
    self.txtEMail.font =[ClarksFonts clarksSansProThin:20.0f];
    UIView *spacerView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 17, 20)];
    [self.txtEMail setLeftViewMode:UITextFieldViewModeAlways];

    UIColor *color = [ClarksColors clarksMediumGrey];
    
    [self.txtEMail setLeftView:spacerView2];
    self.txtEMail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter email address" attributes:@{NSForegroundColorAttributeName:color}];
    self.txtEMail.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (UIViewController*) topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}

-(void)goBack {
    [self.navigationController popViewControllerAnimated:TRUE];
}


- (IBAction)onListSend:(id)sender {
    
    // Checking for internet connection.
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                        message:@"You must be connected to the internet to export a list."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [self.view endEditing:YES];
    self.btnSend.enabled = YES;
    [self.txtEMail resignFirstResponder];
    Lists *listToBeExported;
    if (self.list == nil) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        listToBeExported = [appDelegate.listofList objectAtIndex: self.index];
    }else{
        listToBeExported = self.list;
    }
    NSString *email = self.txtEMail.text;
   
    NSString *itemNumbers=@"";
    BOOL firstTime = YES;
    for(ListItem *theListItems in listToBeExported.listOfItems) {
        if(firstTime) {
            firstTime = NO ;
            itemNumbers = theListItems.itemNumber;
        } else {
            itemNumbers = [NSString stringWithFormat:@"%@,%@", itemNumbers, theListItems.itemNumber];
        }
    }
    NSArray *user_ids = [email componentsSeparatedByString:@","];
    NSMutableSet* existingNames = [NSMutableSet set];
    NSMutableArray* mutable_user_ids = [NSMutableArray array];
    for (NSString *object in user_ids) {
        if (![existingNames containsObject:object]) {
            [existingNames addObject:object];
            [mutable_user_ids addObject:object];
        }
    }
    
    UIView *loader = [ClarksUI showLoader:self.view];
    
    NSLog(@"%@", listToBeExported.listName);
    
    [[API instance] get:@"app-user/get-email-verification-status" onComplete:^(NSDictionary *results) {
        if(results == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"No network connectivity or server down"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        //NSString *strMsg;
        NSString *strResult = [results valueForKey:@"status"];
        if ([strResult isEqualToString:@"success"]) {
            NSLog(@"Success!!!");
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.verificationStatus  = [results valueForKey:@"emailVerificationStatus"];
            if([[results valueForKey:@"emailVerificationStatus"] isEqualToString:@"BLOCKED"]){
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                AccountSettingsViewController *accountSetting = [storyboard instantiateViewControllerWithIdentifier:@"accountSettings"];
                [self presentViewController:accountSetting animated:YES completion:nil];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Verification Status"
                                                                message:@"Please verify your email address"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }else{
                [[API instance] post:@"export-list" params:@{@"name":listToBeExported.listName, @"emails":email, @"items":itemNumbers} onComplete:^(NSDictionary *results) {
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
                    NSString *strMsg;
                    NSString *strResult = [results valueForKey:@"status"];
                    if ([strResult isEqualToString:@"success"]) {
                        strMsg = [NSString stringWithFormat:@"Your list has successfully been exported to recipients and should be in their inbox shortly."];
                    }
                    else {
                        strMsg =@"Sorry, we were unable to export your list at this time, please try again later.";
                    }
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Export list"
                                                                    message:strMsg
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                }];
            }
        }
        else{
            NSLog(@"Failed");
        }
    }] ;
    
    
    
}

- (IBAction)doNothing:(id)sender {
    [self goBack];
}

- (IBAction)onValueChanged:(id)sender {
    NSString *email = self.txtEMail.text;
    NSArray * user_ids = [email componentsSeparatedByString:@","];
    
    for (NSString *mail_id in user_ids){
        if([self NSStringIsValidEmail:mail_id])
            self.btnSend.enabled = YES;
        else
            self.btnSend.enabled = NO;
    }
    
}

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

- (IBAction)onEditingBegin:(id)sender {
    [self repositionButtons];
}

-(void) repositionButtons
{
    CGRect f = self.lbl1.frame;
    [ClarksUI reposition:self.lbl1 x:f.origin.x y:76];
    
    f = self.txtEMail.frame;
    [ClarksUI reposition:self.txtEMail x:f.origin.x y:168];
    
    f = self.btnSend.frame;
    [ClarksUI reposition:self.btnSend x:f.origin.x y:244];
}

-(void) unRepositionButtons
{
    CGRect f = self.lbl1.frame;
    [ClarksUI reposition:self.lbl1 x:f.origin.x y:76+135];
    
    f = self.txtEMail.frame;
    [ClarksUI reposition:self.txtEMail x:f.origin.x y:168+135];
    
    f = self.btnSend.frame;
    [ClarksUI reposition:self.btnSend x:f.origin.x y:244+135];
}

- (IBAction)onEditingEnded:(id)sender {
    [self unRepositionButtons];
}


@end