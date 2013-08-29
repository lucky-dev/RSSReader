//
//  DownloaderManager.m
//  RSSReader
//
//  Created by Vladimir on 24.08.13.
//  Copyright (c) 2013 Vladimir. All rights reserved.
//

#import "DownloaderManager.h"
#import "Constants.h"
#import "Task.h"
#import "HttpClient.h"
#import "DBManager.h"
#import "XMLParser.h"

static DownloaderManager* sharedDownloaderManager;
static dispatch_once_t predicate;

@interface DownloaderManager ()

- (id) initCustom;
- (void)addTask:(Task *)task;
- (void)notifyOnStart:(NSInteger)idGroup;
- (void)notifyOnStop:(NSInteger)idGroup;

@property (nonatomic, assign) BOOL isExecute;
@property (nonatomic, strong) XMLParser *parser;

@end

@implementation DownloaderManager
{
    NSMutableArray *mTasks;
    NSDictionary *mLinksNews;
    HttpClient *mHttpClient;
    NSMutableArray *mObservers;
    DBManager *mDbManager;
}

+ (DownloaderManager *)sharedManager
{
    dispatch_once(&predicate, ^{
        sharedDownloaderManager = [[DownloaderManager alloc] initCustom];
    });
    
    return sharedDownloaderManager;
}

- (id)initCustom
{
    self = [super init];
    
    if (self)
    {
        self.isExecute = NO;
        
        mTasks = [[NSMutableArray alloc] init];
        
        mLinksNews = [[NSDictionary alloc] initWithObjectsAndKeys:
                       LINK_LAST, [NSNumber numberWithInt:TYPE_NEWS_LAST],
                       LINK_UKRAINE, [NSNumber numberWithInt:TYPE_NEWS_UKRAINE],
                       LINK_BUSINESS, [NSNumber numberWithInt:TYPE_NEWS_BUSINESS],
                       LINK_WORLD_ABOUT_US, [NSNumber numberWithInt:TYPE_NEWS_WORLD_ABOUT_US],
                       LINK_SHOWBIZ, [NSNumber numberWithInt:TYPE_NEWS_SHOWBIZ],
                       LINK_WORLD, [NSNumber numberWithInt:TYPE_NEWS_WORLD],
                       LINK_TECH, [NSNumber numberWithInt:TYPE_NEWS_TECH],
                       LINK_SPORT, [NSNumber numberWithInt:TYPE_NEWS_SPORT],
                       nil];
        
        mHttpClient = [HttpClient sharedManager];
        
        mObservers = [[NSMutableArray alloc] init];
        
        mDbManager = [DBManager sharedManager];
    }
    
    return self;
}

- (void)addTask:(Task *)task
{
    [mTasks addObject:task];
    NSLog(@"Task was added");
}

- (BOOL)taskExistsWithGroupId:(NSInteger)taskId
{    
    BOOL isExists = false;
    for (Task *item in mTasks)
    {
        if (item.idNewsGroup == taskId)
        {
            isExists = true;
            break;
        }
    }
    
    return isExists;
}

- (void)addObserver:(id<DownloaderManagerDelegate>)observer
{
    NSValue *_observer = [NSValue valueWithNonretainedObject:observer];
    
    [mObservers addObject:_observer];
    
    NSLog(@"Observer was added: %d", [mObservers count]);
}

- (void)removeObserver:(id<DownloaderManagerDelegate>)observer
{
    NSValue *_observer = [NSValue valueWithNonretainedObject:observer];
    
    [mObservers removeObject:_observer];
    
    NSLog(@"Observer was removed: %d", [mObservers count]);
}

- (void)notifyOnStart:(NSInteger)idGroup
{
    for (NSValue *item in mObservers)
    {
        id<DownloaderManagerDelegate> observer = [item nonretainedObjectValue];
        [observer onStart:idGroup];
    }
}

- (void)notifyOnStop:(NSInteger)idGroup
{
    for (NSValue *item in mObservers)
    {
        id<DownloaderManagerDelegate> observer = [item nonretainedObjectValue];
        [observer onStop:idGroup];
    }
}

- (void)executeQueue:(Task *)task
{
    if (![self taskExistsWithGroupId:task.idNewsGroup])
    {
        [self addTask:task];
        [self notifyOnStart:task.idNewsGroup];
    }
    
    if (self.isExecute)
    {
        return;
    }
    
    self.isExecute = YES;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        //Body of thread
        int count = [mTasks count];
        while (count > 0)
        {
            Task *task = [mTasks objectAtIndex:0];
            NSString *linkNews = [mLinksNews objectForKey:[NSNumber numberWithInteger:task.idNewsGroup]];
            
            BOOL success = NO;
            NSData *data = [mHttpClient execHttpRequest:linkNews];
            
            if (data)
            {
                NSXMLParser *nsXmlParser = [[NSXMLParser alloc] initWithData:data];
                self.parser = [[XMLParser alloc] initXMLParser];
                [nsXmlParser setDelegate:self.parser];
            
                success = [nsXmlParser parse];
            }
            
            NSArray *listNews = [NSArray array];
            if (success)
            {
               listNews = [self.parser getListNews];
                NSLog(@"News count: %d", [listNews count]);
            }
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (success)
                {
                    [mDbManager addNewsFromList:listNews forGroupId:task.idNewsGroup];
                }
                
                [self notifyOnStop:task.idNewsGroup];
                [mTasks removeObjectAtIndex:0];
            });
            
            count = [mTasks count];
        }
        
        //The end
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.isExecute = NO;
        });
    });
}

@end
