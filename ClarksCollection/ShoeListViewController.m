		//
//  ShoeListViewController.m
//  ClarksCollection
//
//  Created by Openly on 01/10/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "ShoeListViewController.h"
#import "SWRevealViewController.h"
#import "ClarksFonts.h"
#import "ClarksColors.h"
#import "AppDelegate.h"
#import "SingleShoeViewController.h"
#import "ListItem.h"
#import "ItemsinListViewController.h"
#import "ClarksUI.h"
#import "Filters.h"
#import "MixPanelUtil.h"


@interface ShoeListViewController (){
    NSArray *selectedCollections;
    BOOL isSlidePanelOpen;
}

@end

@implementation ShoeListViewController

#pragma mark - Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isSlidePanelOpen = NO;
        // Custom initialization
    }
    return self;
}


- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        isSlidePanelOpen = NO;
    }
    return self;
}


- (IBAction)openMenu:(id)sender {
    [self closeLeftSlideOut:sender];
    [self.revealViewController revealToggle:sender];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.selectedMenuIndex = 1;
}

#pragma mark - Search

- (IBAction)onSearch:(id)sender {
    [self closeLeftSlideOut:sender];
    [self.searchView setHidden:NO];
    [self.topBarView setHidden:YES];
    [self.filterView setHidden:YES];
}

- (IBAction)performSearch:(id)sender {
    [self searchHelper:self.txtSearch.text];
}


-(void) unRepositionSearchViewButtons {
    CGRect f = self.lblSearch.frame;
    [ClarksUI reposition:self.lblSearch x:f.origin.x y:189];
    
    f = self.txtSearch.frame;
    [ClarksUI reposition:self.txtSearch x:f.origin.x y:287];
    
    f = self.btnSearchViewSearch.frame;
    [ClarksUI reposition:self.btnSearchViewSearch x:f.origin.x y:364];
    
}

-(void) repositionSearchViewButtons {
    
    CGRect f = self.lblSearch.frame;
    [ClarksUI reposition:self.lblSearch x:f.origin.x y:189-100];
    
    f = self.txtSearch.frame;
    [ClarksUI reposition:self.txtSearch x:f.origin.x y:287-100];
    
    f = self.btnSearchViewSearch.frame;
    [ClarksUI reposition:self.btnSearchViewSearch x:f .origin.x y:264];
    
}

-(void)searchHelper:(NSString *)searchString
{
    self.shoeListDS.searchTerm = searchString;
    NSLog(@"The search term is %@",self.shoeListDS.searchTerm);
    [self.shoeListDS setupFilterArray];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[MixPanelUtil instance] track:@"search"];
    if([appDelegate.filtereditemArray count] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Search"
                                                        message:@"No results found."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [self.shoeListCollectionView reloadData];
    // Reload the filter table
    [self.filterTable reloadData];
    
    [self.txtSearch resignFirstResponder];
    [self.searchView setHidden:YES];
    [self.topBarView setHidden:NO];
}

- (IBAction)closeSearchView:(id)sender {
    [self.txtSearch setText:@""];
    [self searchHelper:@""];
}

#pragma mark - Filter

- (IBAction)onCloseFilter:(id)sender {
    [self.filterView setHidden:YES];
    [self.topBarView setHidden:NO];
}

- (IBAction)onFilterClearAll:(id)sender {
    self.txtSearch.text= @"";
    [self.shoeListDS resetFilterArrayFromFilterList];
    [self.filterTable reloadData];
    [self.shoeListCollectionView reloadData];
}

- (IBAction)onFilter:(id)sender {
    
    //self.filterDS.
    [self closeLeftSlideOut:sender];
    [self.filterView setHidden:NO];
    self.btnApply.backgroundColor = [ClarksColors clarksButtonGreen];
    self.btnApply.titleLabel.font = [ClarksFonts clarksSansProRegular:12.0f];
    self.btnClearAll.titleLabel.font = [ClarksFonts clarksSansProRegular:12.0f];
}

