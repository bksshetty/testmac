//
//  MenubarViewController.m
//  ClarksCollection
//
//  Created by Openly on 25/09/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import "MenubarViewController.h"
#import "ListViewController.h"
#import "SWRevealViewController.h"
#import "ClarksFonts.h"
#import "ClarksColors.h"
#import "API.h"
#import "ImageDownloader.h"
#import "Region.h"
#import "User.h"
#import "AppDelegate.h"
#import "MixPanelUtil.h"
#import "DownloadManagerViewController.h"
#import "AccountSettingsViewController.h"
#import "SettingsUtil.h"


@interface MenubarViewController () {
    NSTimer *statusUpdateTimer;
    NSTimer *blinkTimer;
}

@end

@implementation MenubarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        statusUpdateTimer = nil;
        blinkTimer = nil;
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.updateActivity.hidden = YES;
    // Do any additional setup after loading the view.
    
    self.lblTestMode.font = [ClarksFonts clarksSansProRegular:9.0f];
    self.btnCatalogue.titleLabel.font =[ClarksFonts clarksSansProThin:20.0f];
    
    self.btnList.titleLabel.font =[ClarksFonts clarksSansProThin:20.0f];
    
    [self.lblTestMode setFont: [UIFont fontWithName:@"Arial" size:20.0]];
    //self.lblTestMode.font = [ClarksFonts clarksSansProRegular:9.0f];
    if(API.instance.isTestMode){
        self.lblTestMode.text = @"( Test Mode )" ;
    }

    //self.btnList.titleLabel.layer = blackColor ;
    self.btnDiscoverCollection.titleLabel.font =[ClarksFonts clarksSansProThin:20.0f];
    self.btnMarketing.titleLabel.font =[ClarksFonts clarksSansProThin:20.0f];
    self.btnHelp.titleLabel.font = [ClarksFonts clarksSansProThin:20.0f];
    self.btnMarketing.titleLabel.font = [ClarksFonts clarksSansProThin:20.0f];
    self.btnSettings.titleLabel.font = [ClarksFonts clarksSansProThin:20.0f];
    
    self.lblDownloadInfo.font = [ClarksFonts clarksSansProRegular:9.0f];
    self.lblVersion.font = [ClarksFonts clarksSansProRegular:9.0f];
    self.btnLogout.titleLabel.font =[ClarksFonts clarksSansProRegular:11.0f];
    self.btnChangeTerritory.titleLabel.font =[ClarksFonts clarksSansProRegular:11.0f];
    self.lblCurrencyChange.font = [ClarksFonts clarksSansProLight:11.0];

    self.btnLogout.backgroundColor=[ClarksColors clarksMenuButtonGreen];
    self.btnChangeTerritory.backgroundColor=[ClarksColors clarksMenuButtonGreen];
    self.btnUpdateData.backgroundColor = [ClarksColors clarksMenuButtonGreen] ;
    self.btnUpdateData.titleLabel.font =[ClarksFonts clarksSansProRegular:11.0f];
    
    self.revealViewController.rearViewRevealWidth = 310;
    
    // Hide download info for now.
    self.lblDownloadInfo.hidden = NO;
    
    [self registerForNotifications];

}
-(void) updateStatuses {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ImageDownloader *dl = [ImageDownloader instance];
    
    [[MixPanelUtil instance] track:@"update"];
    NSString *str;
    NSLog(@"Downloaded Items: %d",[dl downloadedItems]);
    NSLog(@"Total Items : %d",[dl totalItems]);
    if([dl totalItems] == 0)
        str = @"DOWLOADED ALL IMAGES";
    else
        str =[NSString stringWithFormat:@"DOWLOADED %d OF %d IMAGES", [dl downloadedItems], [dl totalItems] ];
    
    self.lblDownloadInfo.text = str;
    if(appDelegate.dataState ==  DataIsDownloading) {
        [self.btnUpdateData setTitle:@"DOWNLOADING .." forState:UIControlStateNormal];
        [self.btnUpdateData setTitle:@"DOWNLOADING .." forState:UIControlStateHighlighted];
        if(blinkTimer == nil)
            blinkTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(blink) userInfo:nil repeats:YES];
    }
    
    if(appDelegate.dataState == DataDownloaded) {
            [self.btnUpdateData setTitle:@"ACCEPT NEW DATA .." forState:UIControlStateNormal];
            [self.btnUpdateData setTitle:@"ACCEPT NEW DATA .." forState:UIControlStateHighlighted];
            self.btnUpdateData.enabled = YES;
            [self.btnUpdateData setHidden:NO];
    }
        
    if(appDelegate.dataState ==VersionCheck) {
        [self.btnUpdateData setTitle:@"Performing version check" forState:UIControlStateNormal];
        [self.btnUpdateData setTitle:@"Performing version check" forState:UIControlStateHighlighted];
    }

    if(appDelegate.dataState == DataError || appDelegate.dataState == DataIsCurrent) {
        [self.btnUpdateData setTitle:@"UPDATE CATALOGUE" forState:UIControlStateNormal];
        [self.btnUpdateData setTitle:@"UPDATE CATALOGUE" forState:UIControlStateHighlighted];
        self.btnUpdateData.enabled = YES;
        [self.btnUpdateData setHidden:NO];
        if(blinkTimer != nil) {
            [blinkTimer invalidate];
            blinkTimer = nil;
        }
    }
    return;
}

