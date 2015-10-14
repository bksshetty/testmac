//
//  DiscoverCollectionViewController.h
//  ClarksCollection
//
//  Created by Openly on 17/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscoverCollection.h"

@interface DiscoverCollectionViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate>
- (IBAction)onMenu:(id)sender;

@property (weak, nonatomic) IBOutlet UICollectionView *discoverCollectionView;

@end
