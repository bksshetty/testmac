//
//  OurBigStoriesData.m
//  ClarksCollection
//
//  Created by Openly on 05/12/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "TemplatizedData.h"

@implementation TemplatizedData
- (TemplatizedData *) initWithDict: (NSDictionary *) dict {
    if ([self init]) {
        self.headLine = [dict valueForKey:@"heading"];
        self.detailLine = [dict valueForKey:@"details"];
        self.bigImage = [dict valueForKey:@"big_image"];
        self.bigVideo = [dict valueForKey:@"bigVideo"];
        self.thumbImage = [dict valueForKey:@"image"];
        self.thumbVideo = [dict valueForKey:@"video"];
        
    }
    return self;
}
@end
