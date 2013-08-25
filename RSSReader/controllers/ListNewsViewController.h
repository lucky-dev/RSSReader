//
//  ListNewsViewController.h
//  RSSReader
//
//  Created by Vladimir on 24.08.13.
//  Copyright (c) 2013 Vladimir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloaderManager.h"

@interface ListNewsViewController : UITableViewController<DownloaderManagerDelegate>

@property (nonatomic, assign) NSInteger groupNews;

@end
