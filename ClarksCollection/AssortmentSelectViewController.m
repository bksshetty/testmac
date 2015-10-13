//
//  AssortmentSelectViewController.m
//  ClarksCollection
//
//  Created by Openly on 25/09/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import "AssortmentSelectViewController.h"
#import "SWRevealViewController.h"
#import "ClarksFonts.h"
#import "ClarksColors.h"
#import "CollectionSelectViewController.h"
#import "MixPanelUtil.h"
#import "MenubarViewController.h"
#import "Region.h"
#import "Item.h"

@interface AssortmentSelectViewController () {
    
    int selectedIndex;
}
@end

@implementation AssortmentSelectViewController
@synthesize assortmentName ;

static AssortmentSelectViewController *instance = nil;

+(AssortmentSelectViewController*)getInstance{
    @synchronized(self)
    {
        if(instance==nil)
        {
            instance= [AssortmentSelectViewController new];
        }
    }
    return instance;
}

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
    //[self setRegion:@[ [Region getCurrent] ]];
    // Do any additional setup after loading the view.
    self.lblWelcome.font =[ClarksFonts clarksSansProRegular:11.0f];
    self.lblWelcome.textColor = [ClarksColors clarksMediumGrey];
    
    self.lblCollectionName.font = [ClarksFonts clarksSansProThin:30.0f];
    self.lblYear.font = [ClarksFonts clarksSansProThin:30.0f];
    
    self.lblLine2.font = [ClarksFonts clarksSansProThin:30.0f];
    
    // Hide them temporarily to avoid the jarring
    self.lblWelcome.hidden = YES;
    self.lblCollectionName.hidden= YES;
    self.lblYear.hidden= YES;
    self.lblLine2.hidden= YES;
    self.collectionView.hidden = YES;

    [self performSelector:@selector(showAssortments) withObject:nil afterDelay:0.75];

    if ([Region getCurrent] != nil) {
        [self setRegion:@[[Region getCurrent]] ];
    }
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
}

-(void) viewWillAppear:(BOOL)animated{
    CATransition *navTransition = [CATransition animation];
    navTransition.duration = 1;
    navTransition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    navTransition.type = kCATransitionPush;
    navTransition.subtype = kCATransitionPush;
    [self.navigationController.navigationBar.layer addAnimation:navTransition forKey:nil];
}

-(void)showAssortments {
    self.lblWelcome.hidden = NO;
    self.lblCollectionName.hidden= NO;
    self.lblYear.hidden= NO;
    self.lblLine2.hidden= NO;
    self.collectionView.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

    

}
-(void) setRegion:(NSArray *)regionArray{
    [self.assortmentDS setupRegion:regionArray];
    
}

#pragma mark - Navigation


- (IBAction)openMenu:(id)sender {
    [self.revealViewController revealToggle:sender];
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndex = (int)indexPath.row;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UICollectionViewCell *cell = (UICollectionViewCell *) sender;
    CollectionSelectViewController *clVC = (CollectionSelectViewController *)[segue destinationViewController];
    int index = (int)cell.tag;
    Assortment *theAssortment = [self.assortmentDS assortmentAtIndex:index];
    
    AssortmentSelectViewController *ass = [AssortmentSelectViewController getInstance];
    ass.assortmentName = theAssortment.name ;
    
    [[MixPanelUtil instance] track:@"assortment_selected" args:((NSString *)theAssortment.name)];
    [clVC setAssortment:theAssortment];
}
@end