- (IBAction)onFilterApply:(id)sender {
    NSArray *selectedFilters = [self.filterTable indexPathsForSelectedRows];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[MixPanelUtil instance] track:@"filter"];
    if(selectedFilters == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No filter selected"
                                                        message:@"No filter selected to proceed."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    self.txtSearch.text= @"";
    
    NSMutableDictionary *appliedFilters = [[NSMutableDictionary alloc] init];
    
    for (NSIndexPath *thisPath in selectedFilters) {
        NSString *sectionStr = [NSString stringWithFormat:@"%ld",(long)thisPath.section ];
        NSString *predicate = [[self.filterDS.filters[thisPath.section] valueForKey:@"options"][thisPath.row] valueForKey:@"query"];
        if ([appliedFilters valueForKey: sectionStr] != nil) {
            [[appliedFilters valueForKey: sectionStr] addObject: predicate];
        }else{
            NSMutableArray *sectOpts = [[NSMutableArray alloc] init];
            [sectOpts addObject:predicate];
            [appliedFilters setObject:sectOpts forKey:sectionStr];
        }
    }
    self.shoeListDS.filters = appliedFilters;
    [self.shoeListDS setupFilterArrayFromFilterList];
    if([appDelegate.filtereditemArray count] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Filter"
                                                        message:@"No results found for your filter criteria."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [self.shoeListDS resetFilterArrayFromFilterList];
        [alert show];
        return;
    }
    
    [self.filterView setHidden:YES];
    [self.shoeListCollectionView reloadData];
}

#pragma mark - List

- (IBAction)onListClearAll:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Lists *curList = appDelegate.activeList;
    
    [curList emptyList];
    [self.listItemDS setUpEmptyData];
    [self updateListViewListNameLabel];
    for(Item *theItem in appDelegate.filtereditemArray)
        [theItem markItemAsDeselected];
    
    [appDelegate saveList];
    [self.shoeListCollectionView reloadData];
    [self.listTable reloadData];

}

- (IBAction)onPerformCreateNewList:(id)sender {
    NSString *newListName = [self.txtNewList.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self.view endEditing:YES];
    [self.txtNewList resignFirstResponder];
    BOOL uniqueListName = YES;
    for(Lists *theList in appDelegate.listofList) {
        if([theList.listName isEqualToString:newListName]) {
            uniqueListName = NO;
            break;
        }
    }
    
    if(uniqueListName == NO){
        NSString *message= [NSString stringWithFormat:@"%@ already exits",newListName];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Already exists"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [self hideAllSlideOutViews];

    Lists *newList = [[Lists alloc]init];
    newList.listName = newListName;
    
    if(self.tmpItem != nil) { // We had a parked item to add
        [newList addItemToList:self.tmpItem];
        self.tmpItem = nil;
    }
    
    // add the currlist to the listofLists and mark the list as active
    [appDelegate.listofList addObject:newList];
    [appDelegate markListAsActive:newList];
    [appDelegate saveList];

    // reload the collection view to show the selected state
    [self.shoeListCollectionView reloadData];
    [self updateListViewListNameLabel];

    // Now show the list view
   [self showListView];
    
}

- (IBAction)goBackToListInShoeList:(id)sender{
    [self hideAllSlideOutViews];
    [self showListView];
}

- (IBAction)onChangeList:(id)sender {
    [self onOpenAList:sender];
}

- (IBAction)onOpenAList:(id)sender {
    [self hideAllSlideOutViews];
    [self slideOutCollectionView];
    self.selectListView.hidden = NO;
    [self.itemListTableView reloadData];
}

- (IBAction)onCollectionChange:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onCreateNewList:(id)sender {
    [self hideAllSlideOutViews];
    self.txtNewList.text = @"";
    self.theNewListView.hidden = NO;
}

-(void)updateListTable {
    [self updateListViewListNameLabel];
    [self.listItemDS setUpData];
    if(self.itemListView.hidden)
        return;
   [self.listTable reloadData];
}


- (IBAction)onEditingBegin:(id)sender {
    [self repositionNewListViewButtons];
    
}

- (IBAction)onEditingEnded:(id)sender {
    [self unRepositionNewListViewButtons];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
   [self repositionSearchViewButtons ];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self unRepositionSearchViewButtons] ;
}

- (IBAction)closeLeftSlideOut:(id)sender {
    [self slideBackInCollectionView];
    [self hideAllSlideOutViews];
    self.tmpItem = nil;
}


