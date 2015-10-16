//
//  SingleShoeDataSource.m
//  ClarksCollection
//
//  Created by Openly on 15/10/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "SingleShoeDataSource.h"
#import "ClarksFonts.h"
#import "ClarksColors.h"
#import "ItemColor.h"
#import "SingleShoeViewController.h"
#import "ColorCell.h"
#import "TableViewCellButton.h"
#import <math.h>
#import "AssortmentSelectViewController.h"
#import "Collection.h"
#import "MixPanelUtil.h"

@implementation SingleShoeDataSource


- (instancetype)init
{
    if(self)
    {
        self.selectedRow = 0;
        self.detailsRow = -1;
    }
    return self;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.item == nil) {
        return 0;
    }
    return [self.item.colors count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"single_shoe_cell";
    
    [[MixPanelUtil instance] track:@"info_icon_clicked"] ;
    ColorCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    for (UIView *oldViews in cell.subviews)
    {
        if([oldViews isKindOfClass:[TableViewCellButton class]])
            [oldViews removeFromSuperview];
    }
    
    
    if(self.selectedRow == indexPath.row){
        [cell selectColor];
    }else{
        [cell deSelectColor];
    }
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,533,1024,164 ) style:UITableViewStylePlain ];

    ItemColor *color = ((ItemColor *)self.item.colors[indexPath.row]);
    Item *item = (Item *)self.item;
    NSString *text = color.name;
    cell.lblColorValue.text = text;
    cell.lblProductCodeValue.text = color.colorId;
    if(color.thumbs != nil)
        if([color.thumbs count] > 0)
            [cell.image loadImage:color.thumbs[0]];
    cell.image.contentMode = UIViewContentModeScaleAspectFit;
    
    
    int ly = 120 ,ry = 120, ll = 142, rl= 142, counter = 0,numberOfEmptyFeilds=0;
    
    NSString *heelHeight ;
    

    
    if(item.heelHeight != nil && [item.heelHeight length]>0)
        heelHeight = [NSString stringWithFormat:@"%@ mm", item.heelHeight];
    else
        heelHeight = item.heelHeight;
    
    
    if ([AssortmentSelectViewController getInstance].assortmentName != nil) {
        item.assortmentName = [AssortmentSelectViewController getInstance].assortmentName ;
    }else{
        item.assortmentName = @" " ;
    }
    
    if (item.collectionName == nil) {
        item.collectionName = @ " " ;
    }
    
    NSArray *labels = [NSArray arrayWithObjects:@"ASSORTMENT",@"UPPER MATERIALS",@"CONSTRUCTION",@"SIZE",@"SOCK",@"COLLECTION",@"FITTING",@"SOLE",@"HEEL HEIGHT",@"LINING", nil];
    
    NSLog(@"Assortment Name: %@", item.assortmentName);
    NSArray *details ;
    if (item.assortmentName != nil) {
        details = [NSArray arrayWithObjects:item.assortmentName,item.upperMaterial,item.construction,item.size,item.sock,item.collectionName, item.fit, item.sole,heelHeight,item.lining, nil];
    }else{
        details = [NSArray arrayWithObjects:@" ",item.upperMaterial,item.construction,item.size,item.sock,item.collectionName, item.fit, item.sole,heelHeight,item.lining, nil];
    }
    
    for (int i=0; i<[labels count];i++){
        if(details[i] != nil && [details[i] length]>0){
            UIImageView *verLine = [[UIImageView alloc]initWithFrame:CGRectMake(565,118,1,150)];
            verLine.image=[UIImage imageNamed:@"grey.png"];
            [cell addSubview:verLine];
            if(counter < ([labels count]/2.0f)){
                [cell addSubview: [self createLeftLabels:labels[i] yValue:ly]];
                [cell addSubview: [self createLeftValueLabels:details[i] yValue:ly]];
                ly = ly+29 ;
                [cell addSubview: [self horizontalLines :180 yValue:ll]];
                ll = ll+29 ;
                counter++;
            }
            else{
                [cell addSubview: [self createRightLabels:labels[i] yValue:ry]];
                [cell addSubview: [self createRightValueLabels:details[i] yValue:ry]];
                ry = ry+29 ;
                [cell addSubview: [self horizontalLines :605 yValue:rl]];
                rl = rl+29 ;
            }
        }
        else{
            numberOfEmptyFeilds++;
        }
    }
    
    if(numberOfEmptyFeilds ==8){
        cell.btnInfo.hidden = YES;
    }
    
    self.fullHeight = ly + 10 ;
    
    
    float floatVal =[color.wholeSalePrice floatValue];
    if(floatVal > .1) {
        cell.lblWholesalePriceValue.hidden = NO;
        cell.lblWholesalePriceLabel.hidden = NO;
        cell.lblWholesalePriceValue.text =[NSString stringWithFormat:@"£%.02f",floatVal];
    }
    else {
        cell.lblWholesalePriceValue.hidden = YES;
        cell.lblWholesalePriceLabel.hidden = YES;
        cell.lblWholesalePriceValue.text =@"";
    }
    
    floatVal =[color.retailPrice floatValue];
    if(floatVal > .1) {
        cell.lblRetailPriceValue.text =[NSString stringWithFormat:@"£%.02f",floatVal];
        cell.lblRetailPriceValue.hidden = NO;
        cell.lblRetailPriceLabel.hidden = NO;
    }
    else {
        cell.lblRetailPriceValue.text =@"";
        cell.lblRetailPriceValue.hidden = YES;
        cell.lblRetailPriceLabel.hidden = YES;
    }
    
    
    BOOL withState = color.isSelected;

    TableViewCellButton *addButton = [self makeAddButtonForCell:cell withState:withState];
    addButton.indexPath = indexPath;
    [cell addSubview:addButton];
    
    cell.tag = indexPath.row;
    
    return cell;
}

