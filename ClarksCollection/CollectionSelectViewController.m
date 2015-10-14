//
//  CollectionSelectViewController.m
//  ClarksCollection
//
//  Created by Openly on 01/10/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "CollectionSelectViewController.h"
#import "CollectionViewCellButton.h"
#import "ShoeListViewController.h"
#import "ClarksColors.h"
#import "ClarksFonts.h"
#import "SWRevealViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "MixPanelUtil.h"
#import "Region.h"

@interface CollectionSelectViewController ()

@end

@implementation CollectionSelectViewController
int count = 0 ;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)updateButtons:(BOOL)btnSelected
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.lblLabel.font = [ClarksFonts clarksSansProThin:30.0f];
    self.lblLabel.textAlignment = NSTextAlignmentCenter;
    //[self.lblLabel setCenter:_view.center];
    self.btnSelectAll.titleLabel.font = [ClarksFonts clarksSansProLight:16.0f];
    self.btnReset.titleLabel.font = [ClarksFonts clarksSansProLight:16.0f];
    self.btnClose.titleLabel.font = [ClarksFonts clarksSansProLight:12.0f];
    
    self.btnReset.enabled = NO;
    self.btnReset.alpha = 0.5;
    
    [self.collectionSelectDS updateCallback:^(BOOL btnSelected){
        if(btnSelected)
        {
            self.btnApply.enabled = YES;
            self.btnReset.enabled = YES;
            self.btnReset.alpha = 1.0;
        }
        else
        {
            self.btnApply.enabled = NO;
            self.btnReset.enabled = NO;
            self.btnReset.alpha = 0.5;
        }
        
        NSArray *selItems = [self.collectionSelectDS getListofSelectedCollections];
        
        if ([selItems count] == [self.collectionSelectDS.curAssortment.collections count]) {
            self.btnSelectAll.enabled = NO;
            self.btnSelectAll.alpha = 0.5;
        }else{
            self.btnSelectAll.enabled = YES;
            self.btnSelectAll.alpha = 1.0;
        }
     }];
    //[self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
  }


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setAssortment:(Assortment *)assortment{
    [self.collectionSelectDS setupAssortment:assortment];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.selectedAssortmentName = assortment.name;
}

- (IBAction)openMenu:(id)sender {
    [self.revealViewController revealToggle:sender];
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ShoeListViewController *shoeListVC = (ShoeListViewController *)[segue destinationViewController];
    // Get the list of selected collections from datasource
    NSArray *collectionArray = [self.collectionSelectDS getListofSelectedCollections];
    if([Region getCurrent] != NULL){
        for(NSString* collectionName in collectionArray){
            [[MixPanelUtil instance] track:@"collection_selected" args:((Collection *)collectionName).name ];
        }
    }
    [shoeListVC setupCollections:collectionArray];
}



-(void)setDisplayValue:(BOOL) val
{
    // For starters everything is unselected
    
    [self.collectionSelectDS markAllCollectionsState:val];
    for(UICollectionView *cell in self.collectionView.visibleCells)
    {
        UIImageView *checkMark =  (UIImageView *)[cell viewWithTag:102];
        checkMark.hidden = (val == YES)?NO:YES;
      //  count++ ;
    }
    
}


- (IBAction)onSelectAll:(id)sender {
    if ([self.collectionView.visibleCells count]>0) {
        [self setDisplayValue:YES];
        self.btnApply.enabled = YES;
        self.btnSelectAll.enabled = NO;
        self.btnSelectAll.alpha = 0.5;
        
        self.btnReset.enabled = YES;
        self.btnReset.alpha = 1.0;
    }
}

- (IBAction)onReset:(id)sender {
    [self setDisplayValue:NO];
    
    self.btnReset.enabled = NO;
    self.btnReset.alpha = 0.5;
    
    self.btnSelectAll.enabled = YES;
    self.btnSelectAll.alpha = 1.0;
    //[self.btnSelectAll.titleLabel setTextColor : [UIColor blackColor]];
}
@end
