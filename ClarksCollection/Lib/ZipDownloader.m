//
//  ZipDownloader.m
//  ClarksCollection
//
//  Created by Abhilash Hebbar on 27/05/15.
//  Copyright (c) 2015 Clarks. All rights reserved.
//

#import "ZipDownloader.h"
#import "DownloadItem.h"
#import "SSZipArchive.h"
#import "FSHelper.h"
#import "DownloadStatus.h"
#import "ImageDownloader.h"

@implementation ZipDownloader{
    NSURLSession *session;
}

static ZipDownloader *instance;

- (NSURLSession *) getSession{
    if (session != nil) {
        return session;
    }
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration
            backgroundSessionConfigurationWithIdentifier:
                @"co.openly.ClarksCollection-zip"];
    
    sessionConfiguration.HTTPMaximumConnectionsPerHost = 20;
    
    session = [NSURLSession sessionWithConfiguration:sessionConfiguration
                            delegate: self
                            delegateQueue:nil];
    return session;
}

- (void) doDownload: (NSString *) url
         onComplete:
        (void(^)(NSURLSessionDownloadTask *))handler{
    NSURLSession *theSession = [self getSession];
    [theSession getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        NSURLSessionDownloadTask *task = nil;
        for (NSURLSessionDownloadTask *eTask in downloadTasks) {
            if ([[eTask.originalRequest.URL absoluteString] isEqualToString:url]) {
                [eTask cancel];
            }
        }
        task = [theSession downloadTaskWithURL:
                        [NSURL URLWithString:url]];
        [task resume];
        
        handler(task);
    }];
}

+ (void) download: (NSString *) url onComplete:(void(^)(NSURLSessionDownloadTask *))handler{
    if (instance == nil) {
        instance = [[ZipDownloader alloc] init];
    }
    url = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSLog(@"Start download: %@",url);
    
    return [instance doDownload:url onComplete:handler];
}

- (void)URLSession:(NSURLSession *)session
        downloadTask:(NSURLSessionDownloadTask *)downloadTask
        didFinishDownloadingToURL:(NSURL *)location{
    
    DownloadItem *theItem = [self itemForTask:downloadTask];
    if (theItem != nil) {
        theItem.status = COMPLETED;
        NSString *dest = [FSHelper fullPathFor:@""];
        NSLog(@"Unzipping %@ from %@ to %@", theItem.title,[location absoluteString], dest);
        if ([SSZipArchive unzipFileAtPath:[location path] toDestination:dest]) {
            [DownloadStatus updateAsComplete: theItem.url];
            NSLog(@"Unzip success");
        }else{
            NSLog(@"Unzip failed");
        }
        [[ImageDownloader instance] removeAlreadyDownloaded];
        //[[ImageDownloader instance] refreshCount];
    }
}

- (void)URLSession:(NSURLSession *)session
        downloadTask:(NSURLSessionDownloadTask *)downloadTask
        didWriteData:(int64_t)bytesWritten
        totalBytesWritten:(int64_t)totalBytesWritten
        totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    
    DownloadItem *theItem = [self itemForTask:downloadTask];
    NSLog(@"Downloading %@: %lld of %lld", theItem.title,
          totalBytesWritten, totalBytesExpectedToWrite);
    theItem.fileSize = totalBytesExpectedToWrite;
    theItem.downloadedSize = totalBytesWritten;
}

- (void)URLSession:(NSURLSession *)session
        downloadTask:(NSURLSessionDownloadTask *)downloadTask
        didResumeAtOffset:(int64_t)fileOffset
        expectedTotalBytes:(int64_t)expectedTotalBytes{
    
    
}

- (void)URLSession:(NSURLSession *)session
        didBecomeInvalidWithError:(NSError *)error{
    
}

- (DownloadItem *) itemForTask:(NSURLSessionDownloadTask *) task{
    for (DownloadItem *item in [DownloadItem getAll]) {
        if ([item taskID] ==  task.taskIdentifier) {
            return item;
        }
    }
    return nil;
}

@end
