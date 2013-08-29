//
//  DBManager.m
//  RSSReader
//
//  Created by Vladimir on 28.08.13.
//  Copyright (c) 2013 Vladimir. All rights reserved.
//

#import "DBManager.h"
#import "Tools.h"
#import "News.h"
#import "DetailsNews.h"
#import "GroupNews.h"

static DBManager* sharedDbManager;
static dispatch_once_t predicate;

@interface DBManager ()

- (id)initWithCustom;
- (void)deleteAllObjects:(NSString *)entityDescription withPredicate:(NSPredicate *)pred;
- (NSArray *)getObjects: (NSString *)entityDescription
          withPredicate: (NSPredicate *)predicate
      andSortDescriptor: (NSSortDescriptor *)sortDescriptor;
- (void)removeAllNewsByGroupId:(NSInteger)groupId;

@end

@implementation DBManager
{
    __weak NSManagedObjectContext *mManagedObjectContext;
}

+ (DBManager *)sharedManager
{
    dispatch_once(&predicate, ^{
        sharedDbManager = [[DBManager alloc] initWithCustom];
    });
    
    return sharedDbManager;
}

- (id)initWithCustom
{
    self = [super init];
    if (self)
    {
        AppDelegate *appDelegate = [Tools getAppDelegate];
        
        mManagedObjectContext = appDelegate.managedObjectContext;
    }
    
    return self;
}

- (void)populateDbDefaultValues
{
    NSError *err = nil;
    NSString *dataPath = [[NSBundle mainBundle] pathForResource: @"init_data" ofType:@"json"];
    NSDictionary *mainObject = [NSJSONSerialization JSONObjectWithData: [NSData dataWithContentsOfFile:dataPath]
                                                               options: kNilOptions
                                                                 error: &err];
    
    NSArray *listNewsGroups = [mainObject objectForKey:@"news_categories"];
    
    [self deleteAllObjects: @"GroupNews" withPredicate:nil];
    
    [listNewsGroups enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        GroupNews *groupNews = [NSEntityDescription
                                insertNewObjectForEntityForName: @"GroupNews"
                                         inManagedObjectContext: mManagedObjectContext];
        groupNews.name = [obj objectForKey:@"name"];
        groupNews.link = [obj objectForKey:@"link"];
        groupNews.date_last_updated = [Tools getDefaultDate];
        groupNews.groupId = [obj objectForKey:@"id"];
        groupNews.listNews = nil;
        
        NSError *error;
        if (![mManagedObjectContext save:&error])
        {
            NSLog(@"Couldn't save: %@", [error localizedDescription]);
        }
    }];
}

- (void)deleteAllObjects:(NSString *)entityDescription withPredicate:(NSPredicate *)pred
{
    NSArray *items = [self getObjects:entityDescription withPredicate:pred andSortDescriptor:nil];
    
    for (NSManagedObject *managedObject in items)
    {
        [mManagedObjectContext deleteObject:managedObject];
        NSLog(@"%@ object deleted", managedObject.description);
    }
    
    NSError *error;
    if (![mManagedObjectContext save:&error])
    {
        NSLog(@"Error deleting %@ - error:%@", entityDescription, error);
    }
}

- (NSArray *)getObjects: (NSString *)entityDescription
          withPredicate: (NSPredicate *)predicate
      andSortDescriptor:  (NSSortDescriptor *)sortDescriptor
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName: entityDescription
                                              inManagedObjectContext: mManagedObjectContext];
    [fetchRequest setEntity:entity];
    
    if (predicate)
    {
        [fetchRequest setPredicate:predicate];
    }
    
    if (sortDescriptor)
    {
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    }
    
    NSError *error;
    NSArray *items = [mManagedObjectContext executeFetchRequest: fetchRequest
                                                          error: &error];
    
    return items;
}

- (NSArray *)getAllNewsGroups
{
    NSSortDescriptor *sortByGroupId = [[NSSortDescriptor alloc]
                                       initWithKey: @"groupId"
                                         ascending: YES];
    
    return [self getObjects:@"GroupNews" withPredicate:nil andSortDescriptor:sortByGroupId];
}

- (void)removeAllNewsByGroupId:(NSInteger)groupId
{    
    NSPredicate *pred = [NSPredicate predicateWithFormat: @"group.groupId == %@", [NSNumber numberWithInteger:groupId]];
    
    [self deleteAllObjects:@"News" withPredicate:pred];
}

- (void)addNewsFromList:(NSArray *)listNews forGroupId:(NSInteger)groupId
{
    [self removeAllNewsByGroupId:groupId];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat: @"groupId == %@", [NSNumber numberWithInteger:groupId]];
    
    NSArray *items = [self getObjects:@"GroupNews" withPredicate:pred andSortDescriptor:nil];
    
    GroupNews *groupNews = items[0];
    
    groupNews.date_last_updated = [NSDate date];
    
    for (NSDictionary *dict in listNews)
    {
        News *news = [NSEntityDescription
                      insertNewObjectForEntityForName: @"News"
                      inManagedObjectContext: mManagedObjectContext];
        news.title = [dict objectForKey:@"title"];
        news.pubDate = [dict objectForKey:@"pubDate"];
        news.linkImage = [dict objectForKey:@"linkImage"];
        
        DetailsNews *detailsNews = [NSEntityDescription
                      insertNewObjectForEntityForName: @"DetailsNews"
                      inManagedObjectContext: mManagedObjectContext];
        detailsNews.fullText = [dict objectForKey:@"fullText"];
        
        news.detailsNews = detailsNews;
        
        [groupNews addListNewsObject:news];
    }
    
    NSError *error;
    if (![mManagedObjectContext save:&error])
    {
        NSLog(@"Error saving %@ - error:%@", @"GroupNews", error);
    }
}

- (NSArray *)getAllNewsByGroupId:(NSInteger)groupId
{
    NSPredicate *pred = [NSPredicate predicateWithFormat: @"group.groupId == %@", [NSNumber numberWithInteger:groupId]];

    NSSortDescriptor *sortByGroupId = [[NSSortDescriptor alloc]
                                       initWithKey: @"pubDate"
                                       ascending: NO];
    
    NSArray *items = [self getObjects: @"News"
                        withPredicate: pred
                    andSortDescriptor: sortByGroupId];
    
    return items;
}

@end
