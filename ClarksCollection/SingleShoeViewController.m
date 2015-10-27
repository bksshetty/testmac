//
//  SingleShoeViewController.m
//  ClarksCollection
//
//  Created by Openly on 15/10/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "SingleShoeViewController.h"
#import "ClarksFonts.h"
#import "ClarksColors.h"
#import "ManagedImage.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "ItemsInListViewController.h"
#import "ClarksUI.h"
#import "DiscoverCollectionDetailViewController.h"
#import "Image360ViewController.h"
#import "UILabel+dynamicSizeMe.h"
#import "MarketingMaterial.h"
#import "MarketingCategory.h"
#import "MarketingDetailViewController.h"
#import "MixPanelUtil.h"
#import "ImageDownloader.h"
#import "DataReader.h"



@interface SingleShoeViewController (){
    bool viewLoaded;
    ItemColor *curColor;
    int curColorIdx;
    BOOL isSlidePanelOpen;
    BOOL bFirstTime;
    int i ;
}

@end

@implementation SingleShoeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        viewLoaded = false;
        isSlidePanelOpen = NO;
        bFirstTime = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    viewLoaded = true;
    [self displayItem];
    self.backFromListSelect.hidden = YES;
    NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[ClarksFonts clarksSansProLight:20.0f],NSFontAttributeName, nil];
  
    self.navigationController.navigationBar.titleTextAttributes = size;
    
    self.shoeName.font = [ClarksFonts clarksNarzissMediumBd:30.0f];
    self.descriptionTxt.font = [ClarksFonts clarksSansProLight:16.0f];
    self.colorName.font = [ClarksFonts clarksSansProRegular:9.0f];
    // Do any additional setup after loading the view.
    self.pageControl.currentPageIndicatorTintColor = [ClarksColors clarksMenuButtonGreen1Alpha];
    self.pageControl.pageIndicatorTintColor = [ClarksColors clarkDarkGrey];
    self.shoeColorLTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self updateBarButton];
    
    [self listViewUIHelper];
    [self newListUIHelper];
    [self selectAListUIHelper];
    [self createListUIHelper];
    [self closeButtonUIHelper];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self slideBackInCollectionView];
    [self hideAllSlideOutViews];
}

