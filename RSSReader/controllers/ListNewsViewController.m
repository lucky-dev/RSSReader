//
//  ListNewsViewController.m
//  RSSReader
//
//  Created by Vladimir on 24.08.13.
//  Copyright (c) 2013 Vladimir. All rights reserved.
//

#import "ListNewsViewController.h"
#import "DetailsNewsViewController.h"
#import "Task.h"
#import "News.h"
#import "Constants.h"
#import "DBManager.h"
#import "NewsCell.h"
#import "Tools.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface ListNewsViewController ()

@end

@implementation ListNewsViewController
{
    DownloaderManager *mDownloaderManager;
    NSArray *mListNews;
    DBManager *mDbManager;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        NSLog(@"Init ListNewsViewController");
        
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        
        [center addObserver: self
                   selector: @selector(applicationDidEnterBackground)
                       name: UIApplicationDidEnterBackgroundNotification
                     object: nil];
        
        [center addObserver: self
                   selector: @selector(applicationWillEnterForeground)
                       name: UIApplicationWillEnterForegroundNotification
                     object: nil];
        
        mDownloaderManager = [DownloaderManager sharedManager];
        [mDownloaderManager addObserver:self];
        
        mDbManager = [DBManager sharedManager];
	}
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([mDownloaderManager taskExistsWithGroupId:self.task.idNewsGroup])
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    else
    {
        mListNews = [mDbManager getAllNewsByGroupId:self.task.idNewsGroup];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [mDownloaderManager removeObserver:self];
}
- (IBAction)refreshNews:(id)sender
{    
    [mDownloaderManager executeQueue:self.task];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [mListNews count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewsCell";
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    News *news = [mListNews objectAtIndex:indexPath.row];
    
    // Configure the cell...
    cell.titleNews.text = news.title;
    cell.dateNews.text = [Tools getFormat: DATE_FORMAT_SIMPLE
                                  forDate: news.pubDate];
    
    [cell.imageNews setImageWithURL: [NSURL URLWithString:news.linkImage]
                   placeholderImage: [UIImage imageNamed:@"placeholder.gif"]];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString: @"OpenDetailsNews"])
    {
        DetailsNewsViewController *detailsNewsViewController = segue.destinationViewController;
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        detailsNewsViewController.news = mListNews[indexPath.row];
    }
}

- (void)onStart:(NSInteger)idGroup
{
    NSLog(@"DownloaderManager: onStart");
    
    if (self.task.idNewsGroup == idGroup)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
}

- (void)onStop:(NSInteger)idGroup
{
    NSLog(@"DownloaderManager: onStop");
    
    if (self.task.idNewsGroup == idGroup)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        mListNews = [mDbManager getAllNewsByGroupId:self.task.idNewsGroup];
        
        [self.tableView reloadData];
    }
}

- (void)applicationDidEnterBackground
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    [mDownloaderManager removeObserver:self];
}

- (void)applicationWillEnterForeground
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    [mDownloaderManager addObserver:self];
}

- (void)dealloc
{
    NSLog(@"Dealloc ListNewsViewController");
    
    [mDownloaderManager removeObserver:self];
}

@end
