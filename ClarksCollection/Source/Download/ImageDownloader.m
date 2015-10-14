//
//  ImageDownloader.m
//  Clarks Collection
//
//  Created by Openly on 08/09/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import "ImageDownloader.h"

#import "FSHelper.h"
#import "DownloadDelegate.h"

@implementation ImageDownloader

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"co.openly.ClarksCollection"];
        sessionConfiguration.HTTPMaximumConnectionsPerHost = 20;
        
        session = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                                delegate: [[DownloadDelegate alloc] init]
                                           delegateQueue:nil];
        lowPriorityTasks = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (ImageDownloader *) instance{
    static ImageDownloader* instance;
    if (instance == nil) {
        instance = [[ImageDownloader alloc] init];
    }
    return instance;
}

- (void) setQueue: (NSArray *) theQueue{
    queue = [theQueue mutableCopy];
    
    [self removeDuplicates];
    total = (int)[queue count];
    [self removeAlreadyDownloaded];
    [self startDownload];
}

- (void) priorityDownload: (NSString *)location onComplete:(void(^)(NSData *))handler{
    if ([FSHelper fileExists:[FSHelper localPath:location]]) {
        handler([NSData dataWithContentsOfFile:[FSHelper localPath:location]]);
        return;
    }
    [self pauseLowPriorityDownloads];
    
    priorityTasks++;
    NSLog(@"Adding priority task. Total %d priority tasks.", priorityTasks);
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:location]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [data writeToFile:[FSHelper localPath:location] atomically:YES];
        handler(data);
        [queue removeObject:location];
        if (priorityTasks > 1) {
            priorityTasks--;
        }else{
            priorityTasks = 0;
        }
        if (priorityTasks == 0) {
            [self resumeLowPriorityDownloads];
            [self doNextDownloads];
        }
    }];
}


- (int) totalItems{
    return total;
}

- (int) downloadedItems{
    return  total - (int)[queue count] - (int)[[lowPriorityTasks allKeys] count];
}
-(int) nextDownloadNumber{
    return ((int)total - (int)[queue count] + 1);
}

-(void) saveToFile :(NSURL *)tmpUrl downloadedFrom: (NSURL *)location{
    NSString *locationStr = [location absoluteString];
    
    NSURL *toURL = [NSURL fileURLWithPath:[FSHelper localPath:locationStr]];
    [[NSFileManager defaultManager] copyItemAtURL:tmpUrl toURL:toURL error:nil];
    [lowPriorityTasks removeObjectForKey:locationStr];
    NSLog(@"%d of %d downloaded...", [self downloadedItems], total);
    if ([[lowPriorityTasks allKeys]count] < 10) { // allow upto 10 concurrent downloads
        [self doNextDownloads];
    }
}

-(void) doNextDownloads{
    if (queue == nil || [queue count]<1) {
        return;
    }
    if (priorityTasks >= 2) {
        NSLog(@"Cannot load more tasks. Already handling %d priority tasks", priorityTasks);
        return;
    }
    NSLog(@"Starting %dth image download.",[self nextDownloadNumber]);
    NSString *location = [queue lastObject];
    [queue removeLastObject];
    if ([FSHelper fileExists:[FSHelper localPath:location]]) {
        return [self doNextDownloads];
    }
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL: [NSURL URLWithString:location]];
    [task resume];
    if (task != nil && location != nil && lowPriorityTasks != nil) {
        [lowPriorityTasks setObject:task forKey:location];
    }
    
}

- (void) startDownload{
    [self doNextDownloads];
    [self doNextDownloads];
    [self doNextDownloads];
    [self doNextDownloads];
    [self doNextDownloads];
    [self doNextDownloads];
    [self doNextDownloads];
    [self doNextDownloads];
}

- (void) removeDuplicates{
    if (queue != nil) {
        NSSet *mySet = [[NSSet alloc] initWithArray:queue];
        queue = [[mySet allObjects] mutableCopy];
    }
    
}

-(void) removeAlreadyDownloaded{
    NSMutableArray *newQueue = [[NSMutableArray alloc] init];
    int i ;
    for (i=0; i<[queue count]; i++) {
        if ( ![FSHelper fileExists:[FSHelper localPath:queue[i]]] && i < [queue count]) {
            [newQueue addObject:queue[i]];
        }
    }
    queue = newQueue;
}
-(void)pauseLowPriorityDownloads{
    //    NSLog(@"Pausing low priority downloads..");
    //    NSArray *keys = [lowPriorityTasks allKeys];
    //    for (NSString *key in keys) {
    //        NSURLSessionDownloadTask *task = ((NSURLSessionDownloadTask *) [lowPriorityTasks valueForKey:key]);
    //        if (task != nil && task.state ==NSURLSessionTaskStateRunning) {
    //            [task suspend];
    //        }
    //    }
}
-(void) resumeLowPriorityDownloads{
    //    NSLog(@"Resuming low priority downloads..");
    //    for (id key in lowPriorityTasks) {
    //        NSURLSessionDownloadTask *task = ((NSURLSessionDownloadTask *) [lowPriorityTasks valueForKey:key]);
    //        if (task != nil && task.state == NSURLSessionTaskStateSuspended ) {
    //            [task resume];
    //        }
    //    }
}

-(void) reActivate{
    for(NSString *key in [lowPriorityTasks allKeys]){
        NSURLSessionDownloadTask *taks = [lowPriorityTasks valueForKey:key];
        if ([taks state] == NSURLSessionTaskStateCanceling || [taks state] == NSURLSessionTaskStateSuspended) {
            NSLog(@"Task canceled or suspended. (URL: %@)", [taks.currentRequest.URL absoluteString]);
            [lowPriorityTasks removeObjectForKey:key];
            NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:taks.currentRequest];
            [task resume];
            [lowPriorityTasks setObject:task forKey:key];
        }
        else if([taks state] == NSURLSessionTaskStateCompleted){
            [lowPriorityTasks removeObjectForKey:key];
            [self doNextDownloads];
        }
    }
    if ([[lowPriorityTasks allKeys] count] < 3) {
        [self startDownload];
    }
}
-(void) refreshCount{
    [self removeAlreadyDownloaded];
}
@end