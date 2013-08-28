//
//  DownloaderManager.h
//  RSSReader
//
//  Created by Vladimir on 24.08.13.
//  Copyright (c) 2013 Vladimir. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DownloaderManagerDelegate <NSObject>

- (void)onStart:(NSInteger)idGroup;
- (void)onStop:(NSInteger)idGroup;

@end

@class Task;

@interface DownloaderManager : NSObject

+ (DownloaderManager*)sharedManager;

- (BOOL)taskExistsWithGroupId:(NSInteger)taskId;
- (void)addObserver:(id<DownloaderManagerDelegate>)observer;
- (void)removeObserver:(id<DownloaderManagerDelegate>)observer;
- (void)executeQueue:(Task *)task;

@end
