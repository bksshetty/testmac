//
//  DownloadManagerViewController.m
//  ClarksCollection
//
//  Created by Abhilash Hebbar on 27/05/15.
//  Copyright (c) 2015 Clarks. All rights reserved.
//

#import "DownloadManagerViewController.h"
#import "AppDelegate.h"
#import "DownloadTableViewCell.h"
#import "ClarksUI.h"
#import "DownloadItem.h"
#import "SWRevealViewController.h"
#import "Reachability.h"
#import "AssortmentSelectViewController.h"
#import "MixPanelUtil.h"
#import "ClarksColors.h"
#import "SettingsUtil.h"
#import "SettingsScreenViewController.h"

@interface DownloadManagerViewController (){
    NSArray *downloadItems;
    BOOL downloadingAll;
    BOOL viewLoaded;
    BOOL hideHelpView;
    BOOL allCompleted ;
    Reachability *internetReachableFoo;
}
@end

@implementation DownloadManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //self.overlay.hidden = YES;
    self.menuButton.hidden = YES;
    [[MixPanelUtil instance] track:@"downloadManager"];
    downloadItems = [DownloadItem getAll];
    downloadingAll = YES;
    allCompleted = YES;
    for (DownloadItem *item in downloadItems) {
        if(item.status == NOT_STARTED || item.status == PAUSED || item.status == STOPPED) {
            downloadingAll = NO;
            break;
        }
        if(!(item.status == COMPLETED)) {
            allCompleted = NO;
        }
    }
    viewLoaded = YES;
    if (downloadingAll && allCompleted) {
        downloadingAll = NO;
        [self.downloadAllBtn setTitle:@"DOWNLOAD ALL" forState:UIControlStateNormal];
        [self.downloadAllBtn setTitleColor:[ClarksColors clarksMediumGrey] forState:UIControlStateNormal] ;
        [self.downloadAllBtn setEnabled: NO ] ;
        self.downloadAllBtn.userInteractionEnabled = NO ;
        
        [self.downloadAllBtn setTitle:@"DOWNLOAD ALL" forState:UIControlStateHighlighted];
        [self.downloadAllBtn setTitleColor:[ClarksColors clarksMediumGrey] forState:UIControlStateHighlighted] ;
        [self.downloadAllBtn setEnabled: NO ];
        self.downloadAllBtn.userInteractionEnabled = NO ;
        
    }else if (!downloadingAll) {
        
        [self.downloadAllBtn setTitle:@"DOWNLOAD ALL" forState:UIControlStateNormal];
        [self.downloadAllBtn setTitleColor:[ClarksColors clarksMenuButtonGreen] forState:UIControlStateHighlighted] ;
        [self.downloadAllBtn setEnabled:YES ] ;
        
        [self.downloadAllBtn setTitle:@"DOWNLOAD ALL" forState:UIControlStateHighlighted];
        [self.downloadAllBtn setTitleColor:[ClarksColors clarksMenuButtonGreen] forState:UIControlStateHighlighted] ;
        [self.downloadAllBtn setEnabled:YES ] ;
        
    }else{
        
        [self.downloadAllBtn setTitle:@"STOP ALL" forState:UIControlStateNormal];
        [self.downloadAllBtn setTitleColor:[ClarksColors clarksMenuButtonGreen] forState:UIControlStateHighlighted] ;
        [self.downloadAllBtn setEnabled:YES ] ;
        
        [self.downloadAllBtn setTitle:@"STOP ALL" forState:UIControlStateHighlighted];
        [self.downloadAllBtn setTitleColor:[ClarksColors clarksMenuButtonGreen] forState:UIControlStateHighlighted] ;
        [self.downloadAllBtn setEnabled:YES ] ;
        
    }
    
    if (hideHelpView) {
        [self hideHelpView];
    }else{
        if (appDelegate.firstLaunch == 1) {
            UIStoryboard * storyboard = self.storyboard;
            AssortmentSelectViewController *destVC = [storyboard instantiateViewControllerWithIdentifier: @"assortment_select"];
            [self.navigationController pushViewController: destVC animated: NO];
        } else {
            appDelegate.firstLaunch = 1 ;
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"firstLaunch"];
        }
    }
    
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(refreshBtn)
                                   userInfo:nil repeats:YES
     ];
    
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [downloadItems count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DownloadTableViewCell *cell = [tableView
                        dequeueReusableCellWithIdentifier:@"download-cell"
                        forIndexPath:indexPath];
    [cell setItem:downloadItems[indexPath.row]];
    return cell;
}
- (void) hideHelpView{
    if (!viewLoaded) {
        hideHelpView = YES;
        return;
    }
    self.continueBtn.hidden = YES;
    self.menuButton.hidden = NO;
    self.helpView.hidden = YES;
    [ClarksUI reposition:self.downloadListView x:self.downloadListView.frame.origin.x y:0];
}
- (IBAction)downloadAll:(id)sender {
    DownloadTableViewCell *downLoadTableView = [DownloadTableViewCell alloc];
    [[[SettingsUtil alloc] init]  networkRechabilityMethod];

    for (DownloadItem *item in downloadItems) {
        if (downloadingAll) {
            [item cancel];
        }else{
            [item start];
            [item resume];
        }
        if(!(item.status == COMPLETED)) {
            allCompleted = NO;
        }else{
            allCompleted = YES ;
        }
        
    }
    if  (downloadingAll) {
        
        [self.downloadAllBtn setTitle:@"DOWNLOAD ALL" forState:UIControlStateNormal];
        [self.downloadAllBtn setTitleColor:[ClarksColors clarksMenuButtonGreen] forState:UIControlStateNormal] ;
        [self.downloadAllBtn setEnabled:YES ] ;
        
        [self.downloadAllBtn setTitle:@"DOWNLOAD ALL" forState:UIControlStateHighlighted];
        [self.downloadAllBtn setTitleColor:[ClarksColors clarksMenuButtonGreen] forState:UIControlStateHighlighted] ;
        [self.downloadAllBtn setEnabled:YES ] ;
        
    }else{
        
        [self.downloadAllBtn setTitle:@"STOP ALL" forState:UIControlStateNormal];
        [self.downloadAllBtn setTitleColor:[ClarksColors clarksMenuButtonGreen] forState:UIControlStateHighlighted] ;
        [self.downloadAllBtn setEnabled:YES ] ;
        
        [self.downloadAllBtn setTitle:@"STOP ALL" forState:UIControlStateHighlighted];
        [self.downloadAllBtn setTitleColor:[ClarksColors clarksMenuButtonGreen] forState:UIControlStateHighlighted] ;
        [self.downloadAllBtn setEnabled:YES ] ;
        
    }
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(refreshBtn)
                                   userInfo:nil repeats:YES
     ];
    downloadingAll = !downloadingAll;
    [downLoadTableView refresh];
    [NSTimer scheduledTimerWithTimeInterval:1.0
                target:self
                selector:@selector(reload)
                userInfo:nil repeats:NO
     ];
    
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
    if ([segue.identifier isEqualToString:@"setting_screen"]) {
        SettingsScreenViewController *vc = (SettingsScreenViewController *) segue.destinationViewController;
    }
}

