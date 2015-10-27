//
//  HelpViewController.m
//  ClarksCollection
//
//  Created by Openly on 25/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "HelpViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "ClarksFonts.h"
#import "UILabel+dynamicSizeMe.h"
#import "MixPanelUtil.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    int i;
    [[MixPanelUtil instance] track:@"help"];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    UILabel *lbl = (UILabel *)[self.view viewWithTag:107];
    lbl.font = [ClarksFonts clarksSansProRegular:30.0f];
    
    for(i=100;i<107;i++){
        UILabel *lbl = (UILabel *)[self.view viewWithTag:i];
        lbl.font = [ClarksFonts clarksSansProRegular:20.0f];
    }
    
    for(i=110;i<117;i++){
        UILabel *lbl = (UILabel *)[self.view viewWithTag:i];
        lbl.font = [ClarksFonts clarksSansProThin:16.0f];
    }
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

- (IBAction)openMenu:(id)sender {
    [self.revealViewController revealToggle:sender];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.selectedMenuIndex = 6;
}

@end
