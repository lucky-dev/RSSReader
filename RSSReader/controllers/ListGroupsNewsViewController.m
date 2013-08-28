//
//  ListNewsViewController.m
//  RSSReader
//
//  Created by Vladimir on 23.08.13.
//  Copyright (c) 2013 Vladimir. All rights reserved.
//

#import "ListGroupsNewsViewController.h"
#import "ListNewsViewController.h"
#import "TypeNews.h"
#import "Constants.h"
#import "Task.h"

@implementation ListGroupsNewsViewController
{
    NSArray *mListNews;
    DownloaderManager *mDownloaderManager;
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
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mListNews = [[NSArray alloc] initWithObjects:
                 [[TypeNews alloc] initWithTitle: @"Последние новости"
                              andTypeOfNewsGroup: TYPE_NEWS_LAST],
                 [[TypeNews alloc] initWithTitle: @"Украина"
                              andTypeOfNewsGroup: TYPE_NEWS_UKRAINE],
                 [[TypeNews alloc] initWithTitle: @"Бизнес"
                              andTypeOfNewsGroup: TYPE_NEWS_BUSINESS],
                 [[TypeNews alloc] initWithTitle: @"Мир о нас"
                              andTypeOfNewsGroup: TYPE_NEWS_WORLD_ABOUT_US],
                 [[TypeNews alloc] initWithTitle: @"Шоу-биз и культура"
                              andTypeOfNewsGroup: TYPE_NEWS_SHOWBIZ],
                 [[TypeNews alloc] initWithTitle: @"Мир"
                              andTypeOfNewsGroup: TYPE_NEWS_WORLD],
                 [[TypeNews alloc] initWithTitle: @"Наука и медецина"
                              andTypeOfNewsGroup: TYPE_NEWS_TECH],
                 [[TypeNews alloc] initWithTitle: @"Спорт"
                              andTypeOfNewsGroup: TYPE_NEWS_SPORT],
                 nil];
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
    return [mListNews count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GroupNewsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    TypeNews *typeNews = mListNews[indexPath.row];
    
    // Configure the cell...
    cell.textLabel.text = typeNews.title;
    cell.detailTextLabel.text = @"Не обновлено";
    
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
    if([segue.identifier isEqualToString: @"OpenListNews"])
    {
        ListNewsViewController *listNewsViewController = segue.destinationViewController;
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        TypeNews *typeNews = mListNews[indexPath.row];
        
        listNewsViewController.title = typeNews.title;
        listNewsViewController.task = [[Task alloc] initWithIdGroup:typeNews.typeNewsGroup];
    }
}

- (void)onStart:(NSInteger)idGroup
{
    NSLog(@"DownloaderManager: onStart");
}

- (void)onStop:(NSInteger)idGroup
{
    NSLog(@"DownloaderManager: onStop");
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
