//
//  ItemsinListViewController.m
//  ClarksCollection
//
//  Created by Openly on 05/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "ItemsInListViewController.h"
#import "AppDelegate.h"
#import "DuplicateListViewController.h"
#import "ExportListViewController.h"
#import "SingleShoeViewController.h"
#import "Lists.h"
#import "ClarksFonts.h"
#import "Region.h"
#import "Assortment.h"
#import "Collection.h"
#import "Item.h"
#import "DataReader.h"
#import "PreloadedListDataSource.h"
#import "AssortmentSelectViewController.h"
#import "DiscoverCollectionDetailViewController.h"

@interface ItemsInListViewController ()

@end

@implementation ItemsInListViewController {
    Lists *tmpList; // Unkown error :(
}

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
    // Do any additional setup after loading the view.
    if(self.list == nil){
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if([appDelegate.listofList count] > 0 && [appDelegate.listofList count] > self.listItemIndex){
            self.list=[appDelegate.listofList objectAtIndex:self.listItemIndex];
        }else{
                        
        }
    }
    else{
        tmpList = self.list;
    }
    [self.lblListTitel setFont:[ClarksFonts clarksSansProLight:16.0f]];
    self.lblListTitel.textColor= [UIColor colorWithRed:(39/255.0) green:(6/255.0) blue:(38/255.0) alpha:1] ;
    
    self.lblListTitel.text  = [self.list.listName uppercaseString];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.btnGridView.enabled = NO;
    if (self.readOnly) {
        self.addToListBtn.hidden = YES;
    }
}

-(void)viewDidAppear:(BOOL)animated {
    if (tmpList !=nil) {
        self.list = tmpList;
    }
    [super viewDidAppear:animated];
    NSLog(@"Count: %lu", (unsigned long)[self.list.listOfItems count]);
    // To protect agains someone going to the details, adding and removing items
    if(self.gridView.hidden == NO)
        [self.gridView reloadData];
    
    if(self.tableView.hidden == NO)
        [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    Item *theItem = nil;
    BOOL itemFound = NO;
    if(([identifier isEqualToString:@"grid_view_to_single_shoe"]) || ([identifier isEqualToString:@"table_view_to_single_shoe"])) {
        NSIndexPath *indexPath;
        if([identifier isEqualToString:@"grid_view_to_single_shoe"]) {
            UICollectionViewCell *cell = (UICollectionViewCell *) sender;
            indexPath = [self.gridView indexPathForCell:cell];
        } else {
            UITableViewCell *cell = (UITableViewCell *) sender;
            indexPath = [self.tableView indexPathForCell:cell];
        }
        
    ListItem *theListItem = self.list.listOfItems[indexPath.row];
    Region *region = [Region getCurrent];
    
        for(Assortment *theAssortment in region.assortments) {
            for (Collection *theCollection in theAssortment.collections) {
                for(theItem in theCollection.items) {
                    if([theItem.name isEqualToString:theListItem.name]) {
                        itemFound = YES;
                        return YES; // item
                    }
                }
            }
        }
    
        NSString *message= [NSString stringWithFormat:@"%@ not found",theListItem.name];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not found"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    return YES; // No validationfor other segues
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([segue.identifier isEqualToString:@"assortmentSelect"]) {
        [appDelegate markListAsActive:self.list];
    }
    if([segue.identifier isEqualToString:@"duplicateList2"]) {
        DuplicateListViewController *duplicateListVC = (DuplicateListViewController *)segue.destinationViewController;
        duplicateListVC.index = self.listItemIndex;
    }
    if([segue.identifier isEqualToString:@"exportList"]) {
        ExportListViewController *exportListVC = (ExportListViewController *)segue.destinationViewController;
        exportListVC.list = self.list;
    }
    
    if([segue.identifier isEqualToString:@"discover_collection"]) {
        DiscoverCollectionDetailViewController *destVC = (DiscoverCollectionDetailViewController *)segue.destinationViewController;
        [destVC setupTransitionFromShoeDetail:appDelegate.discoverColl];
    }
    
    if(([segue.identifier isEqualToString:@"grid_view_to_single_shoe"]) || ([segue.identifier isEqualToString:@"table_view_to_single_shoe"])) {
        NSIndexPath *indexPath;
        if([segue.identifier isEqualToString:@"grid_view_to_single_shoe"]) {
            UICollectionViewCell *cell = (UICollectionViewCell *) sender;
            indexPath = [self.gridView indexPathForCell:cell];
        } else {
            UITableViewCell *cell = (UITableViewCell *) sender;
            indexPath = [self.tableView indexPathForCell:cell];
        }
        
        
        SingleShoeViewController *singleShoeViewController = (SingleShoeViewController *) segue.destinationViewController;
        ListItem *theListItem = self.list.listOfItems[indexPath.row];

        
        Region *region = [Region getCurrent];
        Item *theItem = nil;
        BOOL itemFound = NO;
        
        for(Assortment *theAssortment in region.assortments) {
            for (Collection *theCollection in theAssortment.collections) {
                for(theItem in theCollection.items) {
                    if([theItem.name isEqualToString:theListItem.name]) {
                        itemFound = YES;
                        theItem.collectionName = theCollection.name;
                        break; // item
                    }
                }
                if(itemFound)
                    break; // Collection
            }
            if(itemFound)
                break; // Assortment
        }
    
        int i=0;
        ItemColor *theColor;
        for(i=0; i<[theItem.colors count]; i++) {
            theColor = [theItem.colors objectAtIndex:i];
            if([theColor.colorId isEqualToString:theListItem.itemNumber]) {
                break;
            }
        }
            
        [singleShoeViewController setItem:theItem withColorIndex:i ];
    }
}

-(void)setListIndex:(int)index {
    self.listItemIndex = index;
}


- (IBAction)onGridView:(id)sender {
    self.gridView.hidden = NO;
    self.tableView.hidden=YES;
    [self.gridView reloadData];
    self.btnGridView.enabled = NO;
    self.btnTableView.enabled =YES;
}

- (IBAction)onTableView:(id)sender {
    self.gridView.hidden = YES;
    self.tableView.hidden=NO;
    [self.tableView reloadData];
    self.btnGridView.enabled = YES;
    self.btnTableView.enabled =NO;
}
@end
