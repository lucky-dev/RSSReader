//
//  ListNewsViewController.m
//  RSSReader
//
//  Created by Vladimir on 23.08.13.
//  Copyright (c) 2013 Vladimir. All rights reserved.
//

#import "ListGroupsNewsViewController.h"
#import "ListNewsViewController.h"
#import "Constants.h"
#import "Task.h"
#import "DBManager.h"
#import "GroupNews.h"
#import "Tools.h"

@implementation ListGroupsNewsViewController
{
    NSArray *mListGroups;
    DownloaderManager *mDownloaderManager;
    DBManager *mDbManager;
    NSDate *defaultDate;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        NSLog(@"Init ListGroupsNewsViewController");
        
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
        
        defaultDate = [Tools getDefaultDate];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mListGroups = [mDbManager getAllNewsGroups];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [mDownloaderManager removeObserver:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mListGroups count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GroupNewsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    GroupNews *groupNews = mListGroups[indexPath.row];
    
    // Configure the cell...
    cell.textLabel.text = groupNews.name;
    
    if ([groupNews.date_last_updated isEqualToDate:defaultDate])
    {
        cell.detailTextLabel.text = @"Не обновлено";
    }
    else
    {
        cell.detailTextLabel.text = [Tools getFormat: DATE_FORMAT_SIMPLE
                                             forDate: groupNews.date_last_updated];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString: @"OpenListNews"])
    {
        ListNewsViewController *listNewsViewController = segue.destinationViewController;
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        GroupNews *typeNews = mListGroups[indexPath.row];
        
        listNewsViewController.title = typeNews.name;
        listNewsViewController.task = [[Task alloc] initWithIdGroup:[typeNews.groupId integerValue]];
    }
}

- (void)onStart:(NSInteger)idGroup
{
    NSLog(@"DownloaderManager: onStart");
}

- (void)onStop:(NSInteger)idGroup
{
    NSLog(@"DownloaderManager: onStop");
    
    mListGroups = [mDbManager getAllNewsGroups];
    [self.tableView reloadData];
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
    NSLog(@"Dealloc ListGroupsNewsViewController");
    
    [mDownloaderManager removeObserver:self];
}

@end
