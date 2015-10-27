//
//  CustomNavigationControllerViewController.m
//  ClarksCollection
//
//  Created by Openly on 06/10/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "CustomNavigationControllerViewController.h"
#import "API.h"

@interface CustomNavigationControllerViewController ()

@end

@implementation CustomNavigationControllerViewController

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
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    id rootController;
    if ([[API instance]isLoggedIn] ){
        rootController = [self.storyboard instantiateViewControllerWithIdentifier:@"region_select"];
    }
    else{
        rootController = [self.storyboard instantiateViewControllerWithIdentifier:@"sign_in"];
    }
    self.viewControllers = [NSArray arrayWithObjects:rootController, nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
