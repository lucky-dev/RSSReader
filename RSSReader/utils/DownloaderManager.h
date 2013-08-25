//
//  DownloaderManager.h
//  RSSReader
//
//  Created by Vladimir on 24.08.13.
//  Copyright (c) 2013 Vladimir. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DownloaderManagerDelegate <NSObject>

- (void)onStart;
- (void)onStop;

@end

@class Task;

@interface DownloaderManager : NSObject

+ (DownloaderManager*)sharedManager;

- (BOOL)taskExistsWithGroupId:(NSNumber *)taskId;
- (void)addObserver:(id<DownloaderManagerDelegate>)observer;
- (void)removeObserver:(id<DownloaderManagerDelegate>)observer;
- (void)addTask:(Task *)task;
- (void)executeQueue;

@end
