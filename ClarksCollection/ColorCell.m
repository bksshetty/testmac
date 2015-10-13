//
//  ColorCell.m
//  ClarksCollection
//
//  Created by Openly on 22/10/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "ColorCell.h"
#import "ClarksFonts.h"
#import "ClarksColors.h"
#import "SingleShoeDataSource.h"

@implementation ColorCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    
    
    return self;
}

- (void)awakeFromNib
{
    self.lblColorValue.font = [ClarksFonts clarksSansProThin:20.0f];
    self.lblProductCodeValue.font = [ClarksFonts clarksSansProThin:20.0f];
    self.lblRetailPriceValue.font = [ClarksFonts clarksSansProThin:20.0f];
    self.lblWholesalePriceValue.font = [ClarksFonts clarksSansProThin:20.0f];
    self.lblAddBtn.font = [ClarksFonts clarksSansProRegular:9.0f];
    self.lblSockValue.font = [ClarksFonts clarksSansProRegular:15.0f];
    self.lblLiningValue.font = [ClarksFonts clarksSansProRegular:15.0f];
    
    int i;
    for(i=120;i<124;i++){
        UILabel *lbl = (UILabel *)[self viewWithTag:i];
        lbl.font = [ClarksFonts clarksSansProRegular:9.0f];
    }
    
    for(i=1000;i<1006;i++){
        UILabel *lbl = (UILabel *)[self viewWithTag:i];
        lbl.font = [ClarksFonts clarksSansProRegular:9.0f];
    }
    
    for(i=1010;i<1016;i++){
        UILabel *lbl = (UILabel *)[self viewWithTag:i];
        lbl.font = [ClarksFonts clarksSansProLight:16.0f];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (IBAction)toggleDetails:(id)sender {
    UITableView *tableView = [self parentTableView];
    SingleShoeDataSource *ds = (SingleShoeDataSource *)tableView.dataSource;
    [ds showDetails:(int)self.tag tableView:tableView];
}

-(UITableView *) parentTableView {
    // iterate up the view hierarchy to find the table containing this cell/view
    UIView *aView = self.superview;
    while(aView != nil) {
        if([aView isKindOfClass:[UITableView class]]) {
            return (UITableView *)aView;
        }
        aView = aView.superview;
    }
    return nil; // this view is not within a tableView
}

- (void) selectColor{
    self.lblColorValue.textColor = [ClarksColors clarksMenuButtonGreen1Alpha];
    self.lblProductCodeValue.textColor = [ClarksColors clarksMenuButtonGreen1Alpha];
    self.lblWholesalePriceValue.textColor = [ClarksColors clarksMenuButtonGreen1Alpha];
    self.lblRetailPriceValue.textColor = [ClarksColors clarksMenuButtonGreen1Alpha];
//    self.lblSockValue.textColor = [ClarksColors clarksBlack];
//    self.lblLiningValue.textColor = [ClarksColors clarksBlack];
}

- (void) deSelectColor{
    self.lblColorValue.textColor = [ClarksColors clarksBlack];
    self.lblProductCodeValue.textColor = [ClarksColors clarksBlack];
    self.lblWholesalePriceValue.textColor = [ClarksColors clarksBlack];
    self.lblRetailPriceValue.textColor = [ClarksColors clarksBlack];
//    self.lblSockValue.textColor = [ClarksColors clarksBlack];
//    self.lblLiningValue.textColor = [ClarksColors clarksBlack];
}
@end
