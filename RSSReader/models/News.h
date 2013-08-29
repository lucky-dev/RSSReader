//
//  News.h
//  RSSReader
//
//  Created by Vladimir on 29.08.13.
//  Copyright (c) 2013 Vladimir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DetailsNews, GroupNews;

@interface News : NSManagedObject

@property (nonatomic, retain) NSString * linkImage;
@property (nonatomic, retain) NSDate * pubDate;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) DetailsNews *detailsNews;
@property (nonatomic, retain) GroupNews *group;

@end
