//
//  ConnectionDelegate.h
//  XYZ
//
//  Created by Abhilash Hebbar on 07/05/15.
//  Copyright (c) 2015 Openly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConnectionDelegate : NSObject<NSURLConnectionDataDelegate>{
    NSMutableData *fullData;
    void (^handler) (NSData *);
    void (^networkErrorHandler) (NSDictionary *);
    void (^certificateErrorHandler) (void);
}
-(ConnectionDelegate *) initWithHandler: (void(^)(NSData *)) completionHandler errorHandler:(void(^)(NSDictionary *)) connErrHandler certificateErrorHandler: (void (^)(void)) certErrHandler;
@end