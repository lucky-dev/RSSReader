//
//  TypeNews.m
//  RSSReader
//
//  Created by Vladimir on 23.08.13.
//  Copyright (c) 2013 Vladimir. All rights reserved.
//

#import "TypeNews.h"

@implementation TypeNews

@synthesize title;
@synthesize typeNewsGroup;

- (id)initWithTitle:(NSString *)titleNews andTypeOfNewsGroup:(NSInteger)newsGroup
{
    self = [super init];
    
    if (self)
    {
        self.title = titleNews;
        self.typeNewsGroup = newsGroup;
    }
    
    return self;
}

@end
