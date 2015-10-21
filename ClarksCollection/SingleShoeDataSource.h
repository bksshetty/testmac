//
//  SingleShoeDataSource.h
//  ClarksCollection
//
//  Created by Openly on 15/10/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"
#import "ManagedImage.h"

@class SingleShoeViewController;

@interface SingleShoeDataSource : NSObject<UITableViewDataSource, UITableViewDelegate>
@property Item *item;
@property NSInteger selectedRow;
@property NSInteger detailsRow;
@property (weak, nonatomic) IBOutlet SingleShoeViewController *parentViewController;
@property int fullHeight ;


-(UIImageView *) horizontalLines : (int)x yValue:(int)y ;
-(void) showDetails:(int) index tableView:(UITableView *) tableView;
-(void) selectColorAtIndex: (int) index tableView:(UITableView *) tableView;
- (UILabel *) createLeftLabels: (NSString *)name yValue:(int)y;
- (UILabel *) createRightLabels: (NSString *)name ;
- (UILabel *) createLeftValueLabels: (NSString *)name yValue:(int)y;
@end
