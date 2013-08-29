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
#import "GroupNews.h"

static DBManager* sharedDbManager;
static dispatch_once_t predicate;

@interface DBManager ()

- (id)initWithCustom;
- (void)deleteAllObjects:(NSString *)entityDescription;
- (NSArray *)getAllObjects:(NSString *)entityDescription;

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
    
    [self deleteAllObjects: @"GroupNews"];
    
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

- (void)deleteAllObjects:(NSString *)entityDescription
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName: entityDescription
                                              inManagedObjectContext: mManagedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [mManagedObjectContext executeFetchRequest: fetchRequest
                                                          error: &error];
    
    for (NSManagedObject *managedObject in items)
    {
        [mManagedObjectContext deleteObject:managedObject];
        NSLog(@"%@ object deleted", managedObject.description);
    }
    
    if (![mManagedObjectContext save:&error])
    {
        NSLog(@"Error deleting %@ - error:%@", entityDescription, error);
    }
}

- (NSArray *)getAllObjects:(NSString *)entityDescription
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName: entityDescription
                                              inManagedObjectContext: mManagedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [mManagedObjectContext executeFetchRequest: fetchRequest
                                                          error: &error];
    
    return items;
}

- (NSArray *)getAllNewsGroups
{
    return [self getAllObjects:@"GroupNews"];
}

- (void)removeAllNewsByGroupId:(NSInteger)groupId
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName: @"GroupNews"
                                              inManagedObjectContext: mManagedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat: @"groupId == %@", [NSNumber numberWithInteger:groupId]];
    
    [fetchRequest setPredicate:pred];
    
    NSError *error;
    NSArray *items = [mManagedObjectContext executeFetchRequest: fetchRequest
                                                          error: &error];
    
    GroupNews *groupNews = items[0];
    
    for (NSManagedObject *item in groupNews.listNews)
    {
        [mManagedObjectContext deleteObject:item];
        NSLog(@"%@ object deleted", item);
    }
    
    if (![mManagedObjectContext save:&error])
    {
        NSLog(@"Error deleting %@ - error:%@", @"GroupNews", error);
    }
}

@end
