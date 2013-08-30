//
//  Tools.m
//  RSSReader
//
//  Created by Vladimir on 28.08.13.
//  Copyright (c) 2013 Vladimir. All rights reserved.
//

#import "Tools.h"

@implementation Tools

+ (BOOL)isFirstLaunch;
{
    BOOL firstLaunch = [[NSUserDefaults standardUserDefaults] boolForKey: @"first_launch"];
    
    if (!firstLaunch)
    {
        [[NSUserDefaults standardUserDefaults] setBool: YES
                                                forKey: @"first_launch"];
    }
    
    return !firstLaunch;
}

+ (AppDelegate *)getAppDelegate
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate;
}

+ (NSDate *)getDefaultDate
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSInteger comps = (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit);
    
    NSDateComponents* dateComponents = [calendar components:comps fromDate: [NSDate date]];
    [dateComponents setYear: 1970];
    [dateComponents setMonth: 1];
    [dateComponents setDay: 1];
    
    NSDate* result = [calendar dateFromComponents: dateComponents];
    
    return result;
}

+ (NSString *)getFormat:(NSString *)format forDate:(NSDate *)date
{
    static NSDateFormatter *formatter = nil;
    
    if (!formatter)
    {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [formatter setDateFormat:format];
    }
    
    return [formatter stringFromDate:date];
}

@end
