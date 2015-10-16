//
//  itemInListCollectionViewDataSource.m
//  ClarksCollection
//
//  Created by Openly on 05/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "itemInListCollectionViewDataSource.h"
#import "ClarksFonts.h"
#import "ManagedImage.h"
#import "CollectionViewCellButton.h"
#import "AppDelegate.h"
#import "TechImageView.h"
#import "DataReader.h"
#import "ImageDownloader.h"
#import "Techlogos.h"
#import "MarketingMaterial.h"
#import "MarketingCategory.h"
#import "MarketingDetailViewController.h"
#import "MixPanelUtil.h"
#import "Mixpanel.h"
#import "DiscoverCollectionDetailViewController.h"
#import "SingleShoeViewController.h"



@implementation itemInListCollectionViewDataSource{
    int i;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item-in-list-grid" forIndexPath:indexPath];

    [[cell viewWithTag:1 ] removeFromSuperview];
    [[cell viewWithTag:2 ] removeFromSuperview];

    ListItem *theListItem = self.parentVC.list.listOfItems[indexPath.row];
    
    UILabel *lblName = (UILabel *)[cell viewWithTag:120];
    [lblName setFont:[ClarksFonts clarksNarzissMediumBd:30.0f]];
    lblName.text = theListItem.name ;
    
    UILabel *lblColorName = (UILabel *)[cell viewWithTag:121];
    [lblColorName setFont:[ClarksFonts clarksSansProRegular:9.0f]];
    lblColorName.text = [theListItem.itemColor uppercaseString];
    
    ManagedImage *shoeImage= (ManagedImage *)[cell viewWithTag:122];
    [shoeImage loadImage: theListItem.imageLarge];
    shoeImage.contentMode = UIViewContentModeScaleAspectFit;
    

    //UIImageView *techImage = (UIImageView *) [cell viewWithTag:300];
    
    //techImage.contentMode = UIViewContentModeScaleAspectFit;
    for(int i= 123; i<125; i++) {
        UILabel *lbl = (UILabel *)[cell viewWithTag:i];
        [lbl setFont:[ClarksFonts clarksSansProRegular:9.0f]];
    }
    
    UILabel *wholesale = (UILabel *)[cell viewWithTag:125];
    [wholesale setFont:[ClarksFonts clarksSansProRegular:16.0f]];
    float floatVal = fabsf([theListItem.wholeSalePrice floatValue]);
    
    if(floatVal > .1) {
        wholesale.hidden = NO;
        wholesale.text = [NSString stringWithFormat:@"£%.02f",floatVal];
        [(UILabel *)[cell viewWithTag:123] setHidden:NO];
        [(UIImageView *)[cell viewWithTag:150] setHidden:NO];
    }
    else {
        wholesale.hidden=YES;
        wholesale.text = @"";
        [(UILabel *)[cell viewWithTag:123] setHidden:YES];
        [(UIImageView *)[cell viewWithTag:150] setHidden:YES];
    }
    
    floatVal = fabsf([theListItem.retailPrice floatValue]);
    UILabel *retail = (UILabel *)[cell viewWithTag:126];
    [retail setFont:[ClarksFonts clarksSansProRegular:16.0f]];
    if(floatVal > .1){
        retail.text = [NSString stringWithFormat:@"£%.02f",floatVal];
        retail.hidden = NO;
        [(UILabel *)[cell viewWithTag:124] setHidden:NO];
        [(UIImageView *)[cell viewWithTag:151] setHidden:NO];
    }
    else {
        retail.text = @"";
        retail.hidden = YES;
        [(UILabel *)[cell viewWithTag:124] setHidden:YES];
        [(UIImageView *)[cell viewWithTag:151] setHidden:YES];
    }
    
    NSString *str = theListItem.collectionName;
    NSArray *components = [str componentsSeparatedByString:@" - "];

    
  //  discover_coll
    NSDictionary *collectionLogosObjs = [[Techlogos getAllAsortImages] valueForKey:[components lastObject]];
    self.discover_name = [components lastObject];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.discoverColl = [components lastObject];
    NSString *colLogoUrls = [collectionLogosObjs valueForKey:@"logo"] ;
    
    UIButton *collectionImage = (UIButton *)[cell viewWithTag:127];
    [[ImageDownloader instance] priorityDownload:colLogoUrls onComplete:^(NSData *theData) {
        UIImage *colImage = [UIImage imageWithData:theData];
        [collectionImage setBackgroundImage:colImage forState:UIControlStateNormal];
        //collectionImage.imageView.image = colImage;
    }] ;
    
    for (UIView *oldViews in cell.subviews)
    {
        if([oldViews isKindOfClass:[TechImageView class]])
            [oldViews removeFromSuperview];
    }
    
    i=0;
    
    for (NSString *tech in theListItem.technologies) {
        NSString *imgName = [NSString stringWithFormat:@"%@",[tech stringByReplacingOccurrencesOfString:@" " withString:@"-"]];
        imgName = [imgName lowercaseString];
        NSDictionary *techLogoObjs  = [[Techlogos getAllTechURLS] valueForKey:imgName];
        NSString *techLogos_urls = [techLogoObjs valueForKey:@"logo"];
        
        [[ImageDownloader instance] priorityDownload:techLogos_urls onComplete:^(NSData *theData) {
            
            TechImageView *techImage = [[TechImageView alloc] initWithData:theData fori:i++ techLogos:techLogoObjs] ;
            
            // Adding a button overlay for the technology logo image view.
            UIButton *techImgBtn = [[UIButton alloc] initWithFrame:techImage.frame];
            [techImgBtn setImage:techImage.image forState:UIControlStateNormal];
            [techImgBtn setTitle:[techLogoObjs valueForKey:@"story_name"] forState:UIControlStateNormal];
            
            // Adding a action "onClick" to the button overlay.
            [techImgBtn addTarget:self action:@selector(onTechClick:) forControlEvents:UIControlEventTouchUpInside];
            techImgBtn.adjustsImageWhenHighlighted = NO;
            
            // Inserting a tag(identifier) to the tech button overlay.
            techImgBtn.tag = i ;
            [cell addSubview:techImgBtn];
            
        }] ;
        if(i >1) // Max 2 images
            break;
    }
    if (!self.parentVC.readOnly) {
        CollectionViewCellButton *deleteButton = [self makeDeleteButtonForCell:cell];
        deleteButton.indexPath = (int)indexPath.row;
        [cell addSubview:deleteButton];
    }
    return cell;
}