-(UIImageView *) horizontalLines : (int)x yValue:(int)y{
    UIImageView *horLine = [[UIImageView alloc]initWithFrame:CGRectMake(x,y,340,1)];
    horLine.image=[UIImage imageNamed:@"grey.png"];
    return horLine ;
}
- (UILabel *) createLeftLabels: (NSString *)name yValue:(int)y{
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(180, y, 120,16)];
    lbl.font= [ClarksFonts clarksSansProRegular:12.0f];
    [lbl setTextColor:[UIColor grayColor]];
    lbl.text = name;
    return lbl;
}
- (UILabel *) createRightLabels: (NSString *)name yValue:(int)y{
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(605, y, 120,16)];
    lbl.font= [ClarksFonts clarksSansProRegular:12.0f];
    [lbl setTextColor:[UIColor grayColor]];
    lbl.text = name;
    return lbl;
}
- (UILabel *) createLeftValueLabels: (NSString *)name yValue:(int)y{
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(370,y, 120,16)];
    lbl.font= [ClarksFonts clarksSansProRegular:14.0f];
    [lbl setTextColor:[UIColor blackColor]];
    lbl.text = name;
    return lbl;
}
- (UILabel *) createRightValueLabels: (NSString *)name yValue:(int)y{
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(795,y, 140,16)];
    lbl.font= [ClarksFonts clarksSansProRegular:14.0f];
    [lbl setTextColor:[UIColor blackColor]];
    lbl.text = name;
    return lbl;
}

-(TableViewCellButton *)makeAddButtonForCell:(UITableViewCell *)cell withState:(BOOL)withState
{
    TableViewCellButton *button = [TableViewCellButton buttonWithType:UIButtonTypeCustom];
    button.cell = cell;
    UIImage *image;

    if(withState)
    {
        image = [UIImage imageNamed:@"tick-single-shoe"];
    }
    else
    {
        image = [UIImage imageNamed:@"plus-single-shoe"];
    }
    
    CGFloat width = image.size.width/2;
    CGFloat height = image.size.height/2;
    CGFloat X = 924;
    CGFloat Y = 0;
    
    button.frame = CGRectMake(X, Y, width, height);
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(addButtonClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

-(IBAction)addButtonClicked:(id)sender {
    TableViewCellButton *button =(TableViewCellButton *)sender;
    ItemColor *theColor = self.item.colors[button.indexPath.row];
    if ([self.parentViewController isActiveList] == NO) {
        self.parentViewController.tmpColor = theColor;
        [self.parentViewController performNoActiveList];
       return;
    }
    BOOL currentState = theColor.isSelected;
    
    if(currentState == NO)
    {
        theColor.isSelected = YES;
        [self.parentViewController addItemColorToActiveList:theColor];
    }
    else
    {
        theColor.isSelected = NO;
        [self.parentViewController removeItemColorFromActiveList:theColor];
    }

    
    UIImage *image;
    if(theColor.isSelected)
    {
        image = [UIImage imageNamed:@"tick-single-shoe"];
    }
    else
    {
        image = [UIImage imageNamed:@"plus-single-shoe"];
    }
    
    CGFloat width = image.size.width/2;
    CGFloat height = image.size.height/2;
    CGFloat X = 924;
    CGFloat Y = 0;
    
    button.frame = CGRectMake(X, Y, width, height);
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(addButtonClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    

    [self.parentViewController updateListTable];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.parentViewController setColor: (int)indexPath.row];
    [self selectColorAtIndex:(int)indexPath.row tableView:tableView];
}

-(void) showDetails:(int) index tableView:(UITableView *) tableView{
    if (index == self.detailsRow) {
        self.detailsRow = -1;
        NSMutableArray *rowsToAnimate = [[NSMutableArray alloc]initWithCapacity:1];
        [rowsToAnimate addObject:[NSIndexPath indexPathForItem:index inSection:0]];
        [tableView beginUpdates];
        [tableView reloadRowsAtIndexPaths:rowsToAnimate withRowAnimation:UITableViewRowAnimationAutomatic ];
        [tableView endUpdates];
        return;
    }
    
    NSMutableArray *rowsToAnimate = [[NSMutableArray alloc]initWithCapacity:2];
    NSIndexPath *detailsIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    [rowsToAnimate addObject:[NSIndexPath indexPathForItem:self.detailsRow inSection:0]];
    [rowsToAnimate addObject: detailsIndexPath];
    
    self.detailsRow = index;

    [tableView beginUpdates];
    [tableView reloadRowsAtIndexPaths:rowsToAnimate withRowAnimation:UITableViewRowAnimationAutomatic ];
    [tableView endUpdates];
    [tableView scrollToRowAtIndexPath:detailsIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.detailsRow == indexPath.row)
        return self.fullHeight;
    else
        return 100.0;
}

-(void) selectColorAtIndex: (int) index tableView:(UITableView *) tableView{
    if( self.selectedRow == index)
    {
        return;
    }
    
    NSIndexPath *oldSelection = [NSIndexPath indexPathForRow:self.selectedRow inSection:0];
    ColorCell *cell1 = (ColorCell *)[tableView cellForRowAtIndexPath:oldSelection];
    [cell1 deSelectColor];
    
    ColorCell *cell = (ColorCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    [cell selectColor];
    
    self.selectedRow = index;
}
@end
