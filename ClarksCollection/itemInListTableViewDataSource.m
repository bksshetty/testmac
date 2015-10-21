//
//  itemInListTableViewDataSource.m
//  ClarksCollection
//
//  Created by Openly on 05/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "itemInListTableViewDataSource.h"
#import "AppDelegate.h"
#import "ManagedImage.h"
#import "ClarksColors.h"
#import "ClarksFonts.h"
#import "TableViewCellButton.h"
#import "ListViewController.h"

@implementation itemInListTableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.parentVC.list.listOfItems count];;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"item-in-list-table";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    ListItem *theListItem = self.parentVC.list.listOfItems[indexPath.row];
    
    UILabel *lblName = (UILabel *)[cell viewWithTag:120];
    [lblName setFont:[ClarksFonts clarksNarzissMediumBd:25.0f]];
    lblName.text = theListItem.name;
    
    ManagedImage *shoeImage= (ManagedImage *)[cell viewWithTag:122];
    shoeImage.image = [UIImage imageNamed:@"translucent"];
    [shoeImage loadImage: theListItem.imageSmall];
    shoeImage.contentMode = UIViewContentModeScaleAspectFit;
    
    
    for(int i= 123; i<129; i++) {
        UILabel *lbl = (UILabel *)[cell viewWithTag:i];
        [lbl setFont:[ClarksFonts clarksSansProLight:9.0f]];
    }
    
    for(int i= 130; i<36; i++) {
        UILabel *lbl = (UILabel *)[cell viewWithTag:i];
        [lbl setFont:[ClarksFonts clarksSansProRegular:16.0f]];
    }

    UILabel *colorId = (UILabel *)[cell viewWithTag:130];
    UILabel *collectionName = (UILabel *)[cell viewWithTag:131];
    UILabel *colorName = (UILabel *)[cell viewWithTag:132];
    UILabel *fitting = (UILabel *)[cell viewWithTag:133];
    UILabel *wholesale = (UILabel *)[cell viewWithTag:134];
    UILabel *retail = (UILabel *)[cell viewWithTag:135];
    
    
    colorId.text = theListItem.itemNumber;

    collectionName.text = [theListItem.collectionName capitalizedString];
    
    colorName.text = [theListItem.itemColor capitalizedString];
    
    fitting.text = [NSString stringWithFormat:@"%@/%@", theListItem.fit, theListItem.size];
    
    float floatVal = fabsf([theListItem.wholeSalePrice floatValue]);
    
    if(floatVal > 0.1) {
        wholesale.hidden = NO;
        wholesale.text = [NSString stringWithFormat:@"£%.02f",floatVal];
        [(UILabel *)[cell viewWithTag:127] setHidden:NO];
    }
    else {
        wholesale.hidden=YES;
        wholesale.text = @"";
        [(UILabel *)[cell viewWithTag:127] setHidden:YES];
    }
    
    floatVal = fabsf([theListItem.retailPrice floatValue]);
    [retail setFont:[ClarksFonts clarksSansProRegular:16.0f]];
    
    if(floatVal > 0.1){
        retail.text = [NSString stringWithFormat:@"£%.02f",floatVal];
        retail.hidden = NO;
        [(UILabel *)[cell viewWithTag:128] setHidden:NO];
    }
    else {
        retail.text = @"";
        retail.hidden = YES;
        [(UILabel *)[cell viewWithTag:128] setHidden:YES];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    if (!self.parentVC.readOnly) {
        TableViewCellButton *deleteButton = [self makeDeleteButtonForCell:cell];
        deleteButton.indexPath = indexPath;
        [cell addSubview:deleteButton];
    }
    CALayer *separator = [CALayer layer];
    
    separator.backgroundColor = [ClarksColors clarkLightGrey].CGColor;
    separator.frame = CGRectMake(0, 107, 1024, 4);
    [cell.layer addSublayer:separator];

    return cell;
}

-(TableViewCellButton *)makeDeleteButtonForCell:(UITableViewCell *)cell
{
    TableViewCellButton *button = [TableViewCellButton buttonWithType:UIButtonTypeCustom];
    button.cell = cell;
    UIImage *image;
    
    image = [UIImage imageNamed:@"grey-close"];
    
    
    CGFloat width = image.size.width / 2;
    CGFloat height = image.size.height / 2;
    CGFloat X = 982;
    CGFloat Y = 46;
    
    button.frame = CGRectMake(X-10, Y-10, width+20, height+20);
    [button setContentEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(deleteItemFromList:)
     forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

-(IBAction)deleteItemFromList:(id)sender
{
    //animate table deletion
    TableViewCellButton *button = (TableViewCellButton *)sender;
    int indexPath = (int)button.indexPath.row;

    [self.parentVC.list.listOfItems removeObjectAtIndex:indexPath];
    [self.parentVC.tableView reloadData];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate saveList];
    

}


@end
