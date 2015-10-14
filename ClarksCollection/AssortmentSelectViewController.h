//
//  AssortmentSelectViewController.h
//  ClarksCollection
//
//  Created by Openly on 25/09/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssortmentDatasource.h"
#import "Region.h"
#import "Assortment.h"

@interface AssortmentSelectViewController : UIViewController {
    Assortment *curAssortment;
    NSString *assortmentName ;
}
@property (strong, nonatomic) IBOutlet AssortmentDatasource *assortmentDS;
- (IBAction)openMenu:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblWelcome;
@property (weak, nonatomic) IBOutlet UILabel *lblCollectionName;
@property (weak, nonatomic) IBOutlet UILabel *lblYear;
@property (weak, nonatomic) IBOutlet UILabel *lblLine2;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic,retain)NSString *assortmentName ;
+(AssortmentSelectViewController*)getInstance ;

-(void) setRegion:(NSArray *)regionArray;
@end
