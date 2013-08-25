//
//  Http.h
//  RSSReader
//
//  Created by Vladimir on 24.08.13.
//  Copyright (c) 2013 Vladimir. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TIMEOUT_REQUEST 30.0f
#define TYPE_REQUEST    @"GET"

@interface HttpClient : NSObject

+ (HttpClient *)sharedManager;

- (NSData *)execHttpRequest:(NSString *)url;

@end
