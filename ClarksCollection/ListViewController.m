//
//  ListViewController.m
//  ClarksCollection
//
//  Created by Openly on 09/10/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "ListViewController.h"
#import "SWRevealViewController.h"
#import "ItemsinListViewController.h"
#import "AppDelegate.h"
#import "DeleteListViewController.h"
#import "DuplicateListViewController.h"
#import "ExportListViewController.h"
#import "RenameListViewController.h"
#import "MixPanelUtil.h"
#import "ClarksColors.h"
#import "Region.h"
#import "PreloadedListDataSource.h"
#import "AssortmentPlanningListDataSource.h"
#import "API.h"

enum ListType { USER, PRELOADED, ASSORTMENT_PLAN };
@interface ListViewController () {
    enum ListType currentSelectedType;
}

@end

@implementation ListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    [self.editView setHidden:YES ] ;
    self.editView.backgroundColor = [ClarksColors clarkLightGrey] ;
    self.yesBtn.layer.borderColor = [ClarksColors clarksButtonGreen].CGColor ;
    self.yesBtn.layer.borderWidth = 1 ;
    self.maybeLaterbtn.layer.borderWidth = 1 ;
    self.maybeLaterbtn.layer.borderColor = [ClarksColors clarkDarkGrey].CGColor;
    // Do any additional setup after loading the view.
    // Do any additional setup after loading the view.
    _sideBarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    self.staticLable.hidden = YES ;
    self.staticLable.textColor = [ClarksColors clarksMediumGrey];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sideBarButton.target = self.revealViewController;
    _sideBarButton.action = @selector(revealToggle:);
    
    CALayer* layer = [self.staticLable layer];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.borderColor = [ClarksColors clarkDarkGrey].CGColor;
    bottomBorder.borderWidth = 1;
    bottomBorder.frame = CGRectMake(-1, layer.frame.size.height-1, layer.frame.size.width, 1);
    [bottomBorder setBorderColor:[ClarksColors clarkDarkGrey].CGColor];
    [layer addSublayer:bottomBorder];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    
    currentSelectedType = USER;
    
    self.yourListsBtn.layer.borderWidth = 1;
    self.preloadedListsBtn.layer.borderWidth = 1;
    self.assortmentPlanListBtn.layer.borderWidth = 1;
    
    self.yourListsBtn.layer.borderColor = [[ClarksColors clarksButtonGreen] CGColor];
    self.preloadedListsBtn.layer.borderColor = [[ClarksColors clarksButtonGreen] CGColor];
    self.assortmentPlanListBtn.layer.borderColor = [[ClarksColors clarksButtonGreen] CGColor];
    
    [self updateListButtons];
}

