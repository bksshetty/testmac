//
//  ItemsInListViewController.h
//  ClarksCollection
//
//  Created by Openly on 05/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lists.h"

@interface ItemsInListViewController : UIViewController
-(void)setListIndex:(int)index;
@property(weak,nonatomic) Lists *list;
@property int listItemIndex;
@property BOOL readOnly;
@property (weak, nonatomic) IBOutlet UICollectionView *gridView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnGridView;
@property (weak, nonatomic) IBOutlet UILabel *lblListTitel;
@property (weak, nonatomic) IBOutlet UIButton *addToListBtn;
@property (weak, nonatomic) IBOutlet UIImageView *lineRRP;
@property (weak, nonatomic) IBOutlet UIImageView *lineWholesale;

@property (weak, nonatomic) IBOutlet UIButton *btnTableView;

- (IBAction)onGridView:(id)sender;
- (IBAction)onTableView:(id)sender;

@end