-(void) blink {
    [self.btnUpdateData setHidden:(!self.btnUpdateData.hidden)];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if(statusUpdateTimer != nil) {
        [statusUpdateTimer invalidate];
        statusUpdateTimer = nil;
        
    }
    
    if(blinkTimer != nil) {
        [blinkTimer invalidate];
        blinkTimer = nil;
        
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self updateRegion];
    [self.btnCatalogue setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnList setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnDiscoverCollection setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnMarketing setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnHelp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnSettings setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
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
            }
        }
        else{
            NSLog(@"Failed");
        }
    }] ;
    
    NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    NSLog(@"App Version: %@",version);
    self.lblVersion.text = [NSString stringWithFormat:@"Version: %@. Data version %d", version, appDelegate.dataVersion];

    NSString *alert_message ;
    if(appDelegate.dataVersion < 1){
        alert_message = @"Please update the catalog else the app might not work as expected." ;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Update Required"
                                                        message:alert_message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

        
    }
    
    
    NSLog(@"App version: %f", [version doubleValue]);
    NSLog(@"Minimum App version: %f", appDelegate.minAppVersion);
    if (appDelegate.minAppVersion > [version doubleValue] ){
        NSLog(@"Minimum App version: %f", appDelegate.minAppVersion);
        alert_message = [NSString stringWithFormat: @"Please download the latest version of the app(%@) else the app might not work as expected.", version ];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Update Required"
                                                        message:alert_message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    [self updateStatuses];
    [self updateActive];
    statusUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:15.0f target:self selector:@selector(updateStatuses) userInfo:nil repeats:YES];
}

-(void) addLeftBorder:(UIButton *) btn{
    UIView *leftBorder = [[UIView alloc] initWithFrame:CGRectMake(1, 0, 2, btn.frame.size.height)];
    leftBorder.backgroundColor = [ClarksColors clarksButtonGreen];
    [btn addSubview:leftBorder];
}

-(void) removeLeftBorder:(UIButton *) btn{
    UIView *leftBorder = [[UIView alloc] initWithFrame:CGRectMake(1, 0, 2, btn.frame.size.height)];
    leftBorder.backgroundColor = [ClarksColors clarksGreen ];
    [btn addSubview:leftBorder];
}

-(void) updateActive{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //CALayer *leftBorder = [CALayer layer];
    switch (appDelegate.selectedMenuIndex) {
        case 1:
            [self.btnCatalogue setTitleColor:[ClarksColors clarksMenuSelectedGray] forState:UIControlStateNormal];
            [self addLeftBorder:self.btnCatalogue] ;
            [self removeLeftBorder:self.btnList] ;
            [self removeLeftBorder:self.btnDiscoverCollection] ;
            [self removeLeftBorder:self.btnMarketing] ;
            [self removeLeftBorder:self.btnSettings] ;
            [self removeLeftBorder:self.btnHelp] ;
            [[MixPanelUtil instance] track:@"catalouge_selected"];
            break;
            
        case 2:
            [self.btnList setTitleColor:[ClarksColors clarksMenuSelectedGray] forState:UIControlStateNormal];
            [self addLeftBorder:self.btnList] ;
            [self removeLeftBorder:self.btnCatalogue] ;
            [self removeLeftBorder:self.btnDiscoverCollection] ;
            [self removeLeftBorder:self.btnMarketing] ;
            [self removeLeftBorder:self.btnSettings] ;
            [self removeLeftBorder:self.btnHelp] ;
            break;
            
        case 3:
            [self.btnDiscoverCollection setTitleColor:[ClarksColors clarksMenuSelectedGray] forState:UIControlStateNormal];
            [self addLeftBorder:self.btnDiscoverCollection] ;
            [self removeLeftBorder:self.btnCatalogue] ;
            [self removeLeftBorder:self.btnList] ;
            [self removeLeftBorder:self.btnMarketing] ;
            [self removeLeftBorder:self.btnSettings] ;
            [self removeLeftBorder:self.btnHelp] ;
            break;
            
        case 4:
            [self.btnMarketing setTitleColor:[ClarksColors clarksMenuSelectedGray] forState:UIControlStateNormal];
            [self addLeftBorder:self.btnMarketing] ;
            [self removeLeftBorder:self.btnCatalogue] ;
            [self removeLeftBorder:self.btnList] ;
            [self removeLeftBorder:self.btnDiscoverCollection] ;
            [self removeLeftBorder:self.btnSettings] ;
            [self removeLeftBorder:self.btnHelp] ;
            break;
            
        case 5:
            [self.btnSettings setTitleColor:[ClarksColors clarksMenuSelectedGray] forState:UIControlStateNormal];
            [self addLeftBorder:self.btnSettings] ;
            [self removeLeftBorder:self.btnCatalogue] ;
            [self removeLeftBorder:self.btnList] ;
            [self removeLeftBorder:self.btnDiscoverCollection] ;
            [self removeLeftBorder:self.btnMarketing] ;
            [self removeLeftBorder:self.btnHelp] ;
            break;
        
        case 6:
            [self.btnHelp setTitleColor:[ClarksColors clarksMenuSelectedGray] forState:UIControlStateNormal];
            [self addLeftBorder:self.btnHelp] ;
            [self removeLeftBorder:self.btnCatalogue] ;
            [self removeLeftBorder:self.btnList] ;
            [self removeLeftBorder:self.btnDiscoverCollection] ;
            [self removeLeftBorder:self.btnMarketing] ;
            [self removeLeftBorder:self.btnSettings] ;
            break;
            
        default:
            break;
    }

}