-(BOOL) isActiveList {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Lists *activeList = appDelegate.activeList;
    
    if(activeList != nil)
        return YES;
    
    return NO;
    
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.txtNewList.delegate = self;
    
    self.itemListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Lists *activeList = appDelegate.activeList;
    self.navigationItem.title = theItem.name;
    self.descriptionTxt.text = curColor.material;
    self.btnListChange.hidden = NO ;
    if(activeList != nil) {
        // Unhide them just in case they were hidden
    
        self.btnNavBarList.hidden = YES;
        
        NSString *strCurrListName =activeList.listName;
        NSString *title = [NSString stringWithFormat:@"%@ (%d)",strCurrListName, [activeList noOfItemsInList:strCurrListName]];
        [self.btnNavBarList setTitle:title forState:UIControlStateNormal];
        [self.btnNavBarList setTitle:title forState:UIControlStateHighlighted];
        [self.btnNavBarList setTitle:title forState:UIControlStateSelected];
    }else { //Hide the name
        self.btnNavBarList.hidden = YES;
    }
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
- (void) setItem:(Item *)item withColorIndex:(int)index{
    theItem = item;
    if (index >= [theItem.colors count]) {
        NSLog(@"Trying to set invalid color index for item %@", theItem.name);
        return;
    }
    curColor = theItem.colors[index];
    curColorIdx = index;
    [self displayItem];
}

- (void) displayItem{
    if (viewLoaded && theItem != nil) {
        self.shoeName.text = theItem.name;
        self.title = theItem.name;
        
        [self.colorName setFont:[ClarksFonts clarksSansProRegular:9.0f]];
        self.colorName.text = [curColor.name uppercaseString];
        if (bFirstTime) {
            self.descriptionTxt.hidden = YES;
            bFirstTime = NO;
        } else {
            self.descriptionTxt.hidden = NO;
        }
        self.descriptionTxt.text = curColor.material;

        self.colorDS.item = theItem;
        NSDictionary *data = [DataReader read];
        NSDictionary *col_logos = [data valueForKey:@"collection_logos"];
        NSLog(@"Collection Name: %@",theItem.collectionName);
        NSDictionary *col_logos_obj = [col_logos valueForKey:theItem.collectionName ];
        if(col_logos_obj == nil){
            [self.btnCollection setEnabled:NO];
        }else{
            [self.btnCollection setEnabled:YES];
        }
        NSString *col_logos_url = [col_logos_obj valueForKey:@"logo"];
        
        [[ImageDownloader instance] priorityDownload:col_logos_url onComplete:^(NSData *theData) {
            UIImage *collectionImage = [UIImage imageWithData:theData];
            self.collectionImage.image = collectionImage;
            [self.btnCollection setImage:collectionImage forState:UIControlStateNormal];
            [self.btnCollection setImage:collectionImage forState:UIControlStateSelected];
        }] ;
        
//        UIImage *collectionImage =[UIImage imageNamed:[NSString stringWithFormat:@"%@-black.png", [theItem.collectionName lowercaseString]]];
//        
//        self.collectionImage.image = collectionImage;
//        [self.btnCollection setImage:collectionImage forState:UIControlStateNormal];
//        [self.btnCollection setImage:collectionImage forState:UIControlStateSelected];
        [[MixPanelUtil instance] track:@"details"];
        
        
        [self.btnF setHidden: !theItem.isFeatured];
        [self.btnGA setHidden: !theItem.isGA];
        i=0 ;
        //y= 0;
        float startLocX = 0;
        if(theItem.technologies != nil) {
            if([theItem.technologies count] >0) {
                for (NSString *tech in theItem.technologies) {
                    
                    
                    
                    NSString *imgName = [NSString stringWithFormat:@"%@",[tech stringByReplacingOccurrencesOfString:@" " withString:@"-"]];
                    imgName = [imgName lowercaseString];
                    
                    
                    NSDictionary *techLogos = [data valueForKey:@"technologies"];
                    NSDictionary *techLogoObjs  = [techLogos valueForKey:imgName];
                    NSString *techLogos_urls = [techLogoObjs valueForKey:@"logo"];
                    
                    
                    [[ImageDownloader instance] priorityDownload:techLogos_urls onComplete:^(NSData *theData) {
                        UIImage *img = [UIImage imageWithData:theData];
                        CGFloat width = img.size.width / 2;
                        CGFloat height = img.size.height/2;
                        
                        if(img.size.width > 150) {
                            width = img.size.width / 4;
                            height = img.size.height/4;
                        }
                        if(img.size.width > 300) {
                            width = img.size.width / 8;
                            height = img.size.height/8;
                        }
                        // y = y + height  ;
                        CGRect f = CGRectMake(startLocX, 270 - (58 * i++), width , height );
                        
                        UIButton *techImg = [[UIButton alloc] initWithFrame:f];
                        
                        [techImg setImage:img forState:UIControlStateNormal];
                        [techImg setTitle:[techLogoObjs valueForKey:@"story_name"] forState:UIControlStateNormal];
                        [techImg addTarget:self action:@selector(onTechClick:) forControlEvents:UIControlEventTouchUpInside];
                        techImg.adjustsImageWhenHighlighted = NO;
                        
                        [self.viewForTech addSubview:techImg];
                        [self.viewForTech bringSubviewToFront:techImg];
                        self.viewForTech.contentMode = UIViewContentModeScaleAspectFit ;
                        //[self.viewForTech setClipsToBounds:YES];
                    }] ;
                    
                    
                }
            }
        }
        
        [self.swipeview reloadData];
        self.swipeview.bounces = NO;
        [self.view360Btn setHidden:[curColor.images360 count] <= 0];
        [self.shoeColorLTableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:curColorIdx inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self.colorDS selectColorAtIndex:curColorIdx tableView:self.shoeColorLTableView];
    }
}
- (void)onTechClick:(UIButton *)btn{

    NSLog(@"Control is coming here!!!");
    NSString *curTech = [[btn titleForState:UIControlStateNormal] lowercaseString];
    NSArray *categories = [MarketingCategory loadAll];
    
    for (MarketingCategory *cat in categories) {
        if ([cat.name isEqualToString:@"Inside Stories"]) {
            for (MarketingMaterial *mat in cat.marketingMaterials) {
                if ([[mat.name lowercaseString] isEqualToString:curTech]) {
                    MarketingDetailViewController *mdvc = [self.storyboard instantiateViewControllerWithIdentifier:@"marketing_detail"];
                    [[MixPanelUtil instance] track:@"tech_logo_clicked" args:((NSString *) @"Technology Logo Clicked")];
                    mdvc.theMarketingData = mat;
                    [self.navigationController pushViewController:mdvc animated:NO];
                    return;
                }
            }
            return;
        }
    }
}

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView{
    return [curColor.largeImages count];
}


- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{    
    if (view == nil) {
        CGRect frame = CGRectMake(0, 0, 470, 400);
        view = [[ManagedImage alloc] initWithFrame: frame];
        self.pageControl.numberOfPages = [curColor.largeImages count];
    }
    ((ManagedImage *)view).image = [UIImage imageNamed:@"translucent"];
    [((ManagedImage *)view) loadImage:curColor.largeImages[index]];
    ((ManagedImage *)view).contentMode = UIViewContentModeScaleAspectFit;

    return view;
}


- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView
{
    int index=(int)swipeView.currentItemIndex;
    self.pageControl.currentPage = index;
}

- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index{
    ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"image_zoom"];
    [[MixPanelUtil instance] track:@"zoomImage"];
    [self.navigationController pushViewController:vc animated:YES];
    [vc setColor:curColor andImgIdx:(int)index];
}

