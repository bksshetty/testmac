//
//  ImageDownloadManager.m
//  Clarks Collection
//
//  Created by Openly on 09/09/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import "ImageDownloadManager.h"

#import "ImageDownloader.h"

#import "Item.h"
#import "ItemColor.h"
#import "Region.h"
#import "MarketingCategory.h"
#import "DiscoverCollection.h"

@implementation ImageDownloadManager

+ (void) preload{
    NSThread* downloadThread = [[NSThread alloc] initWithTarget:self
                                                 selector:@selector(doPrepload)
                                                   object:nil];
    [downloadThread start];
}

+ (void) doPrepload{
    NSLog(@"Starting image preload...");
    NSMutableArray *downloadList = [[NSMutableArray alloc] init];
    NSMutableArray *thumbList = [[NSMutableArray alloc] init];
    NSMutableArray *colorThumbList = [[NSMutableArray alloc] init];
    NSMutableArray *mediumList = [[NSMutableArray alloc] init];
    NSMutableArray *largeList = [[NSMutableArray alloc] init];
    NSMutableArray *image360List = [[NSMutableArray alloc] init];
    
    NSMutableArray *marketingImagesList = [[NSMutableArray alloc] init];
    NSMutableArray *discoverImagesList = [[NSMutableArray alloc] init];
    
    NSArray *discoverCollectionArray = [DiscoverCollection loadAll];
    for(DiscoverCollection *theDiscoverCollection in discoverCollectionArray) {
        [discoverImagesList addObject:theDiscoverCollection.headerImage];
        [discoverImagesList addObjectsFromArray:theDiscoverCollection.detailImages];
    }
    
    NSArray *marketingCategory = [MarketingCategory loadAll];
    for(MarketingCategory *theCategory in marketingCategory) {
        NSArray *theMaterialArray = theCategory.marketingMaterials;
        for(MarketingMaterial *marketingMaterial in theMaterialArray) {
            if(marketingMaterial.isTemplatized == NO) {
                [marketingImagesList addObject:marketingMaterial.headerImage];
                [marketingImagesList addObjectsFromArray:marketingMaterial.detailImages];
            }
            else {
                NSArray *theTemplatizedDataArray = marketingMaterial.templatizedData;
                for(TemplatizedData *theTemplatizedData in theTemplatizedDataArray) {
                    [marketingImagesList addObject:theTemplatizedData.bigImage];
                    [marketingImagesList addObject:theTemplatizedData.thumbImage];
                }
            }
        }
    }
    
    NSArray *regions = [Region loadAll] ; //[[NSArray alloc]initWithArray:[Region loadAll]];
    for (int i =0; i<[regions count]; i++) {
        NSArray *assorts = ((Region *) regions[i]).assortments;
        for (int j =0; j<[assorts count]; j++) {
            NSArray *colls = ((Assortment *) assorts[j]).collections;
            for (int k =0; k<[colls count]; k++) {
                NSArray *items = ((Collection *) colls[k]).items;
                for (int l =0; l<[items count]; l++) {
                    [thumbList addObject: ((Item *) items[l]).image];
                    NSArray *colors = ((Item *) items[l]).colors;
                    for (int m =0; m<[colors count]; m++) {
                        [colorThumbList addObjectsFromArray:((ItemColor *) colors[m]).thumbs];
                        [mediumList addObjectsFromArray:((ItemColor *) colors[m]).mediumImages];
                        [largeList addObjectsFromArray:((ItemColor *) colors[m]).largeImages];
                        [image360List addObjectsFromArray:((ItemColor *) colors[m]).images360];
                    }
                }
            }
        }
    }
    
    [downloadList addObjectsFromArray:discoverImagesList];
    [downloadList addObjectsFromArray:marketingImagesList];
    [downloadList addObjectsFromArray:image360List];
    [downloadList addObjectsFromArray:largeList];
    [downloadList addObjectsFromArray:mediumList];
    [downloadList addObjectsFromArray:colorThumbList];
    [downloadList addObjectsFromArray:thumbList];
    
    [[ImageDownloader instance] setQueue:downloadList];
}

+ (void) downloadNow: (NSString *) location onComplete:(void (^)(NSData *))handler{
    [[ImageDownloader instance] priorityDownload:location onComplete:handler];
}
@end
