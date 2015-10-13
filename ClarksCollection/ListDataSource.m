//
//  ListDataSource.m
//  ClarksCollection
//
//  Created by Openly on 04/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "ListDataSource.h"
#import "AppDelegate.h"
#import "ClarksFonts.h"
#import "ClarksColors.h"
#import "TableViewCellButton.h"

@implementation ListDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return [appDelegate.listofList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"list-cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    int i = (int)indexPath.row;
    
    UILabel *lblListName = (UILabel *)[cell viewWithTag:120];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Lists *theList = (Lists *)[appDelegate.listofList objectAtIndex:i];
    
    NSString *text = theList.listName;
    NSString *count = [NSString stringWithFormat:@" %lu products",(unsigned long)[theList.listOfItems count]];
    
    NSString *fullString = [NSString stringWithFormat:@"%@ %@", text, count];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:fullString];
    
    [str addAttribute:NSFontAttributeName
                value:[ClarksFonts clarksSansProThin:30.0f]
                range:NSMakeRange(0, [text length]) ];
    
    [str addAttribute:NSFontAttributeName
                value:[ClarksFonts clarksSansProThin:20.0f]
                range:NSMakeRange([text length]+1, [count length]) ];
    
    UIColor *clr = [UIColor colorWithRed:167.0/255 green:167.0f/255 blue:167.0f/255 alpha:1.0f];
    [str addAttribute:NSForegroundColorAttributeName
                value:clr
                range:NSMakeRange([text length]+1, [count length])];

    lblListName.attributedText = str;

    TableViewCellButton *editButton = [self makeEditButtonForCell:cell];
    editButton.indexPath = indexPath;
    [cell addSubview:editButton];
    
    TableViewCellButton *renameButton = [self makeRenameButtonForCell:cell];
    renameButton.indexPath = indexPath;
    [cell addSubview:renameButton];
   
    TableViewCellButton *deleteButton = [self makeDeleteButtonForCell:cell];
    deleteButton.indexPath = indexPath;
    [cell addSubview:deleteButton];

    TableViewCellButton *exportButton = [self makeExportButtonForCell:cell];
    exportButton.indexPath = indexPath;
    [cell addSubview:exportButton];

    TableViewCellButton *duplicateButton = [self makeDuplicateButtonForCell:cell];
    duplicateButton.indexPath = indexPath;
    [cell addSubview:duplicateButton];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    return cell;
}


-(TableViewCellButton *)makeEditButtonForCell:(UITableViewCell *)cell
{
    TableViewCellButton *button = [TableViewCellButton buttonWithType:UIButtonTypeCustom];
    button.cell = cell;
    UIImage *image = [UIImage imageNamed:@"edit.png"];
    
    CGFloat width = image.size.width/2+2;
    CGFloat height = image.size.height/2;
    CGFloat X = 652;
    CGFloat Y = 24;
    
    button.frame = CGRectMake(X, Y, width, height);
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(editButtonClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

-(TableViewCellButton *)makeRenameButtonForCell:(UITableViewCell *)cell
{
    TableViewCellButton *button = [TableViewCellButton buttonWithType:UIButtonTypeCustom];
    button.cell = cell;
    UIImage *image = [UIImage imageNamed:@"Aa.png"];
    
    CGFloat width = image.size.width-18;
    CGFloat height = image.size.height-19;
    CGFloat X = 700;
    CGFloat Y = 22;
    
    button.frame = CGRectMake(X, Y, width, height);
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(renameButtonClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}


-(TableViewCellButton *)makeExportButtonForCell:(UITableViewCell *)cell
{
    TableViewCellButton *button = [TableViewCellButton buttonWithType:UIButtonTypeCustom];
    button.cell = cell;
    UIImage *image = [UIImage imageNamed:@"export.jpg"];
    
    CGFloat width = image.size.width/2;
    CGFloat height = image.size.height/2;
    CGFloat X = 760;
    CGFloat Y = 22;
    
    button.frame = CGRectMake(X, Y, width, height);
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(exportButtonClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

-(TableViewCellButton *)makeDuplicateButtonForCell:(UITableViewCell *)cell
{
    TableViewCellButton *button = [TableViewCellButton buttonWithType:UIButtonTypeCustom];
    button.cell = cell;
    UIImage *image = [UIImage imageNamed:@"duplicate.jpg"];
    
    CGFloat width = image.size.width/2;
    CGFloat height = image.size.height/2;
    CGFloat X = 830;
    CGFloat Y = 22;
    
    button.frame = CGRectMake(X, Y, width, height);
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(duplicateButtonClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

-(TableViewCellButton *)makeDeleteButtonForCell:(UITableViewCell *)cell
{
    TableViewCellButton *button = [TableViewCellButton buttonWithType:UIButtonTypeCustom];
    button.cell = cell;
    UIImage *image = [UIImage imageNamed:@"delete.jpg"];
    
    CGFloat width = image.size.width/2;
    CGFloat height = image.size.height/2;
    CGFloat X = 900;
    CGFloat Y = 22;
    
    button.frame = CGRectMake(X, Y, width, height);
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(deleteButtonClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

-(IBAction)deleteButtonClicked:(id)sender {
    TableViewCellButton *button = (TableViewCellButton *)sender;
    [self.parentVC actionDelete:(int)button.indexPath.row];
}

-(IBAction)exportButtonClicked:(id)sender {
    TableViewCellButton *button = (TableViewCellButton *)sender;
    [self.parentVC actionExport:(int)button.indexPath.row];
}

-(IBAction)duplicateButtonClicked:(id)sender {
    TableViewCellButton *button = (TableViewCellButton *)sender;
    [self.parentVC actionDuplicate:(int)button.indexPath.row];
    
}

-(IBAction)renameButtonClicked:(id)sender {
    TableViewCellButton *button = (TableViewCellButton *)sender;
    [self.parentVC actionRename:(int)button.indexPath.row];
    
}
-(IBAction)editButtonClicked:(id)sender {
    //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    TableViewCellButton *button = (TableViewCellButton *)sender;
     //[appDelegate markListAsActive:[appDelegate.listofList objectAtIndex:button.indexPath.row]];
    [self.parentVC actionAddToList:(int)button.indexPath.row];
    
}
@end
