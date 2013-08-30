//
//  DetailsNewsViewController.m
//  RSSReader
//
//  Created by Vladimir on 29.08.13.
//  Copyright (c) 2013 Vladimir. All rights reserved.
//

#import "DetailsNewsViewController.h"
#import "News.h"
#import "DetailsNews.h"
#import "Tools.h"
#import "Constants.h"

@interface DetailsNewsViewController ()

@end

@implementation DetailsNewsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.titleNews.text = self.news.title;
    self.pubDate.text = [Tools getFormat: DATE_FORMAT_SIMPLE
                                 forDate: self.news.pubDate];
    [self.detailsNews loadHTMLString:self.news.detailsNews.fullText baseURL:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
