//
//  Task.m
//  RSSReader
//
//  Created by Vladimir on 24.08.13.
//  Copyright (c) 2013 Vladimir. All rights reserved.
//

#import "Task.h"

@implementation Task

@synthesize idNewsGroup;

- (id)initWithIdGroup:(NSInteger)idGroup
{
    self = [super init];
    
    if (self)
    {
        idNewsGroup = idGroup;
    }
    
    return self;
}

@end
