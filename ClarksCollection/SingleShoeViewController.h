//
//  SingleShoeViewController.h
//  ClarksCollection
//
//  Created by Openly on 15/10/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"
#import "ItemColor.h"
#import "SingleShoeDataSource.h"
#import "ManagedImage.h"
#import "SwipeView.h"
#import "SaveList.h"
#import "SelectList.h"
#import "TheNewListView.h"
#import "ItemList.h"
#import "ListItemDataSource.h"

@interface SingleShoeViewController : UIViewController <SwipeViewDataSource, SwipeViewDelegate, UITextFieldDelegate>{
    Item *theItem;
}
@property ItemColor* tmpColor;
@property (weak, nonatomic) IBOutlet UITableView *shoeColorLTableView;
-(void) setItem: (Item *) item withColorIndex:(int) withColorIndex;
@property (weak, nonatomic) IBOutlet UILabel *shoeName;
@property (strong, nonatomic) IBOutlet UILabel *colorName;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTxt;

@property (weak, nonatomic) IBOutlet UIImageView *btnGA;
@property (weak, nonatomic) IBOutlet UIImageView *btnF;
@property (weak, nonatomic) IBOutlet UIButton *btnCollection;

@property (weak, nonatomic) IBOutlet UIImageView *collectionImage;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet SingleShoeDataSource *colorDS;
@property (weak, nonatomic) IBOutlet SwipeView *swipeview;
@property (weak, nonatomic) IBOutlet UIButton *view360Btn;

@property (weak, nonatomic) IBOutlet UIImageView *viewForTech;

@property (weak, nonatomic) IBOutlet UIButton *btnNavBarList;

-(void) setColor: (int) idx;
-(BOOL) isActiveList;
-(void) addItemColorToActiveList:(ItemColor *)theColor;
-(void) removeItemColorFromActiveList:(ItemColor *)theColor;

// All the slide out view
@property (weak, nonatomic) IBOutlet ItemList *itemListView;
@property (weak, nonatomic) IBOutlet SaveList *saveListView;
@property (weak, nonatomic) IBOutlet SelectList *selectListView;
@property (weak, nonatomic) IBOutlet TheNewListView *theNewListView;
@property (weak, nonatomic) IBOutlet UIView *shoeListCollectionView;
@property (weak, nonatomic) IBOutlet UIView *noListView;

// List View
@property (weak, nonatomic) IBOutlet UILabel *lblActiveList;
@property (weak, nonatomic) IBOutlet UIButton *btnListChange;
@property (weak, nonatomic) IBOutlet UILabel *lblListName;
@property (weak, nonatomic) IBOutlet UIButton *btnListClearAll;
- (IBAction)onListClearAll:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *noListLbl1;
@property (weak, nonatomic) IBOutlet UILabel *noListlbl2;
@property (weak, nonatomic) IBOutlet UIButton *viewListItem;
@property (weak, nonatomic) IBOutlet UITableView *itemListTableView;
@property (weak, nonatomic) IBOutlet UITableView *listTable;
@property (strong, nonatomic) IBOutlet ListItemDataSource *listItemDS;
- (IBAction)onChangeList:(id)sender;
- (IBAction)backFromChange:(UIButton *)sender ;

// Save List
@property (weak, nonatomic) IBOutlet UILabel *nnewListlbl1;
@property (weak, nonatomic) IBOutlet UILabel *nnewListlbl4;

@property (weak, nonatomic) IBOutlet UILabel *nnewListlbl2;
@property (weak, nonatomic) IBOutlet UILabel *nnewListlbl3;
@property (weak, nonatomic) IBOutlet UIButton *nnewListbtn1;
@property (weak, nonatomic) IBOutlet UIButton *nnewListbtn2;
- (IBAction)onOpenAList:(id)sender;
- (IBAction)onCreateNewList:(id)sender;


// New List
@property (weak, nonatomic) IBOutlet UILabel *lblCreateANewList;
@property (weak, nonatomic) IBOutlet UIButton *btnCreateNewList;
@property (weak, nonatomic) IBOutlet UITextField *txtNewList;
- (IBAction)onPerformCreateNewList:(id)sender;
- (IBAction)onEditingBeing:(id)sender;
- (IBAction)onEditingEnded:(id)sender;

//Select list
@property (weak, nonatomic) IBOutlet UILabel *lblYourList;
@property (weak, nonatomic) IBOutlet UILabel *lblSelectAListTo;
@property (weak, nonatomic) IBOutlet UIButton *backFromListSelect;

//Close buttons
@property (weak, nonatomic) IBOutlet UIButton *btnCloseSaveList;
@property (weak, nonatomic) IBOutlet UIButton *btnCloseNewListView;
@property (weak, nonatomic) IBOutlet UIButton *btnCloseSelectList;
@property (weak, nonatomic) IBOutlet UIButton *btnCloseItemList;
- (IBAction)closeLeftSlideOut:(id)sender;

//Navigation
- (IBAction)onShowListSlideout:(id)sender;
- (IBAction)onShowCreateSelectNewList:(id)sender;

-(void) performNoActiveList;
-(void) updateListTable;
-(void) updateListViewListNameLabel;
-(void) showListView;
- (void)onTechClick:(UIButton *)btn;
@end
