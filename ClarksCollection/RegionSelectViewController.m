//
//  RegionSelectViewController.m
//  ClarksCollection
//
//  Created by Openly on 25/09/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import "RegionSelectViewController.h"
#import "AssortmentSelectViewController.h"
#import "SWRevealViewController.h"
#import "ClarksFonts.h"
#import "ClarksColors.h"
#import "PListHelper.h"
#import "User.h"
#import "MenubarViewController.h"
#import "AppDelegate.h"
#import "MixPanelUtil.h"
#import "DownloadManagerViewController.h"
#import "Region.h"
#import "DataReader.h"
#import "API.h"
#import "ClarksUI.h"
#import "ImageDownloadManager.h"

@interface RegionSelectViewController ()
{
    BOOL btnState[5];
    //NSArray *btnArray;
}

@end

@implementation RegionSelectViewController



- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        regions = [Region loadAll];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        regions = [Region loadAll];
    }
    return self;
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSArray *allregionArray = [[NSArray alloc] initWithObjects:@"UK & ROI",
                               @"ASIA PACIFIC",
                               @"EUROPEAN UNION",
                               @"AMERICAS",
                               @"GLOBAL",
                               nil];
    User *curUser = [User current];
    if([curUser.regions count] == 1) {
        NSString *regionString  = curUser.regions[0];
        int i =0;
        for(NSString *str in allregionArray) {
            if([str isEqualToString:regionString])
                btnState[i] = true;
            else
                btnState[i]=false;
            i++;
        }
        
        [self gotoNextScreen];
    }
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:false];
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear: (BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewDidDisappear:animated];
}


-(void)createLeftBtn : (NSString *)btnName i:(float *)cnt tag:(int)t{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = t ;
    [button addTarget:self
               action:@selector(onClickRegion:)
     forControlEvents:UIControlEventTouchUpInside];
    if ([btnName isEqualToString:@"EUROPEAN UNION"]) {
        btnName = @"EUROPE" ;
    }
    [button setTitle:btnName forState:UIControlStateNormal];
    button.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4f];
    button.frame = CGRectMake(74.0, 336+ *cnt, 181.0, 51.0) ;
    [self.btnArray addObject:button];
    [self.view addSubview:button];
}

-(void)createRightBtn : (NSString *)btnName i:(float *)cnt tag:(int)t{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = t ;
    [button addTarget:self
               action:@selector(onClickRegion:)
     forControlEvents:UIControlEventTouchUpInside];
    
    [button setTitle:btnName forState:UIControlStateNormal];
    button.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4f];
    button.frame = CGRectMake(258.0, 336+ *cnt, 181.0, 51.0) ;
    [self.btnArray addObject:button];
    [self.view addSubview:button];
}

-(void)createCenterBtn : (NSString *)btnName i:(float *)cnt tag:(int)t{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = t ;
    [button addTarget:self
               action:@selector(onClickRegion:)
     forControlEvents:UIControlEventTouchUpInside];
    
    [button setTitle:btnName forState:UIControlStateNormal];
    button.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4f];
    button.frame = CGRectMake(168.0, 444, 181.0, 51.0) ;
    [self.btnArray addObject:button];
    [self.view addSubview:button];
}

