//
//  InfoTableViewController.m
//  Parser
//
//  Created by Genry on 8/15/15.
//  Copyright (c) 2015 Genry. All rights reserved.
//

#import "InfoTableViewController.h"
#import "DataManager.h"
#import "PageUrl.h"
#import "InfoTableViewCell.h"

static NSString *InfoCellIdentifier = @"InfoTableViewCell";

@interface InfoTableViewController ()
@property (atomic, strong) NSMutableArray *localItems;
@end

@implementation InfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:InfoCellIdentifier bundle:nil] forCellReuseIdentifier:InfoCellIdentifier];
    self.tableView.allowsSelection = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self progressBar] startAnimating];
    self.localItems = [NSMutableArray new];
    
    [self setupObservers];
    [[DataManager sharedManager] startProcess];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private

-(void)setupObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pageUrlAdded:)
                                                 name:kNotificationMessageUrlAdded
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pageUrlStatusChanged:)
                                                 name:kNotificationMessageUrlStatusChanged
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(searchTextFound:)
                                                 name:kNotificationSearchTextFound
                                               object:nil];
}

-(void)checkIfSearchFinishedWithNoSuccess
{
    DataManager *dataManager = [DataManager sharedManager];
    //getting all urls which are not handled
    NSArray *unHandledUrls = [[dataManager urls] filteredArrayUsingPredicate:
                              [NSPredicate predicateWithFormat:@"status = %d  ||  status = %d", DownloadStatusDawnloading, DownloadStatusPending]];
    
    BOOL notFound = ([unHandledUrls count] == 0) && [dataManager isLimitOfUrlsReached] && ![dataManager found];
    
    if (notFound)
    {
        [AlertHelper showAlertMessage:@"Alert" message:@"Fail to find serched text"];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCancelAllOperation object:nil];
        [self.progressBar stopAnimating];
    }
}

#pragma mark - Observers

-(void)searchTextFound:(NSNotification*)notification
{
    PageUrl *pageUrl = notification.userInfo[kNotificationMessageData];
    [self.tableView setContentOffset:CGPointMake(0, ([pageUrl.index integerValue]-1) *44) animated:YES];
    
    [AlertHelper showAlertMessage:@"Succes. Text Found" message:pageUrl.url];
    [self.progressBar stopAnimating];
}

-(void)pageUrlAdded:(NSNotification*)notification
{
    PageUrl *pageUrl = notification.userInfo[kNotificationMessageData];
    
    [self.localItems addObject:pageUrl];
    [self insertNewCell];

    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationTableItemAdded object:nil userInfo:@{kNotificationMessageData:pageUrl}];
}

-(void)pageUrlStatusChanged:(NSNotification*)notification
{
    PageUrl *pageUrl = notification.userInfo[kNotificationMessageData];

    NSIndexPath *indexPath = [self indexPathByPageUrlItem:pageUrl];
    [self updateCell:indexPath];

    if (pageUrl.status == DownloadStatusNotFound)
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSearchChildUrl
                                                            object:nil
                                                          userInfo:@{kNotificationMessageData:pageUrl}];
    
    [self checkIfSearchFinishedWithNoSuccess];
}

#pragma mark - Table help methods

-(NSIndexPath *)indexPathByPageUrlItem:(PageUrl *)pageUrl
{
    InfoTableViewCell *cell = (InfoTableViewCell *)[[self tableView] viewWithTag:[pageUrl.index integerValue]];
    return [self.tableView indexPathForRowAtPoint:cell.center];
}

-(NSIndexPath *)indexPathByPageUrlItemInVisibleCells:(PageUrl *)pageUrl
{
    InfoTableViewCell *cell = (InfoTableViewCell *)[[self tableView] viewWithTag:[pageUrl.index integerValue]];
    return [self.tableView indexPathForCell:cell];
}

-(void)updateCell:(NSIndexPath *)indexPath
{
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

-(void)insertNewCell
{
    NSArray *indexPathes = @[[NSIndexPath indexPathForRow:([self.localItems count]-1) inSection:0]];
    [self.tableView beginUpdates];
    [[self tableView] insertRowsAtIndexPaths:indexPathes withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.localItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:InfoCellIdentifier forIndexPath:indexPath];
    NSInteger row = [indexPath row];
    PageUrl *pageUrl = self.localItems[row];
    
    cell.tag = [pageUrl.index integerValue];
    cell.pageUrl = pageUrl;
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"Stop"])
         [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCancelAllOperation object:nil];
}

@end
