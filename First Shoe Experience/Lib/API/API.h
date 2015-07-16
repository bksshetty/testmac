//
//  API.h
//  XYZ
//
//  Created by Abhilash Hebbar on 07/05/15.
//  Copyright (c) 2015 Openly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface API : NSObject <NSURLSessionTaskDelegate>
+ (API *) instance;
- (void) get: (NSString *) path onComplete: (void(^)(NSDictionary *)) handler;
- (void) put: (NSString *) path onComplete: (void(^)(NSDictionary *)) handler;
- (void) post: (NSString *) path params: (NSDictionary *)params onComplete: (void(^)(NSDictionary *)) handler;
- (void) httpTransaction: (NSString *) path method:(NSString *)transMethod params: (NSDictionary *)params onComplete: (void(^)(NSDictionary *)) handler;
@end
