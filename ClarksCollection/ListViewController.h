//
//  ListViewController.h
//  ClarksCollection
//
//  Created by Openly on 09/10/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PreloadedListDataSource;
@class ListDataSource;
@class AssortmentPlanningListDataSource;

@interface ListViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarButton;
@property (weak, nonatomic) IBOutlet UILabel *staticLable;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnCreateNewList;
@property int savedListIndex;
-(void)actionExport:(int) listIndex;
-(void)actionDelete:(int) listIndex;
-(void)actionDuplicate:(int) listIndex;
@property (strong, nonatomic) IBOutlet PreloadedListDataSource *preloadedListDS;
-(void)actionRename:(int) listIndex;
-(void)actionAddToList:(int) listIndex ;
- (IBAction)openMenu:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *yourListsBtn;
@property (weak, nonatomic) IBOutlet UIButton *preloadedListsBtn;
@property (weak, nonatomic) IBOutlet UIButton *assortmentPlanListBtn;
- (IBAction)selectYourList:(id)sender;
- (IBAction)selectPreloadedList:(id)sender;
- (IBAction)selectAssPlanList:(id)sender;
@property (strong, nonatomic) IBOutlet ListDataSource *yourListDS;
@property (strong, nonatomic) IBOutlet AssortmentPlanningListDataSource *assortmentPlanningListDS;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableTopConstraint;
@property (weak, nonatomic) IBOutlet UIButton *yesBtn;
@property (weak, nonatomic) IBOutlet UIButton *maybeLaterbtn;
- (IBAction)didClickLater:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *editView;
- (IBAction)closeBtnClicked:(id)sender;


@end
