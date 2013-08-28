//
//  Http.m
//  RSSReader
//
//  Created by Vladimir on 24.08.13.
//  Copyright (c) 2013 Vladimir. All rights reserved.
//

#import "HttpClient.h"

static HttpClient* sharedHttpClient;
static dispatch_once_t predicate;

@implementation HttpClient

+ (HttpClient *)sharedManager
{
    dispatch_once(&predicate, ^{
        sharedHttpClient = [[HttpClient alloc] init];
    });
    
    return sharedHttpClient;
}

- (NSData *)execHttpRequest:(NSString *)url;
{
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [urlRequest setTimeoutInterval:TIMEOUT_REQUEST];
    [urlRequest setHTTPMethod:TYPE_REQUEST];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest: urlRequest
                                         returningResponse: &response
                                                     error: &error];
    
    if (error == nil)
    {
        NSLog(@"%lu bytes of data was returned.", (unsigned long)[data length]);
    }
    else
    {
        data = nil;
        
        NSLog(@"Error happened = %@", error);
    }
    
    return data;
}


@end