-(void) setColor: (int) idx{
    if (idx >= [theItem.colors count]) {
        NSLog(@"Trying to set invalid color index for item %@", theItem.name);
        return;
    }
    curColor = theItem.colors[idx];
    [[MixPanelUtil instance] track:@"color"];
    [self displayItem];
}

-(void) updateBarButton {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Lists *activeList = appDelegate.activeList;
    if(activeList != nil) {
        self.btnNavBarList.titleLabel.text = [NSString stringWithFormat:@"%@(%d)",activeList.listName,(int)[activeList.listOfItems count] ];
        self.btnNavBarList.hidden = YES;
    }
    else
        self.btnNavBarList.hidden = YES;
}
-(void) addItemColorToActiveList:(ItemColor *)theColor {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Lists *activeList = appDelegate.activeList;
    
    if(activeList != nil) {
        ListItem *theListItem  = [[ListItem alloc ]initWithItemAndColor:theItem withColor:theColor];
        [activeList addItemColorToList:theListItem withPositionCheck:YES];
        [appDelegate saveList];
        
        theColor.isSelected = YES;
        theItem.isSelected = YES;
    }
    [self updateBarButton];
}

-(void) removeItemColorFromActiveList:(ItemColor *)theColor {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate removeItemColorFromActiveList:theItem itemColor:theColor];
    
    BOOL bAnyItemSelected = NO;
    for (ItemColor *theTempColor in theItem.colors) {
        if(theTempColor.isSelected) {
            bAnyItemSelected = YES;
            break;
        }
    }
    
    if(bAnyItemSelected == NO)
        theItem.isSelected = NO;
    [self updateBarButton];
}

-(void) closeButtonUIHelper {
    self.btnCloseItemList.titleLabel.font =[ClarksFonts clarksSansProRegular:12.0f];
    self.btnCloseNewListView.titleLabel.font =[ClarksFonts clarksSansProRegular:12.0f];
    self.btnCloseSelectList .titleLabel.font =[ClarksFonts clarksSansProRegular:12.0f];
    self.btnCloseSaveList.titleLabel.font =[ClarksFonts clarksSansProRegular:12.0f];
}

-(void) listViewUIHelper{
    self.viewListItem.titleLabel.font =[ClarksFonts clarksSansProRegular:12.0f];
    
    self.lblActiveList.font =[ClarksFonts clarksSansProRegular:9.0f];
    self.lblListName.font = [ClarksFonts clarksSansProThin:20.0f];
    self.btnListChange.titleLabel.font = [ClarksFonts clarksSansProRegular:9.0];
    self.backFromListSelect.titleLabel.font = [ClarksFonts clarksSansProRegular:9.0];
    self.backFromListSelect.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
    self.backFromListSelect.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    self.backFromListSelect.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    
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

#pragma mark - List

- (IBAction)onListClearAll:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Lists *curList = appDelegate.activeList;
    
    [curList emptyList];
    [self.listItemDS setUpEmptyData];
    [self updateListViewListNameLabel];
    for(Item *theCurItem in appDelegate.filtereditemArray)
        [theCurItem markItemAsDeselected];
    
    [appDelegate saveList];
    [self.shoeColorLTableView reloadData];
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
    
    Lists *newList = [[Lists alloc]init];
    newList.listName = newListName;
    
    [appDelegate markListAsActive:newList];
    if(self.tmpColor != nil) { // We had a parked item to add
        [self addItemColorToActiveList:self.tmpColor];
        self.tmpColor = nil;
    }
    
    [appDelegate.listofList addObject:newList];
    [self.shoeColorLTableView reloadData];
    
    // Now show the list view
    [self hideAllSlideOutViews];
    [self updateListViewListNameLabel];
    
    [self showListView];
    [appDelegate saveList];
    
}