-(void)setupCollections:(NSArray *)collections {
    selectedCollections = collections;
    [self.shoeListDS setupCollections:collections];
    //save the item list in the App 
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.itemList = self.shoeListDS.itemArray;
    NSArray *filters = [Filters filtersForCollections:selectedCollections];
    [self.filterDS setFilters:filters];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.shoeListDS.itemArray = appDelegate.itemList;
    
    //setup for the filter Data source
   
    
    [self.txtSearch addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    self.backFromListChange.hidden = YES;
    [self listViewUIHelper];
    [self newListUIHelper];
    [self selectAListUIHelper];
    [self createListUIHelper];
    [self closeButtonUIHelper];
}

// Since we have a responded the value changed event gets fired only when responder is dismissed; hence need to do it manually
-(void)textChanged:(UITextField *)textField
{
    if([self.txtSearch.text length] > 0)
        self.btnSearchViewSearch.enabled = YES;
    else
        self.btnSearchViewSearch.enabled = NO;
}
-(void) hideAllSlideOutViews {
    [self.shoeListCollectionView setUserInteractionEnabled:YES];
    self.itemListView.hidden = YES;
    self.saveListView.hidden = YES;
    self.selectListView.hidden = YES;
    self.theNewListView.hidden = YES;
    self.searchView.hidden = YES;
    isSlidePanelOpen = NO;
}

-(void) viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
        
    // Set the gesture
    self.btnChange.titleLabel.font = [ClarksFonts clarksSansProLight:12.0f];
    NSString *changBtnTitle =[NSString stringWithFormat:@"%@ - CHANGE",[self.shoeListDS.titleLable uppercaseString]];
    
    [self.btnChange setTitle:changBtnTitle forState:UIControlStateNormal];
    [self.btnChange setTitle:changBtnTitle forState:UIControlStateHighlighted];
    [self.btnSearch.titleLabel setFont: [ClarksFonts clarksSansProLight:12.0f]];
    
    self.lblSearch.font =[ClarksFonts clarksSansProThin:40.0f];
    self.txtSearch.font = [ClarksFonts clarksSansProThin:40.0f];
    self.btnTopBarFilter.titleLabel.font = [ClarksFonts clarksSansProLight:12.0f];
    self.btnFilterViewFilter.titleLabel.font =[ClarksFonts clarksSansProLight:12.0f];

    self.txtSearch.delegate = self;
    self.txtNewList.delegate = self;

    self.itemListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
   
    // Do any additional setup after loading the view.
    _sideBarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sideBarButton.target = self.revealViewController;
    _sideBarButton.action = @selector(revealToggle:);
    
    // enabling the button at the start
    if([self.txtSearch.text length] > 0)
        self.btnSearchViewSearch.enabled = YES;
    else
        self.btnSearchViewSearch.enabled = NO;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Lists *activeList = appDelegate.activeList;
    
    if(activeList != nil) {
        // Unhide them just in case they were hidden
        self.btnNavBarList.hidden = NO;
  
        NSString *strCurrListName =activeList.listName;
        NSString *title = [NSString stringWithFormat:@"%@ (%d)",strCurrListName, [activeList noOfItemsInList:strCurrListName]];
        [self.btnNavBarList setTitle:title forState:UIControlStateNormal];
        [self.btnNavBarList setTitle:title forState:UIControlStateHighlighted];
        [self.btnNavBarList setTitle:title forState:UIControlStateSelected];
    }else { //Hide the name
        self.btnNavBarList.hidden = YES;
   }
    [self.listItemDS setUpData];
    [self.listTable reloadData];
    [self.shoeListCollectionView reloadData];
}

-(void) addItemToActiveList:(Item *)theItem {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Lists *activeList = appDelegate.activeList;
    
    if(activeList != nil) {
        [activeList addItemToList:theItem];
        [appDelegate saveList];
    }
}

-(void) removeItemFromActiveList:(Item *)theItem {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Lists *activeList = appDelegate.activeList;
    if(activeList == nil)
        return;
    
    [activeList deleteItemFromList:theItem];
    [appDelegate saveList];
    return;
}

-(void) performNoActiveList {
    [self.shoeListCollectionView setUserInteractionEnabled:NO];
    
    
    [self onOpenAList:nil];
    return;
}