- (void) updateListButtons{
    if (currentSelectedType != USER) {
        self.yourListsBtn.backgroundColor = [UIColor whiteColor];
        [self.yourListsBtn setTitleColor:[ClarksColors clarksButtonGreen] forState:UIControlStateNormal];
        [self.yourListsBtn setTitleColor:[ClarksColors clarksButtonGreen] forState:UIControlStateHighlighted];
    }else{
        self.staticLable.hidden = YES ;
        _tableTopConstraint.constant = 51 ;
        self.tableView.dataSource = self.yourListDS;
        self.tableView.delegate = self.yourListDS;
        self.yourListsBtn.backgroundColor = [ClarksColors clarksButtonGreen];
        [self.yourListsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.yourListsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    }
    
    if (currentSelectedType != PRELOADED) {
        self.preloadedListsBtn.backgroundColor = [UIColor whiteColor];
        [self.preloadedListsBtn setTitleColor:[ClarksColors clarksButtonGreen] forState:UIControlStateNormal];
        [self.preloadedListsBtn setTitleColor:[ClarksColors clarksButtonGreen] forState:UIControlStateHighlighted];
    }else{
        self.staticLable.hidden = NO ;
        _tableTopConstraint.constant = 90 ;
        self.tableView.dataSource = self.preloadedListDS;
        self.tableView.delegate = self.preloadedListDS;
        [[MixPanelUtil instance] track:@"preloadedLists"];
        self.preloadedListsBtn.backgroundColor = [ClarksColors clarksButtonGreen];
        [self.preloadedListsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.preloadedListsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    }
    
    if (currentSelectedType != ASSORTMENT_PLAN) {
        self.assortmentPlanListBtn.backgroundColor = [UIColor whiteColor];
        [self.assortmentPlanListBtn setTitleColor:[ClarksColors clarksButtonGreen] forState:UIControlStateNormal];
        [self.assortmentPlanListBtn setTitleColor:[ClarksColors clarksButtonGreen] forState:UIControlStateHighlighted];
    }else{
        self.staticLable.hidden = NO ;
        _tableTopConstraint.constant = 90 ;
        self.tableView.dataSource = self.assortmentPlanningListDS;
        self.tableView.delegate = self.assortmentPlanningListDS;
        [[MixPanelUtil instance] track:@"assortmentPlanningLists"];
        self.assortmentPlanListBtn.backgroundColor = [ClarksColors clarksButtonGreen];
        [self.assortmentPlanListBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.assortmentPlanListBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    }
    [self.tableView reloadData];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    ListViewController *listVC = (ListViewController *)sender;
    UITableViewCell *cell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if([segue.identifier isEqualToString:@"displayListItems"]) {
        
        ItemsInListViewController *itemsInListVC = (ItemsInListViewController *)segue.destinationViewController;
        [[MixPanelUtil instance] track:@"displayList"];
        //[[MixPanelUtil instance] track:@"displayList" args:((NSString *) @"Display list")];
        if (currentSelectedType == USER) {
            [itemsInListVC setListIndex:(int)indexPath.row];
        }else if (currentSelectedType == PRELOADED){
            itemsInListVC.list = [self getList:self.preloadedListDS.list[indexPath.row]];
            itemsInListVC.readOnly = YES;
        }else{
            itemsInListVC.list = [self getList:self.assortmentPlanningListDS.list[indexPath.row]];
            itemsInListVC.readOnly = YES;
        }
        
    }
    if([segue.identifier isEqualToString:@"deleteList"]) {
        DeleteListViewController *deleteListVC = (DeleteListViewController *)segue.destinationViewController;
        deleteListVC.index = listVC.savedListIndex;
        [[MixPanelUtil instance] track:@"deleteList"] ;
    }
    if([segue.identifier isEqualToString:@"duplicateList"]) {
        DuplicateListViewController *duplicateListVC = (DuplicateListViewController *)segue.destinationViewController;
        duplicateListVC.index = listVC.savedListIndex;
        [[MixPanelUtil instance] track:@"duplicateList" ] ;
    }
    if([segue.identifier isEqualToString:@"exportList"]) {
        ExportListViewController *exportListVC = (ExportListViewController *)segue.destinationViewController;
        if (currentSelectedType == USER) {
            exportListVC.index = listVC.savedListIndex;
        }else if (currentSelectedType == PRELOADED){
            exportListVC.list = [self getList:self.preloadedListDS.list[listVC.savedListIndex]];
            exportListVC.index = listVC.savedListIndex ;
        }else{
            exportListVC.list = [self getList:self.assortmentPlanningListDS.list[indexPath.row]];
        }
        [[MixPanelUtil instance] track:@"exportList"];
    }
    if([segue.identifier isEqualToString:@"renameList"]) {
        RenameListViewController *renameListVC = (RenameListViewController *)segue.destinationViewController;
        int listIndex = listVC.savedListIndex ;
        if (currentSelectedType == USER) {
            renameListVC.index = listVC.savedListIndex;
        }else if (currentSelectedType == PRELOADED){
//            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            NSLog(@"This is the index of the list selected: %ld",(long)indexPath.row) ;
            
            Lists *list = [self getList:self.preloadedListDS.list[listIndex]];
            renameListVC.list = list;
            renameListVC.isDuplicate = YES;
//            list.listName = [NSString stringWithFormat:@"Copy of %@", list.listName ];
//            [appDelegate.listofList addObject:list];
//            renameListVC.index = (int)[appDelegate.listofList count] - 1;
        }else{
//            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            Lists *list = [self getList:self.assortmentPlanningListDS.list[listIndex]];
            renameListVC.list = list;
            renameListVC.isDuplicate = YES;
//            list.listName = [NSString stringWithFormat:@"Copy of %@", list.listName ];
//            [appDelegate.listofList addObject:list];
//            renameListVC.index = (int)[appDelegate.listofList count] - 1;
        }
        [[MixPanelUtil instance] track:@"renameList"];
    }
    else if([segue.identifier isEqualToString:@"addToList"]){
        [self.editView setHidden:NO];
    }
}

-(void)actionDelete:(int) listIndex {
    self.savedListIndex = listIndex;
    [self performSegueWithIdentifier:@"deleteList" sender:self];
}

-(void)actionDuplicate:(int) listIndex {
    self.savedListIndex = listIndex;
    [self performSegueWithIdentifier:@"duplicateList" sender:self];
}

-(void)actionExport:(int) listIndex {
    self.savedListIndex = listIndex;
    [self performSegueWithIdentifier:@"exportList" sender:self];
}

-(void)actionRename:(int) listIndex {
    self.savedListIndex = listIndex;
    [self performSegueWithIdentifier:@"renameList" sender:self];
}

-(void)actionAddToList:(int) listIndex {
    self.savedListIndex = listIndex;
    [self.editView setHidden:NO];
    //[self performSegueWithIdentifier:@"addToList" sender:self];
}

- (IBAction)openMenu:(id)sender {
    [self.revealViewController revealToggle:sender];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.selectedMenuIndex = 2;
}

- (IBAction)selectYourList:(id)sender {
    currentSelectedType = USER;
    [self updateListButtons];
}

- (IBAction)selectPreloadedList:(id)sender {
    currentSelectedType = PRELOADED;
    [self updateListButtons];
}

- (IBAction)selectAssPlanList:(id)sender {
    currentSelectedType = ASSORTMENT_PLAN;
    [self updateListButtons];
}
- (Lists *) getList:(NSDictionary *) dict{
    Lists *theList = [[Lists alloc]init];
    theList.listName = [dict valueForKey:@"name"];
    NSArray *cols = [dict valueForKey:@"color_ids"];
    for (NSString *colId in cols) {
        
        NSArray *itemAndCol = [self getItemColor:colId
                                          region:[Region getCurrent] ];
        ListItem *theItem = [[ListItem alloc] initWithItemAndColor:itemAndCol[0]        withColor:itemAndCol[1]];
        
        theItem.collectionName = [NSString stringWithFormat:@"%@ - %@",
                                        itemAndCol[3], itemAndCol[2]];
        [theList addItemColorToList:theItem withPositionCheck:YES];
        
    }
    return theList;
}

- (NSArray *) getItemColor: (NSString *) colorid region:(Region *)region{
    for (Assortment *ass in region.assortments) {
        for (Collection *coll in ass.collections) {
            for (Item *item in coll.items) {
                for (ItemColor *col in item.colors) {
                    if ([col.colorId isEqualToString:colorid]) {
                        return @[ item, col, coll.name, ass.name ];
                    }
                }
            }
        }
    }
    return nil;
}

- (IBAction)didClickLater:(id)sender {
    [self.editView setHidden:YES ] ;
}
- (IBAction)closeBtnClicked:(id)sender {
    [self.editView setHidden:YES ] ;
}
@end
