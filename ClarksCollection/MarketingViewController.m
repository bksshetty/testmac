//
//  MarketingViewController.m
//  ClarksCollection
//
//  Created by Openly on 17/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "MarketingViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "MarketingCategory.h"
#import "MarketingDetailViewController.h"
#import "MarketingMaterial.h"
#import "ClarksColors.h"
#import "ClarksFonts.h"
#import "MixPanelUtil.h"

@interface MarketingViewController ()

@end

@implementation MarketingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    float i = 0 ;
    int cnt = 0 ;
    
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    self.btnArray = [[NSMutableArray alloc] init];
    self.marketingCategory = [MarketingCategory loadAll];
    for (MarketingCategory *cat in self.marketingCategory){
        [self createBtn:[cat.name uppercaseString] i: &i tag:cnt];
        i = i + 40.0 ;
        cnt++ ;
    }
}

-(void)createBtn : (NSString *)btnName i:(float *)cnt tag:(int)t{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = t ;
    [button addTarget:self
               action:@selector(onClickMarketing:)
     forControlEvents:UIControlEventTouchUpInside];
    
    [button setTitle:btnName forState:UIControlStateNormal];
    if ([btnName isEqualToString:@"OUR BIG STORIES"]) {
        [button setTitleColor:[ClarksColors clarksWhite] forState:UIControlStateNormal];
    }else{
        [button setTitleColor:[ClarksColors clarksMediumGrey] forState:UIControlStateNormal];
    }
    
    [button.titleLabel setFont:[ClarksFonts clarksSansProRegular:14.0f]];
    button.frame = CGRectMake(0.0, 185+ *cnt, 183.0, 30.0) ;
    [self.btnArray addObject:button];
    [self.containerView addSubview:button];
}

-(void)onClickMarketing : (UIButton *)btn{
    self.index = (int)btn.tag;
    for (UIButton *button in self.btnArray) {
        [button setTitleColor:[ClarksColors clarksMediumGrey] forState:UIControlStateNormal];
    }
    [btn setTitleColor:[ClarksColors clarksWhite] forState:UIControlStateNormal];
    [self.marketingCollectionView reloadData];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.marketingCategory = [MarketingCategory loadAll];
        self.index =0;
        // Custom initialization
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        self.index = 0;
        self.marketingCategory = [MarketingCategory loadAll];
        // Custom initialization
    }
    return self;
}

- (IBAction)onMenu:(id)sender {
    [self.revealViewController revealToggle:sender];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.selectedMenuIndex = 4;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UICollectionViewCell *cell = sender;
    NSIndexPath *indexPath = [self.marketingCollectionView indexPathForCell:cell];
    MarketingDetailViewController *marketingDetailVC = (MarketingDetailViewController *) segue.destinationViewController;
    
    MarketingCategory *theCategory = [self.marketingCategory objectAtIndex:self.index];
    MarketingMaterial *theMarketingMaterial = [theCategory.marketingMaterials objectAtIndex:indexPath.row];
    [[MixPanelUtil instance] track:@"marketing_selected" args:[NSString stringWithFormat:@"Marketing Materials through menubar: %@",((NSString *)theCategory.name)]];
    marketingDetailVC.theMarketingData = theMarketingMaterial;

}

@end
