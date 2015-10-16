//
//  ListItemDataSource.m
//  ClarksCollection
//
//  Created by Openly on 14/10/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "ListItemDataSource.h"
#import "ClarksColors.h"
#import "ClarksFonts.h"
#import "ManagedImage.h"
#import "ListItem.h"
#import "AppDelegate.h"
#import "TableViewCellButton.h"
#import "ClarksColors.h"
#import "ShoeListViewController.h"
#import "SingleShoeViewController.h"
#import "Item.h"
#import "ItemColor.h"

@implementation ListItemDataSource{
    NSMutableArray* uiListOfCollections;
    NSMutableArray* uiItemCountForSection;
    NSMutableArray* uiListOfItems;
    
}


- (instancetype)init
{
    if(self)
    {
    }
    return self;
}

-(void)setUpEmptyData {
    [uiListOfCollections removeAllObjects];
    [uiItemCountForSection removeAllObjects];
    [uiListOfItems removeAllObjects];
}

-(void)setUpData {
    if(uiListOfCollections == nil)
        uiListOfCollections = [[NSMutableArray alloc] initWithCapacity:2];
    else
        [uiListOfCollections removeAllObjects];

    if(uiItemCountForSection == nil)
        uiItemCountForSection = [[NSMutableArray alloc] initWithCapacity:2];
    else
        [uiItemCountForSection removeAllObjects];

    if(uiListOfItems == nil)
        uiListOfItems = [[NSMutableArray alloc]  initWithCapacity:2];
    else
        [uiListOfItems removeAllObjects];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Lists *curList = appDelegate.activeList;
    
    ListItem *theItem;
    for (theItem in curList.listOfItems) {
        BOOL bCollectionAlreadyExists = NO;
        NSString *strCollectionName = theItem.collectionName;
        for (NSString *collectionName in uiListOfCollections) {
            if([strCollectionName isEqualToString:collectionName])
            {
                bCollectionAlreadyExists = YES;
                break;
            }
        }
        if(bCollectionAlreadyExists == NO) {
            [uiListOfCollections addObject:strCollectionName];
        }
    }
 
    for (NSString *uiCollectionName in uiListOfCollections) {
        int count = 0;
        for (theItem in curList.listOfItems) {
            if([uiCollectionName isEqualToString:theItem.collectionName]) {
                [uiListOfItems addObject:theItem];
                count++;
            }
        }
        [uiItemCountForSection addObject:[NSNumber numberWithInt:count]];
    }
    return;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67.0f;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int nSection =(int)[uiListOfCollections count];
    return nSection;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Lists *curList = appDelegate.activeList;

    int itemCountForCollection = [curList noOfItemsForCollecton:uiListOfCollections[section]];
    return itemCountForCollection;
}


