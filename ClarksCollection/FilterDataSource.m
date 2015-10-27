//
//  FilterDataSource.m
//  ClarksCollection
//
//  Created by Openly on 10/10/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "FilterDataSource.h"
#import "ClarksColors.h"
#import "ClarksFonts.h"
#import "MSCellAccessory.h"

@implementation FilterDataSource

- (instancetype)init
{
    if(self)
    {
    }
    return self;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int count = (int)self.filters.count;
    return count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.filters objectAtIndex:section] valueForKey:@"options"] count];
 }

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"filter_cell";
    int section = (int)indexPath.section;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    
    cell.textLabel.text = [[[[self.filters objectAtIndex:section] valueForKey:@"options"] objectAtIndex: indexPath.row] valueForKey:@"name"];
    cell.contentView.backgroundColor = [ClarksColors clarkLightGrey];
    cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_CHECKMARK color:[ClarksColors clarkLightGrey] highlightedColor:[ClarksColors clarksButtonGreen]];
    cell.textLabel.highlightedTextColor = [ClarksColors clarksButtonGreen];
    
    UIView *bgColorView = [[UIView alloc] init];
    cell.textLabel.font = [ClarksFonts clarksSansProLight:16.0f ];
    
    bgColorView.backgroundColor = [ClarksColors clarkLightGrey];
    [cell setSelectedBackgroundView:bgColorView];

    return cell;
}

- (void)setCellColor:(UIColor *)color ForCell:(UITableViewCell *)cell {
    cell.contentView.backgroundColor = color;
    cell.backgroundColor = color;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell
forRowAtIndexPath: (NSIndexPath*)indexPath
{
    cell.backgroundColor = [ClarksColors clarkLightGrey];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.filters[section] valueForKey:@"name"];
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
    lbl.text = [[self.filters[section] valueForKey:@"name"] uppercaseString];
    NSLog(@"%@", lbl.text);
    [lbl setTextColor:[UIColor grayColor]];
    lbl.font = [ClarksFonts clarksSansProRegular:10.0f];

    lbl.textColor = [UIColor colorWithRed:114.0f/255.0f
                                        green:114.0f/255.0f
                                        blue:114.0f/255.0f
                                        alpha:1.0f];;
    lbl.userInteractionEnabled =NO;
//    lbl.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"DarkGrayBg"]];
    lbl.backgroundColor = [ClarksColors clarkDarkGrey];
    lbl.alpha = 1.0;
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 12)];
    
    [lbl setLeftViewMode:UITextFieldViewModeAlways];
    [lbl setLeftView:spacerView];
    return lbl;
}

@end
