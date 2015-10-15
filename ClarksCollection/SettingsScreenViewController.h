//
//  SettingsScreenViewController.h
//  ClarksCollection
//
//  Created by Openly on 27/07/2015.
//  Copyright (c) 2015 Clarks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsScreenViewController : UIViewController
- (IBAction)toggleMenu:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *ImageUpdaterBtn;
- (IBAction)didClickAccount:(id)sender;

@end
