//
//  TypeNews.h
//  RSSReader
//
//  Created by Vladimir on 23.08.13.
//  Copyright (c) 2013 Vladimir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TypeNews : NSObject

- (id)initWithTitle:(NSString *)titleNews andTypeOfNewsGroup:(NSInteger)newsGroup;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSInteger typeNewsGroup;

@end