// Method to link the tech logo to the appropriate inside story.
-(void)onTechClick: (UIButton *)btn{

    NSLog(@"I am here");
    NSString *curTech = [[btn titleForState:UIControlStateNormal] lowercaseString];
    NSArray *categories = [MarketingCategory loadAll];
    for (MarketingCategory *cat in categories) {
        if ([cat.name isEqualToString:@"Inside Stories"]) {
            for (MarketingMaterial *mat in cat.marketingMaterials) {
                if ([[mat.name lowercaseString] isEqualToString:curTech]) {
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                    MarketingDetailViewController *mdvc = [storyboard instantiateViewControllerWithIdentifier:@"marketing_detail"];
                    [[MixPanelUtil instance] track:@"tech_logo_clicked"];
                    mdvc.theMarketingData = mat;
                    
                    UINavigationController *navigationController = self.parentVC.navigationController;
                
                    [navigationController pushViewController:mdvc animated:YES];
                    
                    return;
                }
            }
        }
    }
}


-(CollectionViewCellButton *)makeDeleteButtonForCell:(UICollectionViewCell *)cell
{
    CollectionViewCellButton *button = [CollectionViewCellButton buttonWithType:UIButtonTypeCustom];
    button.cell = cell;
    UIImage *image;
    
   image = [UIImage imageNamed:@"grey-close"];

    
    CGFloat width = image.size.width / 2;
    CGFloat height = image.size.height / 2;
    CGFloat X = 303;
    CGFloat Y = 27;
    
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
    CollectionViewCellButton *button = (CollectionViewCellButton *)sender;
    int indexPath = button.indexPath;
    [self.parentVC.list.listOfItems removeObjectAtIndex:indexPath];
    
    [self.parentVC.gridView reloadData];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate saveList];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    int count;
    //    count = self.itemArray.count;
    count = (int)[self.parentVC.list.listOfItems count];
    return count;
}

@end
