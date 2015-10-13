//
//  DiscoverCollectionDetailViewController.h
//  ClarksCollection
//
//  Created by Openly on 17/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscoverCollectionDetailViewController : UIViewController
@property NSString * assortmentName;
@property NSString * collectionName;
- (IBAction)viewTheColl:(id)sender;

-(void)setDetailImages:(NSArray *)theImages;
-(void) setupTransitionFromShoeDetail:(NSString *)theCollectionName;

@end
