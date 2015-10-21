//
//  DiscoverCollection.m
//  ClarksCollection
//
//  Created by Openly on 17/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "DiscoverCollection.h"
#import "DataReader.h"

@implementation DiscoverCollection

+(NSArray *) loadAll{
    NSArray *womensDisplayOrder = [[NSArray alloc]initWithObjects:@"Narrative", @"Artisan",@"Somerset",@"Collection",nil];
    NSArray *mensDisplayOrder = [[NSArray alloc]initWithObjects:@"Tor", @"Est 1825",@"Collection",nil];
    
    NSDictionary *data = [DataReader read];
    
    NSMutableArray *discoverCollections = [[NSMutableArray alloc] init];
    NSArray *jsonDC = [data valueForKey:@"discover_collections"];
    
    DiscoverCollection *theCollection;
    int i;
    for (i = 0; i < [jsonDC count]; i++) {
        NSDictionary *dict = jsonDC[i];
        theCollection = [DiscoverCollection alloc];
        theCollection.assortmentName = [dict valueForKey:@"assortment"];
        theCollection.collectionName = [dict valueForKey:@"collection"];
        theCollection.headerImage = [dict valueForKey:@"header_image"];
        NSArray *arr = [dict valueForKey:@"detail_images"];
        theCollection.detailImages = [[NSMutableArray alloc]initWithArray:arr];
        [discoverCollections addObject:theCollection];
    }
    
    NSMutableArray *orderedDiscoverCollections = [[NSMutableArray alloc] init];
    
    for(NSString *womenOrder in womensDisplayOrder) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collectionName ==[c] %@ AND assortmentName ==[c] 'Women'", womenOrder];
        
         [orderedDiscoverCollections addObjectsFromArray:[[discoverCollections filteredArrayUsingPredicate:predicate] mutableCopy]];
    }
    
    for(NSString *mensOrder in mensDisplayOrder) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collectionName == [c] %@ AND assortmentName ==[c] 'Mens'", mensOrder];
        
        [orderedDiscoverCollections addObjectsFromArray:[[discoverCollections filteredArrayUsingPredicate:predicate] mutableCopy]];
    }
    return orderedDiscoverCollections;
    
}

@end
