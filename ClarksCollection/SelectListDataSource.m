//
//  SelectListDataSource.m
//  ClarksCollection
//
//  Created by Openly on 14/10/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "SelectListDataSource.h"
#import "ClarksFonts.h"
#import "AppDelegate.h"
#import "Lists.h"

@implementation SelectListDataSource
{
    NSMutableArray *list;
}


- (instancetype)init
{
    if(self)
    {
    }
    return self;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return [appDelegate.listofList count];;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"select-a-list";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    int i =(int)indexPath.row;
    
    UILabel *lblListName = (UILabel *)[cell viewWithTag:120];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Lists *theList = (Lists *)[appDelegate.listofList objectAtIndex:i];

    NSString *text = theList.listName;
    if([text length] > 25)
    {
        text = [NSString stringWithFormat:@"%@...",[text substringToIndex:25]];
    }
    NSString *count = [NSString stringWithFormat:@"(%lu products)",(unsigned long)[theList.listOfItems count]];
    
    NSString *fullString = [NSString stringWithFormat:@"%@ %@", text, count];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:fullString];
    
    [str addAttribute:NSFontAttributeName
                  value:[ClarksFonts clarksSansProLight:16.0f]
                  range:NSMakeRange(0, [text length]) ];
    
    [str addAttribute:NSFontAttributeName
                value:[ClarksFonts clarksSansProLight:11.0f]
                range:NSMakeRange([text length]+1, [count length]) ];
    
    lblListName.attributedText = str;
    
    [lblListName sizeToFit];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Lists *theListToBeAddedTo = (Lists *)[appDelegate.listofList objectAtIndex:indexPath.row];
    
    // if I have pending item to be added then add it
    if(self.parentVC.tmpItem !=nil)
    {
        [theListToBeAddedTo addItemToList:self.parentVC.tmpItem];
        [appDelegate saveList];
        self.parentVC.tmpItem = nil;
    }
    
    [appDelegate markListAsActive:theListToBeAddedTo];
    if(self.singleShoeParentVC.tmpColor !=nil){
        [self.singleShoeParentVC addItemColorToActiveList:self.singleShoeParentVC.tmpColor];
        [appDelegate saveList];
        self.singleShoeParentVC.tmpColor =nil;
    }
    // Now start showing the things actually ask the vc to do it
    if(self.parentVC.isViewLoaded && self.parentVC.view.window) {
        self.parentVC.selectListView.hidden = YES;
    
        [self.parentVC.shoeListCollectionView setUserInteractionEnabled:YES];
        [self.parentVC showListView];
    }
    
    if(self.singleShoeParentVC.isViewLoaded && self.singleShoeParentVC.view.window) {
        self.singleShoeParentVC.selectListView.hidden = YES;
        
        [self.singleShoeParentVC.shoeListCollectionView setUserInteractionEnabled:YES];
        [self.singleShoeParentVC showListView];
    }
    [appDelegate reconcileFilteredArrayWithActiveList];

}

@end
