                     //
//  Region.m
//  Clarks Collection
//
//  Created by Openly on 04/09/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import "Region.h"
#import "AppDelegate.h"
#import "DataReader.h"

@class ItemColor;

@implementation Region

static Region *current;
static NSMutableArray *regions;

+(NSArray *) loadAll{
    if (regions != nil && [regions count] !=0) {
        return regions;
    }
    [ItemColor resetIdx];
    NSDictionary *data = [DataReader read];
    
    int version = [[data valueForKey:@"version"] intValue];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.dataVersion = version;
    
    if (regions == nil) {
        regions = [[NSMutableArray alloc] init];
    }
    NSArray *jsonRegions = [data valueForKey:@"regions"];
    NSLog(@"%lu", (unsigned long)[jsonRegions count]);
    for (int i = 0; i < [jsonRegions count]; i++) {
        [regions addObject:[[Region alloc] initWithDict:jsonRegions[i]]];
    }
    return regions;
}

+ (void) setCurrent: (Region *) region{
    current = region;
}

+(Region *) getCurrent{
    return current;
}
+(void) clearRegions{
    [regions removeAllObjects];
}

-(Region *) initWithDict: (NSDictionary *) dict{
    if ([self init]) {
        self.name = [dict valueForKey:@"name"];
        self.image = [dict valueForKey:@"image"];
        NSArray *curAssortments = [dict valueForKey:@"assortments"];
        NSMutableArray *assortments = [[NSMutableArray alloc] init];
        for (int i =0; i<[curAssortments count]; i++) {
            [assortments addObject:[[Assortment alloc] initWithDict: curAssortments[i]]];
        }
        self.assortments = assortments;
    }
    return self;
}
@end
