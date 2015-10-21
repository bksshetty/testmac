//
//  DiscoverCollectionViewController.m
//  ClarksCollection
//
//  Created by Openly on 17/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "DiscoverCollectionViewController.h"
#import "SWRevealViewController.h"
#import "DiscoverCollectionDetailViewController.h"
#import "DiscoverCollection.h"
#import "AppDelegate.h"
#import "MixPanelUtil.h"

@interface DiscoverCollectionViewController () {
  
}

@end




@implementation DiscoverCollectionViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UICollectionViewCell *cell = sender;
    NSIndexPath *indexPath = [self.discoverCollectionView indexPathForCell:cell];
    DiscoverCollectionDetailViewController *discoverDetailVC = (DiscoverCollectionDetailViewController *) segue.destinationViewController;
    DiscoverCollection *theDiscoverCollection = [[DiscoverCollection loadAll] objectAtIndex:indexPath.row];
    
    discoverDetailVC.assortmentName = theDiscoverCollection.assortmentName;
    discoverDetailVC.collectionName =theDiscoverCollection.collectionName;
    [[MixPanelUtil instance] track:@"discover_selected" args:[NSString stringWithFormat:@"Discover Collection Through Menubar: %@",((DiscoverCollection *)theDiscoverCollection).collectionName]];
    [discoverDetailVC setDetailImages:theDiscoverCollection.detailImages];
}


- (IBAction)onMenu:(id)sender {
    [self.revealViewController revealToggle:sender];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.selectedMenuIndex = 3;
}
@end
