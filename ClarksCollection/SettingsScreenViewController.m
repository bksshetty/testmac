//
//  SettingsScreenViewController.m
//  ClarksCollection
//
//  Created by Openly on 27/07/2015.
//  Copyright (c) 2015 Clarks. All rights reserved.
//

#import "SettingsScreenViewController.h"
#import "DownloadManagerViewController.h"
#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import "Reachability.h"
#import "AccountSettingsViewController.h"

@interface SettingsScreenViewController ()

@end

@implementation SettingsScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
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

- (IBAction)toggleMenu:(id)sender {
    [self.revealViewController revealToggle:sender];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.selectedMenuIndex = 5;
}
- (IBAction)didClickAccount:(id)sender {
    // Checking for internet connection.
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                        message:@"You must be connected to the internet to change your settings."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }else{
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle:nil];
        AccountSettingsViewController *add = [storyboard instantiateViewControllerWithIdentifier:@"accountSettings"];
        
        [self presentViewController:add
                           animated:YES
                         completion:nil];
    }
}

@end

