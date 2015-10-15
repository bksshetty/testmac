//
//  MarketingViewController.h
//  ClarksCollection
//
//  Created by Openly on 17/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MarketingViewController : UIViewController
- (IBAction)onMenu:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property NSMutableArray* btnArray ;
@property (weak, nonatomic) IBOutlet UICollectionView *marketingCollectionView;
@property (strong,nonatomic)   NSArray *marketingCategory;
@property int index;
-(void)createBtn : (NSString *)btnName i:(float *)cnt tag:(int)t ;

@end
