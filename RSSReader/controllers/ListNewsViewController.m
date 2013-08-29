//
//  ListNewsViewController.m
//  RSSReader
//
//  Created by Vladimir on 24.08.13.
//  Copyright (c) 2013 Vladimir. All rights reserved.
//

#import "ListNewsViewController.h"
#import "Task.h"
#import "Constants.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface ListNewsViewController ()

@end

@implementation ListNewsViewController
{
    DownloaderManager *mDownloaderManager;
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
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
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
