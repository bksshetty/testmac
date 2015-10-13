//
//  MenubarViewController.h
//  ClarksCollection
//
//  Created by Openly on 25/09/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChangeTeritoryViewController.h"

@interface MenubarViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblTestMode ;
@property (weak, nonatomic) IBOutlet UIButton *btnCatalogue;
@property (weak, nonatomic) IBOutlet UIButton *btnList;
@property (weak, nonatomic) IBOutlet UIButton *btnDiscoverCollection;
@property (weak, nonatomic) IBOutlet UIButton *btnMarketing;
@property (weak, nonatomic) IBOutlet UIButton *btnHelp;
@property (weak, nonatomic) IBOutlet UILabel *lblDownloadInfo;
@property (weak, nonatomic) IBOutlet UIButton *btnLogout;
@property (weak, nonatomic) IBOutlet UIButton *btnChangeTerritory;
@property (weak, nonatomic) IBOutlet UIButton *btnChange;
@property (weak, nonatomic) IBOutlet UILabel *lblVersion;
@property (weak, nonatomic) IBOutlet UIButton *btnUpdateData;
@property (weak, nonatomic) IBOutlet UIButton *btnSettings;


- (IBAction)doUpdateData:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *updateActivity;

- (IBAction)doLogout:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrencyChange;
- (IBAction)onChangeTerritory:(id)sender;
@property (strong,nonatomic) ChangeTeritoryViewController* targetController;
-(void) updateRegion;
@end
