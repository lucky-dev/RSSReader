//
//  Task.h
//  RSSReader
//
//  Created by Vladimir on 24.08.13.
//  Copyright (c) 2013 Vladimir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject

@property (nonatomic, assign, readonly) NSInteger idNewsGroup;

- (id)initWithIdGroup:(NSInteger)idGroup;

@end
