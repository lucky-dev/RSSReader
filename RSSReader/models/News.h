//
//  News.h
//  RSSReader
//
//  Created by Vladimir on 28.08.13.
//  Copyright (c) 2013 Vladimir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DetailsNews;

@interface News : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * pubDate;
@property (nonatomic, retain) NSString * linkImage;
@property (nonatomic, retain) DetailsNews *detailsNews;

@end
