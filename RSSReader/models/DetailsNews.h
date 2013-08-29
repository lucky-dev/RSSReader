//
//  DetailsNews.h
//  RSSReader
//
//  Created by Vladimir on 28.08.13.
//  Copyright (c) 2013 Vladimir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DetailsNews : NSManagedObject

@property (nonatomic, retain) NSString * fullText;

@end