-(TableViewCellButton *)makeDeleteButtonForCell:(UITableViewCell *)cell
{
    TableViewCellButton *button = [TableViewCellButton buttonWithType:UIButtonTypeCustom];
    button.cell = cell;
    UIImage *image = [UIImage imageNamed:@"close-icon"];
    
    CGFloat width = image.size.width/2;
    CGFloat height = image.size.height/2;
    CGFloat X = 276;
    CGFloat Y = 33;
    
    button.frame = CGRectMake(X-20, Y-20, width+40, height+40);
    [button setContentEdgeInsets:UIEdgeInsetsMake(20, 20, 20, 20)];

    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(deleteButtonClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

-(IBAction)deleteButtonClicked:(id)sender
{
    TableViewCellButton *button = (TableViewCellButton *)sender;
    NSIndexPath *indexPath = button.indexPath;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Lists *curList = appDelegate.activeList;
    

    int i,t= 0;
    for(i = 0; i< indexPath.section; i++)
        t+=[[uiItemCountForSection objectAtIndex:i] intValue];
    
    t+=indexPath.row;

    ListItem *theDeletedItem = [uiListOfItems objectAtIndex:t];
    
    int currCountInSection =(int) [[uiItemCountForSection objectAtIndex:indexPath.section] integerValue];
    
    currCountInSection--;
    if(currCountInSection <=0) //Remove the header row as well
    {
        [uiListOfCollections removeObjectAtIndex:indexPath.section];
        [uiItemCountForSection removeObjectAtIndex:indexPath.section];
    }else {
        [uiItemCountForSection replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithInt:currCountInSection]];
    }
    
    

    [curList deleteItemColorFromList:theDeletedItem.itemNumber];
    
    [uiListOfItems removeObjectAtIndex:t];
    [appDelegate saveList];
    
    
    // Check if we have anymore shoe color in the list for the same shoename
    BOOL bAnyOtherColorInTheList = NO;
    for (ListItem *theListItem in curList.listOfItems) {
        if([theListItem.name isEqualToString:theDeletedItem.name]) {
            bAnyOtherColorInTheList = YES;
            break;
        }
    }
    
    if(self.shoeListViewController.isViewLoaded && self.shoeListViewController.view.window) {
        //Always true for master view in split view controller
        if(bAnyOtherColorInTheList == NO)
            [self.shoeListViewController deleteCollectionViewChecks: theDeletedItem.name];
    
        [self.shoeListViewController updateListViewListNameLabel];
        [self.shoeListViewController.listTable reloadData];
    }
    
    BOOL itemFound = NO;
    for(Item *theItem in appDelegate.filtereditemArray) {
        if([theItem.name isEqualToString:theDeletedItem.name]) {
            for(ItemColor *theColor in theItem.colors) {
                if([theColor.colorId isEqualToString:theDeletedItem.itemNumber]) {
                    theColor.isSelected = NO;
                    itemFound = YES;
                    break;
                }
            }
        }
        
        if(itemFound) {
            if(bAnyOtherColorInTheList == NO) {
                theItem.isSelected = NO;
            }
            break;
        }
        
    }

    if(self.singleShoeViewController.isViewLoaded && self.singleShoeViewController.view.window) {
        [self.singleShoeViewController updateListViewListNameLabel];
        [self.singleShoeViewController.listTable reloadData];
        [self.singleShoeViewController.shoeColorLTableView  reloadData];
    }
 
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"list_shoe_cell";
    int section = (int)indexPath.section;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    int i,t= 0;
    for(i = 0; i< section; i++)
        t+=[[uiItemCountForSection objectAtIndex:i] intValue];
    
    t+=indexPath.row;
    
    
    UILabel *lblShoeName = (UILabel *)[cell viewWithTag:111];
    UILabel *lblShoeColor = (UILabel *)[cell viewWithTag:112];
    ManagedImage *shoeImage= (ManagedImage *)[cell viewWithTag:110];
   
    if(t >= [uiListOfItems count]) {
        return cell;
    }

    shoeImage.image = [UIImage imageNamed:@"translucent"];
    ListItem *listItem = (ListItem *)[uiListOfItems objectAtIndex:t];
    
    lblShoeName.text = listItem.name;
    lblShoeColor.text =  listItem.itemColor;
//[listItem.itemColor uppercaseString];
    [shoeImage loadImage:listItem.imageSmall];
    
    [lblShoeName setFont:[ClarksFonts clarksSansProLight:16.0f]];
    [lblShoeColor setFont:[ClarksFonts clarksSansProRegular:9.0f]];
    
    TableViewCellButton *deleteButton = [self makeDeleteButtonForCell:cell];
    deleteButton.indexPath = indexPath;
    [cell addSubview:deleteButton];
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [uiListOfCollections[section] uppercaseString];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITextField *lbl = [[UITextField alloc] init];
    
    lbl.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    lbl.text = [uiListOfCollections[section] uppercaseString];
    [lbl setTextColor:[UIColor grayColor]];
    lbl.font = [ClarksFonts clarksSansProRegular:10.0f];
    
    lbl.textColor = [UIColor colorWithRed:114.0f/255.0f
                                    green:114.0f/255.0f
                                     blue:114.0f/255.0f
                                    alpha:1.0f];;
    lbl.userInteractionEnabled =NO;
 
    lbl.backgroundColor = [UIColor colorWithRed:247.0f/255.0f
                                          green:246.0f/255.0f
                                           blue:244.0f/255.0f
                                          alpha:1.0f];
    lbl.alpha = 1.0;
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 22)];
    
    [lbl setLeftViewMode:UITextFieldViewModeAlways];
    [lbl setLeftView:spacerView];
    return lbl;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
   // Background color
    view.tintColor = [UIColor colorWithRed:247.0f/255.0f
                                     green:246.0f/255.0f
                                      blue:244.0f/255.0f
                                     alpha:1.0f];
    
//    // Text Color
   UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
   [header.textLabel setTextColor:[UIColor colorWithRed:114.0f/255.0f
                                               green:114.0f/255.0f
                                                blue:114.0f/255.0f
                                                alpha:1.0f]];
  header.textLabel.font = [ClarksFonts clarksSansProRegular:10.0f];
//    
}
-(void)sortedList{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int i,t= 0;
    for(i = 0; i< indexPath.section; i++)
        t+=[[uiItemCountForSection objectAtIndex:i] intValue];
    
    t+=indexPath.row;
    ListItem *listItem = (ListItem *)[uiListOfItems objectAtIndex:t];
    Item *theItem = [listItem getItem];
    int colorIdx = [listItem getItemColorIdx:theItem];
    
    if (theItem == nil || colorIdx < 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot find Item"
                                                        message:@"The selected item cannot be found in the catalogue. Please make sure the item is available in current collection."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }else{
        UIViewController *curCtrl;
        if(self.shoeListViewController != nil){
            curCtrl = self.shoeListViewController;
        }else{
            curCtrl = self.singleShoeViewController;
        }
        
        SingleShoeViewController *ctrl = [curCtrl.storyboard instantiateViewControllerWithIdentifier:@"single_shoe"];
        [ctrl setItem:theItem withColorIndex:[listItem getItemColorIdx:theItem]];
        [curCtrl.navigationController pushViewController:ctrl animated:YES];
    }
    
}

@end
