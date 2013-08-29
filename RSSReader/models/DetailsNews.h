//
//  DetailsNews.h
//  RSSReader
//
//  Created by Vladimir on 29.08.13.
//  Copyright (c) 2013 Vladimir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class News;

@interface DetailsNews : NSManagedObject

@property (nonatomic, retain) NSString * fullText;
@property (nonatomic, retain) News *news;

@end
