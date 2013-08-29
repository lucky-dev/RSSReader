//
//  DetailsNewsViewController.h
//  RSSReader
//
//  Created by Vladimir on 29.08.13.
//  Copyright (c) 2013 Vladimir. All rights reserved.
//

#import <UIKit/UIKit.h>

@class News;

@interface DetailsNewsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleNews;
@property (weak, nonatomic) IBOutlet UILabel *pubDate;
@property (weak, nonatomic) IBOutlet UIWebView *detailsNews;

@property (strong, nonatomic) News *news;

@end
