//
//  Tools.h
//  RSSReader
//
//  Created by Vladimir on 28.08.13.
//  Copyright (c) 2013 Vladimir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface Tools : NSObject

+ (BOOL)isFirstLaunch;
+ (AppDelegate *)getAppDelegate;
+ (NSDate *)getDefaultDate;
+ (NSString *)getFormat:(NSString *)format forDate:(NSDate *)date;

@end