-(void) refreshBtn{
    for (DownloadItem *item in downloadItems) {
        if(!(item.status == COMPLETED)) {
            allCompleted = NO;
            break ;
        }else{
            allCompleted = YES ;
        }
        
    }
    if (downloadingAll && allCompleted) {

        [self.downloadAllBtn setTitle:@"DOWNLOAD ALL" forState:UIControlStateNormal];
        [self.downloadAllBtn setTitleColor:[ClarksColors clarksMediumGrey] forState:UIControlStateNormal] ;
        [self.downloadAllBtn setEnabled:NO] ;
        self.downloadAllBtn.userInteractionEnabled = NO ;
        
        [self.downloadAllBtn setTitle:@"DOWNLOAD ALL" forState:UIControlStateHighlighted];
        [self.downloadAllBtn setTitleColor:[ClarksColors clarksMediumGrey] forState:UIControlStateHighlighted] ;
        [self.downloadAllBtn setEnabled:NO] ;
        self.downloadAllBtn.userInteractionEnabled = NO ;
        
    }else if (!downloadingAll) {
        downloadingAll = NO ;
        [self.downloadAllBtn setTitle:@"DOWNLOAD ALL" forState:UIControlStateNormal];
        [self.downloadAllBtn setTitleColor:[ClarksColors clarksMenuButtonGreen] forState:UIControlStateHighlighted] ;
        [self.downloadAllBtn setEnabled:YES ] ;
        
        [self.downloadAllBtn setTitle:@"DOWNLOAD ALL" forState:UIControlStateHighlighted];
        [self.downloadAllBtn setTitleColor:[ClarksColors clarksMenuButtonGreen] forState:UIControlStateHighlighted] ;
        [self.downloadAllBtn setEnabled:YES ] ;
        
    }else{
        
        [self.downloadAllBtn setTitle:@"STOP ALL" forState:UIControlStateNormal];
        [self.downloadAllBtn setTitleColor:[ClarksColors clarksMenuButtonGreen] forState:UIControlStateHighlighted] ;
        [self.downloadAllBtn setEnabled:YES ] ;
        
        [self.downloadAllBtn setTitle:@"STOP ALL" forState:UIControlStateHighlighted];
        [self.downloadAllBtn setTitleColor:[ClarksColors clarksMenuButtonGreen] forState:UIControlStateHighlighted] ;
        [self.downloadAllBtn setEnabled:YES ] ;
        
    }

}

-(void) reload{
    [self.downloadsTable reloadData];
}

- (IBAction)toggleMenu:(id)sender {

//    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
//                                                         bundle:nil];
//    SettingsScreenViewController *add = [storyboard instantiateViewControllerWithIdentifier:@"setting_screen"];
//    
//    [self presentViewController:add
//                       animated:YES
//                     completion:nil];
    
    
    //[self dismissViewControllerAnimated:YES completion:nil];
}
@end
