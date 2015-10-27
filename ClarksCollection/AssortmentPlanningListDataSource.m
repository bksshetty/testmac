//
//  AssortmentPlanningListDataSource.m
//  ClarksCollection
//
//  Created by Abhilash Hebbar on 29/05/15.
//  Copyright (c) 2015 Clarks. All rights reserved.
//

#import "AssortmentPlanningListDataSource.h"
#import "DataReader.h"
#import "Region.h"
#import "ClarksFonts.h"
#import "TableViewCellButton.h"
#import "RenameListViewController.h"
#import "AppDelegate.h"

@implementation AssortmentPlanningListDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSDictionary *data = [DataReader read];
        NSArray *regions = [[data valueForKey:@"assortment_planning_lists"] valueForKey:@"regions"];
        for (NSDictionary *reg in regions) {
            if ([[reg valueForKey:@"name"]
                 
                 isEqualToString: [Region getCurrent].name]) {
                self.list = [reg valueForKey:@"lists"];
            }
        }
    }
    return self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"list-cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    for (UIView *v in [cell subviews]) {
        if ([v class] == [TableViewCellButton class]) {
            [v removeFromSuperview];
        }
    }
    
    UILabel *lblListName = (UILabel *)[cell viewWithTag:120];
    
    
    
    NSString *listName = [self.list[indexPath.row] valueForKey:@"name"];
    NSString *count = [NSString stringWithFormat:@"%lu products", (unsigned long)[[self.list[indexPath.row] valueForKey:@"color_ids"] count] ];
    
    NSString *fullString = [NSString stringWithFormat:@"%@ %@", listName, count];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:fullString];
    
    [str addAttribute:NSFontAttributeName
                value:[ClarksFonts clarksSansProThin:30.0f]
                range:NSMakeRange(0, [listName length]) ];
    
    [str addAttribute:NSFontAttributeName
                value:[ClarksFonts clarksSansProThin:20.0f]
                range:NSMakeRange([listName length]+1, [count length]) ];
    
    UIColor *clr = [UIColor colorWithRed:167.0/255 green:167.0f/255 blue:167.0f/255 alpha:1.0f];
    [str addAttribute:NSForegroundColorAttributeName
                value:clr
                range:NSMakeRange([listName length]+1, [count length])];
    
    lblListName.attributedText = str;
    
        TableViewCellButton *renameButton = [self makeRenameButtonForCell:cell];
        renameButton.indexPath = indexPath;
        [cell addSubview:renameButton];
    
    
        TableViewCellButton *exportButton = [self makeExportButtonForCell:cell];
        exportButton.indexPath = indexPath;
        [cell addSubview:exportButton];
    
    return cell;
}

-(TableViewCellButton *)makeExportButtonForCell:(UITableViewCell *)cell
{
    TableViewCellButton *button = [TableViewCellButton buttonWithType:UIButtonTypeCustom];
    button.cell = cell;
    UIImage *image = [UIImage imageNamed:@"export.jpg"];
    
    CGFloat width = image.size.width/2;
    CGFloat height = image.size.height/2;
    CGFloat X = 900;
    CGFloat Y = 22;
    
    button.frame = CGRectMake(X, Y, width, height);
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(exportButtonClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(TableViewCellButton *)makeRenameButtonForCell:(UITableViewCell *)cell
{
    TableViewCellButton *button = [TableViewCellButton buttonWithType:UIButtonTypeCustom];
    button.cell = cell;
    UIImage *image = [UIImage imageNamed:@"edit.png"];
    
    CGFloat width = (image.size.width/2) +2;
    CGFloat height = (image.size.height/2) ;
    CGFloat X = 830;
    CGFloat Y = 24;
    
    button.frame = CGRectMake(X, Y, width, height);
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(renameButtonClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}


-(IBAction)exportButtonClicked:(id)sender {
    TableViewCellButton *button = (TableViewCellButton *)sender;
    [self.parentVC actionExport:(int)button.indexPath.row];
}

-(IBAction)renameButtonClicked:(id)sender {
    TableViewCellButton *button = (TableViewCellButton *)sender;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.preloadedOrAssortmentEdit = TRUE ;
    [self.parentVC actionRename:(int)button.indexPath.row];
    
}
@end