-(BOOL) isActiveList {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Lists *activeList = appDelegate.activeList;
    
    if(activeList != nil)
        return YES;
    
    return NO;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(self.searchView.hidden == NO)
        [self performSearch:self];
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)onListName:(id)sender {
    [self onShowListSlideOut:sender];
}

- (IBAction)onShowCreateSelectNewList:(id)sender {
    // slide the frame left if Open else close
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Lists *activeList = appDelegate.activeList;
    if(activeList == nil) {
        [self onOpenAList:sender];
    }
    else {
        [self onShowListSlideOut:sender];
    }
}

- (IBAction)onShowListSlideOut:(id)sender {
    if(isSlidePanelOpen) {
        [self closeLeftSlideOut:sender];
        isSlidePanelOpen = NO;
        return;
    }
    [self hideAllSlideOutViews];
    [self slideOutCollectionView];
    self.itemListView.hidden = NO;
    [self.listItemDS setUpData];
    [self.listTable reloadData];
    [self updateListViewListNameLabel];
    self.backFromListChange.hidden = NO;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if([segue.identifier isEqualToString:@"shoeDetail"]) {

        UICollectionViewCell *cell = sender;
        NSIndexPath *indexPath = [self.shoeListCollectionView indexPathForCell:cell];
        SingleShoeViewController *ssvc = (SingleShoeViewController *) segue.destinationViewController;
        [[MixPanelUtil instance] track:@"shoe_selected"];
        [ssvc setItem: appDelegate.filtereditemArray[(int)indexPath.row] withColorIndex:0];
    }
    if([segue.identifier isEqualToString:@"viewList"]) {
        ItemsInListViewController *itemsInListVC = (ItemsInListViewController *)segue.destinationViewController;
        int index = (int)[appDelegate.listofList indexOfObject:appDelegate.activeList];
        [self.shoeListCollectionView setUserInteractionEnabled:YES];
        [itemsInListVC setListIndex:index];
     }
}


-(void) closeButtonUIHelper {
    self.btnCloseItemList.titleLabel.font =[ClarksFonts clarksSansProRegular:12.0f];
    self.btnCloseNewListView.titleLabel.font =[ClarksFonts clarksSansProRegular:12.0f];
    self.btnCloseSelectList .titleLabel.font =[ClarksFonts clarksSansProRegular:12.0f];
    self.btnCloseSaveList.titleLabel.font =[ClarksFonts clarksSansProRegular:12.0f];
}

-(void) listViewUIHelper{
    // items in the navigation bar

    self.viewListItem.titleLabel.font =[ClarksFonts clarksSansProRegular:12.0f];
    self.lblActiveList.font =[ClarksFonts clarksSansProRegular:9.0f];
    self.lblListName.font = [ClarksFonts clarksSansProThin:20.0f];
    self.btnListChange.titleLabel.font = [ClarksFonts clarksSansProRegular:9.0];
    
    self.noListLbl1.font =[ClarksFonts clarksSansProThin:20.0f];
    self.noListlbl2.font =[ClarksFonts clarksSansProLight:16.0f];
}

-(void) newListUIHelper{
    self.nnewListlbl1.font = [ClarksFonts clarksSansProThin:20.0f];
    self.nnewListlbl2.font = [ClarksFonts clarksSansProLight:16.0f];
    self.nnewListlbl3.font = [ClarksFonts clarksSansProThin:20.0f];
    self.nnewListlbl4.font = [ClarksFonts clarksSansProLight:16.0f];
    self.nnewListbtn1.titleLabel.font = [ClarksFonts clarksSansProRegular:12.0f];
    self.nnewListbtn2.titleLabel.font = [ClarksFonts clarksSansProRegular:12.0f];
}

-(void) selectAListUIHelper{
    self.lblYourList.font = [ClarksFonts clarksSansProRegular:9.0f];
    self.lblSelectAListTo.font = [ClarksFonts clarksSansProThin:20.0f];
}