- (IBAction)onEditingBeing:(id)sender {
    [self repositionNewListViewButtons];
}

- (IBAction)onEditingEnded:(id)sender {
    [self unRepositionNewListViewButtons];
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
    NSString *title = [NSString stringWithFormat:@"%@ (%d)",curList.listName, (int)curList.listOfItems.count];
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
    self.backFromListSelect.hidden = NO;
    // add the selected items in collection grid to the list
    [self slideOutCollectionView];
    
    self.itemListView.hidden = NO;
    CGRect tblFrame = CGRectMake(4.0f,100.0f, 310.0f, 533.0f);
    self.listTable.frame = tblFrame;
    
    
    [self.listItemDS setUpData];
    [self.listTable reloadData];
    [self.shoeColorLTableView reloadData];
    [self updateListViewListNameLabel];
}


- (IBAction)onOpenAList:(id)sender {
    [self hideAllSlideOutViews];
    [self slideOutCollectionView];
    self.itemListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.selectListView.hidden = NO;
    [self.itemListTableView reloadData];
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


-(void) performNoActiveList {
    [self.shoeListCollectionView setUserInteractionEnabled:NO];
    [self onOpenAList:nil];
    return;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)onShowListSlideout:(id)sender {
    // add the selected items in collection grid to the list
    if(isSlidePanelOpen) {
        [self closeLeftSlideOut:sender];
        return;
    }
    [self hideAllSlideOutViews];
    [self slideOutCollectionView];

    self.itemListView.hidden = NO;
    
    [self.listItemDS setUpData];
    [self.listTable reloadData];
    [self updateListViewListNameLabel];
}

- (IBAction)onShowCreateSelectNewList:(id)sender {
    // slide the frame left
    if(isSlidePanelOpen) {
        [self closeLeftSlideOut:sender];
        return;
    }

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Lists *activeList = appDelegate.activeList;
    if(activeList == nil) {
        [self onOpenAList:sender];
    }
    else {
        [self onShowListSlideout:sender];
    }
    [self slideOutCollectionView];
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"discover_collection"]) {
        DiscoverCollectionDetailViewController *destVC = (DiscoverCollectionDetailViewController *)segue.destinationViewController;
        [[MixPanelUtil instance] track:@"discover_selected_via_shoe"];
        [destVC setupTransitionFromShoeDetail:theItem.collectionName];
    }
    
    if([segue.identifier isEqualToString:@"360View"]) {
        Image360ViewController *destVC = (Image360ViewController *)segue.destinationViewController;
        [[MixPanelUtil instance] track:@"360degImage"];
        destVC.itemColor = curColor;
    }
    

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([segue.destinationViewController class] != [ItemsInListViewController class]) {
        return;
    }
    else {
        ItemsInListViewController *itemsInListVC = (ItemsInListViewController *)segue.destinationViewController;
        int index = (int)[appDelegate.listofList indexOfObject:appDelegate.activeList];
        [self.shoeListCollectionView setUserInteractionEnabled:YES];
        [itemsInListVC setListIndex:index];
    }
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

- (IBAction)onChangeList:(id)sender {
    [self onOpenAList:sender];
    self.backFromListSelect.hidden = NO ;
}

- (IBAction)backFromChange:(UIButton *)sender{
    [self hideAllSlideOutViews];
    [self showListView];
}

- (IBAction)closeLeftSlideOut:(id)sender {
    [self slideBackInCollectionView];
    [self hideAllSlideOutViews];
    self.tmpColor = nil;
}

-(void) slideOutCollectionView{
    CGRect f = self.shoeListCollectionView.frame;
    [ClarksUI reposition:self.shoeListCollectionView x:-314 y:f.origin.y];
    isSlidePanelOpen = YES;
 //   f.origin.x = -314; // new x
//    self.shoeListCollectionView.frame = f;
}


-(void) slideBackInCollectionView{
    CGRect f = self.shoeListCollectionView.frame;
    [ClarksUI reposition:self.shoeListCollectionView x:0 y:f.origin.y];
    isSlidePanelOpen = NO;
}

-(void) hideAllSlideOutViews {
    [self.shoeListCollectionView setUserInteractionEnabled:YES];
    self.itemListView.hidden = YES;
    self.saveListView.hidden = YES;
    self.selectListView.hidden = YES;
    self.theNewListView.hidden = YES;

    isSlidePanelOpen = NO;
}

@end