- (IBAction)onChangeTerritory:(id)sender {
    if(self.targetController == nil) {
        self.targetController = [self.storyboard instantiateViewControllerWithIdentifier:@"changeTerritory"];
        self.targetController.modalPresentationStyle = UIModalPresentationFormSheet;
        self.targetController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;  //transition shouldn't matter
    }
    [self presentViewController:self.targetController animated:YES completion:nil];
}

-(void) updateRegion{
    Region *reg = [Region getCurrent];
    User *curUser = [User current];
    NSArray * region = curUser.regions;
    if([region count] >1) {
        [self.btnChange setTitle:[NSString stringWithFormat:@"Hello %@, You are in %@. CHANGE" , curUser.name, reg.name] forState:UIControlStateNormal];
        self.btnChange.enabled = YES;
    } else {
        [self.btnChange setTitle:[NSString stringWithFormat:@"Hello %@, You are in %@." , curUser.name, reg.name] forState:UIControlStateNormal];
        self.btnChange.enabled = NO;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.selectedMenuIndex = [segue.identifier intValue];
    [[MixPanelUtil instance] track:@"menuBar_selected"];
    [self updateActive];
    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
    }
    if ([segue.identifier isEqualToString:@"download_manager"]) {
        DownloadManagerViewController *vc = (DownloadManagerViewController *) segue.destinationViewController;
        [vc hideHelpView];
    }
}



- (IBAction)doUpdateData:(id)sender {
    [self.updateActivity startAnimating];
    self.updateActivity.hidden = NO;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.dataState == DataIsCurrent ||
       appDelegate.dataState == DataError ||
       appDelegate.dataState == DataStateUnknown) {
        [appDelegate downloadProductInfo:NO onComplete:^{
            [self.updateActivity stopAnimating];
            self.updateActivity.hidden = YES;
        }];
        self.btnUpdateData.enabled = NO;
    }
    if(appDelegate.dataState == DataDownloaded) {
        [self doLogout:sender];
        appDelegate.dataState = DataIsCurrent;
    }
}

- (IBAction)doLogout:(id)sender {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                        message:@"You must be connected to the internet to logout."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }else{
        NSString *trimmerUserName = [[User current].name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSString *listName = [NSString stringWithFormat:@"%@-ClarksList.txt",trimmerUserName];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *appFile = [documentsDirectory stringByAppendingPathComponent:listName];
        NSData *data = [NSData dataWithContentsOfFile:appFile];
        NSString *content = [data base64EncodedStringWithOptions:0];
        
        if(content != nil){
            [[API instance] post:@"update-lists"
                          params:@{@"listsData": content
                                   }
                      onComplete:^(NSDictionary *results) {
                          if(results == nil) {
                              [[[SettingsUtil alloc] init] CMSNullErrorMethod] ;
                          }
                          NSString *strResult = [results valueForKey:@"status"];
                          if ([strResult isEqualToString:@"success"]) {
                              NSFileManager *fileManager = [NSFileManager defaultManager];
                              NSError *error;
                              BOOL success = [fileManager removeItemAtPath:appFile error:&error];
                              if (success) {
                                  NSLog(@"Success!!!");
                              }
                          }
                          else{
                              NSLog(@"Failed");
                          }
                      }];
        }
    }

    [[API instance]get:@"/logout" onComplete:^(NSDictionary *results) {
        if (results == nil) {
            [[[SettingsUtil alloc] init] CMSNullErrorMethod] ;
        }
        if ([[results valueForKey:@"status"]isEqualToString:@"success"]) {
            [[API instance]logout:^{
                [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"sign_in"] animated:NO completion:nil];
            }];
        }else if ([[results valueForKey:@"error"] isEqualToString:@"Session expired."]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:[results valueForKey:@"error"]
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            [[API instance]logout:^{
                [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"sign_in"] animated:NO completion:nil];
            }];
            return;
            }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[results valueForKey:@"error"]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
    }];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.dataState = DataIsCurrent;
 
    appDelegate.activeList = nil;
}

- (void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yourCustomMethod:) name:@"Logout" object:nil];
}

/*** Your custom method called on notification ***/
-(void)yourCustomMethod:(NSNotification*)_notification
{

    [self doLogout:nil];
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
