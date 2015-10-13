//
//  MarketingDetailViewController.h
//  ClarksCollection
//
//  Created by Openly on 18/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarketingMaterial.h"
#import "SwipeView.h"

@interface MarketingDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *scrollParentView;
@property (weak, nonatomic) IBOutlet UILabel *heading1;
@property (weak, nonatomic) IBOutlet UILabel *subHeading1;

@property (weak, nonatomic) IBOutlet SwipeView *theSwipeView;
@property (weak, nonatomic) IBOutlet UIScrollView *theScrollView;
@property MarketingMaterial *theMarketingData;;
@end
