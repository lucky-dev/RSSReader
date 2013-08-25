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

static DownloaderManager* sharedDownloaderManager;
static dispatch_once_t predicate;

@interface DownloaderManager ()

- (id) initWithTasks;

@property (nonatomic, assign) BOOL isExecute;

@end

@implementation DownloaderManager
{
    NSMutableArray *mTasks;
    NSDictionary *mLinksNews;
    HttpClient *mHttpClient;
    NSMutableArray *mObservers;
}

+ (DownloaderManager *)sharedManager
{
    dispatch_once(&predicate, ^{
        sharedDownloaderManager = [[DownloaderManager alloc] initWithTasks];
    });
    
    return sharedDownloaderManager;
}

- (id)initWithTasks
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
    }
    
    return self;
}

- (void)addTask:(Task *)task
{    
    if (![self taskExistsWithGroupId:task.idNewsGroup])
    {
        [mTasks addObject:task];
        NSLog(@"Task was added");
    }
}

- (BOOL)taskExistsWithGroupId:(NSNumber *)taskId
{    
    BOOL isExists = false;
    for (Task *item in mTasks)
    {
        if ([item.idNewsGroup isEqualToNumber:taskId])
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

- (void)notifyOnStart
{
    for (NSValue *item in mObservers)
    {
        id<DownloaderManagerDelegate> observer = [item nonretainedObjectValue];
        [observer onStart];
    }
}

- (void)notifyOnStop
{
    for (NSValue *item in mObservers)
    {
        id<DownloaderManagerDelegate> observer = [item nonretainedObjectValue];
        [observer onStop];
    }
}

- (void)executeQueue
{
    if (self.isExecute)
    {
        return;
    }
    
    self.isExecute = YES;
    
    [self notifyOnStart];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        //Body of thread
        int count = [mTasks count];
        while (count > 0)
        {
            Task *task = [mTasks objectAtIndex:0];
            NSString *linkNews = [mLinksNews objectForKey:task.idNewsGroup];
            
            NSData *data = [mHttpClient execHttpRequest:linkNews];
            
//            NSString *returnString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
//            NSLog(@"Data: %@", returnString);
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [mTasks removeObjectAtIndex:0];
            });
            
            count = [mTasks count];
        }
        
        //The end
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self notifyOnStop];
            self.isExecute = NO;
        });
    });
}

@end
