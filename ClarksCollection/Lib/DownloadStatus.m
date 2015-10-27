//
//  DownloadStatus.m
//  ClarksCollection
//
//  Created by Abhilash Hebbar on 28/05/15.
//  Copyright (c) 2015 Clarks. All rights reserved.
//

#import "DownloadStatus.h"
#import "FSHelper.h"

@implementation DownloadStatus
+ (NSMutableArray *) getCurrent{
    NSString *path = [FSHelper fullPathFor:@"status.txt"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSString *cont = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        return [[cont componentsSeparatedByString:@"\n"] mutableCopy];
    }
    return [[NSMutableArray alloc] init];
}
+ (void) save: (NSArray *) data{
    NSString *path = [FSHelper fullPathFor:@"status.txt"];
    [[data componentsJoinedByString:@"\n"]
        writeToFile:path atomically:YES
        encoding:NSUTF8StringEncoding error:nil];
}

+ (void) updateAsComplete:(NSString *) url{
    NSMutableArray *cur = [self getCurrent];
    if ([cur indexOfObject:url] == NSNotFound) {
        [cur addObject:url];
    }
    [self save: cur];
}
+ (BOOL) isDownloaded:(NSString *) url{
    return [[self getCurrent] indexOfObject:url] != NSNotFound;
}
@end
