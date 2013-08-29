//
//  DBManager.h
//  RSSReader
//
//  Created by Vladimir on 28.08.13.
//  Copyright (c) 2013 Vladimir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject

+ (DBManager *)sharedManager;
- (void)populateDbDefaultValues;
- (NSArray *)getAllNewsGroups;
- (void)removeAllNewsByGroupId:(NSInteger)groupId;

@end