-(void)createListUIHelper {
    self.lblCreateANewList.font = [ClarksFonts clarksSansProThin:20.0f];
    self.txtNewList.layer.borderWidth = 1.0f;
    self.txtNewList.layer.borderColor = [[ClarksColors clarksMenuButtonGreen1Alpha]CGColor];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, self.txtNewList.frame.size.height)];
    leftView.backgroundColor = self.txtNewList.backgroundColor;
    
    self.txtNewList.leftView = leftView;
    self.txtNewList.leftViewMode = UITextFieldViewModeAlways;
    
    self.txtNewList.font = [ClarksFonts clarksSansProLight:16.0f];
    
    self.btnCreateNewList.titleLabel.font = [ClarksFonts clarksSansProRegular:12.0f];
}

-(void) unRepositionNewListViewButtons {
    CGRect f = self.lblCreateANewList.frame;
    [ClarksUI reposition:self.lblCreateANewList x:f.origin.x y:189];

    f = self.txtNewList.frame;
    [ClarksUI reposition:self.txtNewList x:f.origin.x y:287];

    f = self.btnCreateNewList.frame;
    [ClarksUI reposition:self.btnCreateNewList x:f.origin.x y:364];
  
}

-(void) repositionNewListViewButtons {
    
    CGRect f = self.lblCreateANewList.frame;
    [ClarksUI reposition:self.lblCreateANewList x:f.origin.x y:189-100];
    
    f = self.txtNewList.frame;
    [ClarksUI reposition:self.txtNewList x:f.origin.x y:287-100];
    
    f = self.btnCreateNewList.frame;
    [ClarksUI reposition:self.btnCreateNewList x:f.origin.x y:364-100];

}


-(void) deleteCollectionViewChecks:(NSString *)itemName{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    for(Item *theItem in appDelegate.filtereditemArray) {
        if([theItem.name isEqualToString:itemName]) {
            [theItem markItemAsDeselected];
            [self.shoeListCollectionView reloadData];
            return;
        }
    }
}

-(void) slideOutCollectionView{
    isSlidePanelOpen = YES;
    [ClarksUI setWidth:self.shoeListCollectionView width:710];
}

-(void) slideBackInCollectionView{
    isSlidePanelOpen = NO;
    [ClarksUI setWidth:self.shoeListCollectionView width:1024];
}

-(void) updateListViewListNameLabel {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Lists *curList = appDelegate.activeList;
    int count = (int)[curList.listOfItems count] ;
    NSString *strFullString = [NSString stringWithFormat:@"%@ (%d)  ", curList.listName, count];
    NSMutableAttributedString *lblTitle = [[NSMutableAttributedString alloc] initWithString:strFullString];
    
    [lblTitle addAttribute:NSFontAttributeName
                     value:[ClarksFonts clarksSansProThin:20.0f]
                     range:NSMakeRange(0, [curList.listName length]) ];
    
    [lblTitle addAttribute:NSFontAttributeName
                     value:[ClarksFonts clarksSansProThin:12.0f]
                     range:NSMakeRange([curList.listName length]+1, 5 ) ];
    
    [lblTitle addAttribute:NSForegroundColorAttributeName
                     value:[ClarksColors clarksButtonGreen]
                     range:NSMakeRange([curList.listName length]+1, 5) ];
    
    self.lblListName.attributedText = lblTitle;
    self.btnNavBarList.hidden = NO;
    NSString *title = [NSString stringWithFormat:@"%@ (%lu)",curList.listName, (long)curList.listOfItems.count];
    [self.btnNavBarList setTitle:title forState: UIControlStateNormal];
    [self.btnNavBarList setTitle:title forState: UIControlStateHighlighted];
    [self.btnNavBarList setTitle:title forState: UIControlStateSelected];
    
    if(count <=0)
    {
        self.noListView.hidden = NO;
        self.listTable.hidden = YES;
        self.btnListClearAll.hidden = YES;
    }
    else
    {
        self.noListView.hidden = YES;
        self.listTable.hidden = NO;
        self.btnListClearAll.hidden=NO;
    }
    
}
-(void) showListView{
    
    // add the selected items in collection grid to the list
    [self slideOutCollectionView];
    self.backFromListChange.hidden = NO ;
    self.itemListView.hidden = NO;
    
    [self.listItemDS setUpData];
    [self.listTable reloadData];
    [self.shoeListCollectionView reloadData];
    [self updateListViewListNameLabel];
}


-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self slideBackInCollectionView];
    [self hideAllSlideOutViews];
}
@end
