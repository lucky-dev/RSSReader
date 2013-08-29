//
//  GroupNews.h
//  RSSReader
//
//  Created by Vladimir on 29.08.13.
//  Copyright (c) 2013 Vladimir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class News;

@interface GroupNews : NSManagedObject

@property (nonatomic, retain) NSDate * date_last_updated;
@property (nonatomic, retain) NSNumber * groupId;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *listNews;
@end

@interface GroupNews (CoreDataGeneratedAccessors)

- (void)addListNewsObject:(News *)value;
- (void)removeListNewsObject:(News *)value;
- (void)addListNews:(NSSet *)values;
- (void)removeListNews:(NSSet *)values;

@end
