//
//  DiscoverCollectionDataSource.m
//  ClarksCollection
//
//  Created by Openly on 17/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "DiscoverCollectionDataSource.h"
#import "DiscoverCollection.h"
#import "DiscoverCollectionViewController.h"
#import "ManagedImage.h"
#import "AppDelegate.h"

@implementation DiscoverCollectionDataSource{
    NSArray *allCollections;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        allCollections = [DiscoverCollection loadAll];
    }
    return self;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [allCollections count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"discover_cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    ManagedImage *collectionImage = (ManagedImage *)[cell viewWithTag:100];
    DiscoverCollection *theDiscoverCollection =[allCollections objectAtIndex:indexPath.row];
 
    NSString *imageName = theDiscoverCollection.headerImage;
    collectionImage.image = [UIImage imageNamed:@"translucent"];
    [collectionImage loadImage:imageName];
    
    return cell;
}
@end