-(void)onClickRegion : (UIButton *)btn{
    NSLog(@"Contol Coming here!! Tag: %ld",(long)btn.tag);
    for (UIButton *btn in self.btnArray) {
        btn.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4f];
    }
    [self selectDeselectBtn:btn btnNo:(int)btn.tag];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    float i = 0, b = 0  ;
    int cnt = 1, a= 0;
    self.btnArray = [[NSMutableArray alloc] init];
    for (Region *reg in regions) {
        if ([reg.name isEqualToString:@"GLOBAL"]) {
            float f = [regions count] ;
            [self createCenterBtn:reg.name i:&f tag:(int)[regions count]] ;
            break ;
        }else if (a%2 == 0){
            [self createLeftBtn:reg.name i:&i tag:cnt];
            i = i + 54;
            cnt++;
        }else{
            [self createRightBtn:reg.name i:&b tag:cnt];
            b = b + 54;
            cnt++;
        }
        a++ ;
    }
    
    
    if (regions == nil && [regions count]==0) {
            UIView *loader = [ClarksUI showLoader:self.view];
            NSLog(@"Downloading data.json for first time.");
            [[API instance] getOnlyData:@"products" onComplete:^(NSData *data) {
                [loader removeFromSuperview];
                NSLog(@"Done downloading data.json.");
                NSArray *paths = NSSearchPathForDirectoriesInDomains
                (NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                
                //make a file name to write the data to using the documents directory:
                NSString *fileName = [NSString stringWithFormat:@"%@/data.json",
                                      documentsDirectory];
                [data writeToFile:fileName atomically:YES];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Regions Available"
                                                                message:@"No regions are available. Please retry by logging out and logging in. If the problem persists please contact the adminstrator."
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"Logout",nil];
                [alert show];
                
                
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                //[self checkSignedIn];
                [appDelegate tryUpdate];
            }];
    }
    
    
    UIButton *btn;
    
    User *curUser = [User current];
    if([curUser.regions count] == 1) {
        for( btn in _btnArray) {
            btn.titleLabel.font =[ClarksFonts clarksSansProLight:14.0f];
            btn.hidden = YES;
        }
        //hide every thing
        self.btnReset.hidden = YES;
        self.btnSelectAll.hidden = YES;
        self.btnApply.hidden = YES;
        self.lblHello.hidden = YES;
        self.lblSelectRegion.hidden = YES;
        self.lblVersion.hidden = YES;
    }
    
    
    self.btnSelectAll.titleLabel.font =[ClarksFonts clarksSansProLight:16.0f];
    self.btnReset.titleLabel.font =[ClarksFonts clarksSansProLight:16.0f];
    
    self.btnApply.titleLabel.font =[ClarksFonts clarksSansProRegular:14.0f];
    
    self.lblHello.font = [ClarksFonts clarksSansProLight:30.0f];
    self.lblSelectRegion.font = [ClarksFonts clarksSansProLight:16.0f];
    self.lblVersion.font = [ClarksFonts clarksSansProLight:11.0f];
    
    NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    self.lblVersion.text = [NSString stringWithFormat:@"Version: %@", version];
    
    User *curUsr = [User current];
    
    self.lblHello.text = [NSString stringWithFormat:@"Hello %@,", curUsr.name];
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    return YES;
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView firstOtherButtonIndex]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Logout" object:nil userInfo:nil];
    }
}

- (IBAction)applySelected:(UIButton *)sender {
    
    [self gotoNextScreen];
}

-(void) gotoNextScreen{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.firstLaunch == 0) {
        [self performSegueWithIdentifier:@"download_manager" sender:self];
    } else {
        [self performSegueWithIdentifier:@"assortment_selector" sender:self];
    }
}

-(void) selectDeselectBtn:(id)sender btnNo:(int)btnNo
{
    // Perform action such as enabling Apply and
    BOOL isAnyBtnSelected = true;
    int i =0;
    while(i < 5)
    {
        btnState[i] = false;
        i++;
    }
    
    UIButton *btn = (UIButton *)sender;
    btn.backgroundColor = [ClarksColors clarksBlack55Opaque];
    
    btnState[btnNo-1] = true;
    
    if(isAnyBtnSelected)
    {
        [self.btnApply setEnabled:YES];
        self.btnApply.backgroundColor = [self.btnApply.backgroundColor colorWithAlphaComponent:1.0f];
    }
    else
    {
        [self.btnApply setEnabled:NO];
        self.btnApply.backgroundColor = [self.btnApply.backgroundColor colorWithAlphaComponent:0.7f];
    }
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    // Will worry about the selected region later
    int i =0;
    
    NSMutableArray *regionArray =  [[NSMutableArray alloc] initWithCapacity:5];
    if([regions count]!= 0){
        while(i < [regions count])
        {
            if(btnState[i] == true) // The object was selected
            {
                [regionArray addObject:regions[i]];
            }
            i++;
        }
        NSLog(@"%d", i);
        [Region setCurrent: regionArray[0]];
        [[MixPanelUtil instance] track:@"region_selected" args:((Region *)regionArray[0]).name];
        [(MenubarViewController *)[self.revealViewController rearViewController] updateRegion];
    }else{
        NSLog(@"Data is either corrupted or not present!!");
    }
    
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end