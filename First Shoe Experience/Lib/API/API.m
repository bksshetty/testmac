//
//  API.m
//  XYZ
//
//  Created by Abhilash Hebbar on 07/05/15.
//  Copyright (c) 2015 Openly. All rights reserved.
//

#import "API.h"
#import "ConnectionDelegate.h"

//
//  API.m
//  NS 360
//
//  Created by Openly on 26/08/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import "API.h"

@implementation API
//NSString * const BASE_URL = @"https://198.168.0.14:4029";
NSString * const BASE_URL = @"https://fse.clarks.openly.co";
//NSString * const BASE_URL = @"https://api-stage.ns360app.itcsecure.com";


static API *theInstance;


+ (API *) instance{
    if (theInstance == NULL) {
        theInstance = [[API alloc] init];
    }
    return theInstance;
}

- (void) put: (NSString *) path onComplete: (void(^)(NSDictionary *)) handler
{
    [self httpTransaction:path method:@"PUT" params:nil onComplete:handler];
}

- (void) get: (NSString *) path onComplete: (void(^)(NSDictionary *)) handler
{
    [self httpTransaction:path method:@"GET" params:nil onComplete:handler];
}


- (void) post: (NSString *) path params: (NSDictionary *)params onComplete: (void(^)(NSDictionary *)) handler{
    [self httpTransaction:path method:@"POST" params:params onComplete:handler];
}


// Generic transaction handler
- (void) httpTransaction: (NSString *) path method:(NSString *)transMethod params: (NSDictionary *)params onComplete: (void(^)(NSDictionary *)) handler
{
    NSString *urlString = [ NSString stringWithFormat:@"%@/%@", BASE_URL, path ];
    
    NSURL *url = [NSURL URLWithString: urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
    request.HTTPMethod = transMethod;
    
    if([transMethod isEqualToString:@"POST"]){
        request.HTTPBody = [self serializeParams:params];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    }
    
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", @"fse", @"ZWnWvKceXHmEFgSGwM7Dcab9"];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@",
                           [authData base64EncodedStringWithOptions:
                                NSDataBase64Encoding76CharacterLineLength]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    // Start the connection handler
    ConnectionDelegate *delegate = [[ConnectionDelegate alloc] initWithHandler:^(NSData *data) {
        NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSString *strErr;
        // If no result found then we got no data from service layer - means that the service layer is down
        if(results == nil)
        {
            strErr = [results valueForKey:@"error"];
            if(strErr == nil)
                strErr = NSLocalizedString(@"Error_NoServerConnection", nil);
            handler(@{@"error": strErr});
            return;
        }
        if ([@"NotAuthorized" isEqualToString:[results valueForKey:@"code"]])
        {
//            [self showErrorMessage:@"ErrorLabel_SessionExpired"];
            strErr = NSLocalizedString(@"Error_SessionExpired", nil);
            handler(@{@"error": strErr});
            return;
        }
        handler(results);
    } errorHandler:^(NSDictionary *results) {
        NSString *strErr;
        if([@"Internal error" isEqualToString:[results valueForKey:@"message"]])
        {
//            [self showErrorMessage:@"ErrorLabel_Internal"];
        }else
        {
//            [self showErrorMessage:@"ErrorLabel_NoServerConnection"];
        }
        strErr = NSLocalizedString(@"Error_Connection", nil);
        handler(@{@"error": strErr});
        return;
    } certificateErrorHandler:^{
        NSString *strErr;
        strErr = NSLocalizedString(@"Error_Connection", nil);
//        [self showErrorMessage:@"ErrorLabel_Certificate"];
        handler(@{@"error": strErr});
        return ;
    }];
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:delegate];
    [conn start];
}

- (NSData *)serializeParams:(NSDictionary *)params {
    return [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
}
@end
