//
//  DiscoverCollectionDetailViewController.m
//  ClarksCollection
//
//  Created by Openly on 17/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "DiscoverCollectionDetailViewController.h"
#import "ShoeListViewController.h"
#import "Region.h"
#import "Assortment.h"
#import "AppDelegate.h"
#import "Collection.h"
#import "SwipeView.h"
#import "ManagedImage.h"
#import "AppDelegate.h"
#import "Region.h"
#import "Assortment.h"
#import "DiscoverCollection.h"
#import "MixPanelUtil.h"


@interface DiscoverCollectionDetailViewController () {
    NSArray *images;
    int nCurrImageIdx;
}

@end

@implementation DiscoverCollectionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView{
   return [images count];
}


- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    if (view == nil) {
        CGRect frame = CGRectMake(0, 0, 1024, 704);
        view = [[ManagedImage alloc] initWithFrame: frame];
    }
    NSString *strImgName = images[index];
    ((ManagedImage *)view).image = [UIImage imageNamed:@"translucent"];
    [((ManagedImage *)view) loadImage:strImgName];
    ((ManagedImage *)view).contentMode = UIViewContentModeScaleAspectFit;
    return view;
}

-(void) setupTransitionFromShoeDetail:(NSString *)theCollectionName {
    DiscoverCollection *theDiscoverCollection;
    self.collectionName = theCollectionName;
    for(theDiscoverCollection in [DiscoverCollection loadAll]) {
        if([theDiscoverCollection.collectionName isEqualToString:theCollectionName]) {
            break;
        }
    }
    //what ever was the last just in case we did not find it to avoid crashing
    images = theDiscoverCollection.detailImages;
    self.assortmentName = theDiscoverCollection.assortmentName;
    return;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ShoeListViewController *shoeListVC = (ShoeListViewController *)[segue destinationViewController];
    // Get the list of selected collections from datasource
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
 
    Region *curRegion = [Region getCurrent];
    NSArray *theCollectionArray ;
    for(Assortment *theAssortment in curRegion.assortments) {
        if([theAssortment.name isEqualToString:self.assortmentName]) {
            for (Collection *theCollection in theAssortment.collections) {
                if([theCollection.name isEqualToString:self.collectionName]) {
                    theCollectionArray = [[NSArray alloc]initWithObjects:theCollection, nil];
                    [shoeListVC setupCollections:theCollectionArray];
                    appDelegate.selectedAssortmentName = self.assortmentName;
                    return;
                }
            }
        }
    }
    

 }

- (IBAction)viewTheColl:(id)sender {
    [[MixPanelUtil instance] track:@"viewTheCollection"];
}

-(void)setDetailImages:(NSArray *)theImages; {
    images = theImages;
}

@end
