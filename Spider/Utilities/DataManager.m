//
//  DataManager.m
//  Parser
//
//  Created by Genry on 8/16/15.
//  Copyright (c) 2015 Genry. All rights reserved.
//

#import "DataManager.h"
#import "PageUrl.h"
#import "PageLoadOperation.h"

@interface DataManager()
@property (nonatomic, strong) NSOperationQueue *loadingQueue;
@property (nonatomic, strong) NSString *initialHostUrl;
@property (nonatomic, strong) NSArray *unWantedFiles;
@end

@implementation DataManager

+ (id)sharedManager {
    static DataManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        sharedMyManager.loadingQueue = [NSOperationQueue new];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [sharedMyManager setupObservers];
        [sharedMyManager reset];
    });
    return sharedMyManager;
}

#pragma mark - Public Methods

-(void)reset
{
    self.urls = [NSMutableArray new];
    self.maxUrlCount = -1;
    self.searchText = [NSString string];
    self.initialHostUrl = [NSString string];
}

-(void)setMaxThreadCount:(NSInteger)maxThreadCount
{
    self.loadingQueue.maxConcurrentOperationCount = maxThreadCount;
}

-(BOOL)isLimitOfUrlsReached
{
    return !([self.urls count] < self.maxUrlCount);
}

-(void)addNewUrl:(NSString*)url
{
    if ([self.urls count] < self.maxUrlCount)
    {
        NSURL *currentUrl = [NSURL URLWithString:url];
        if (![currentUrl.host isEqualToString:self.initialHostUrl]) return; // search local resources only
        
        if ([self urlAlreadyAdded:url]) return; // url already added to array of urls

        if ([self resourceIsProhibited:url]) return; // page is file or unwanted page(.js css ...)
        
        if ([self found]) return; //searched text found
        
        NSNumber *index = @([self.urls count]+1);
        
        PageUrl *pageUrl = [[PageUrl alloc] initWithUrl:url index:index];
        [self.urls addObject:pageUrl];
        
        dispatch_async(dispatch_get_main_queue(),
        ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationMessageUrlAdded
                                                                object:nil
                                                              userInfo:@{kNotificationMessageData:pageUrl}];
        });
    }
}

-(void)startProcess
{
    NSRange range = [self.startUrl rangeOfString:@"http://"];
    if (range.location == NSNotFound) self.startUrl = [@"http://" stringByAppendingString:self.startUrl];
    
    NSURL *initialUrl = [NSURL URLWithString:self.startUrl];
    self.initialHostUrl = initialUrl.host;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"FileExtensions" ofType:@"plist"];
    self.unWantedFiles = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    
    [self addNewUrl: self.startUrl];
}

-(void)searchChildUrl:(NSNotification*)notification
{
    PageUrl *pageUrl = notification.userInfo[kNotificationMessageData];    
    DataManager *dataManager = [DataManager sharedManager];
    int index = 0;
    while(index < [pageUrl.childrenUrls count] && ![dataManager isLimitOfUrlsReached])
    {
        NSString *url = pageUrl.childrenUrls[index];
        [dataManager addNewUrl:url];
        index++;
    }
    pageUrl.childrenUrls = nil;
}

-(PageUrl*)foundPageUrl
{
    return [[self itemsByStatus:DownloadStatusFound] lastObject];
}

-(NSInteger)numberOfItemsByStatus:(NSInteger)status
{
    return [[self itemsByStatus:status] count];
}

-(BOOL)found
{
    return ([self numberOfItemsByStatus:DownloadStatusFound] > 0);
}

#pragma mark - Privat Methods

-(BOOL)resourceIsProhibited:(NSString*)newUrl
{
    NSURL *url = [NSURL URLWithString:newUrl];
    NSString *path = [url path];
    NSString *extension = [path pathExtension];

    return ([extension length]) && ([[self.unWantedFiles filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF = %@", extension]] count] > 0);
}

-(BOOL)urlAlreadyAdded:(NSString*)newUrl
{
    return ([[self.urls filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"url = %@", newUrl]] count] > 0);
}

-(NSArray*)itemsByStatus:(NSInteger)status
{
    return [self.urls filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"status = %d", status]];
}

-(void)handlePageUrl:(PageUrl*)pageUrl
{
    PageLoadOperation *pageLoadOperation = [[PageLoadOperation alloc] initWithURL:pageUrl];
    [self.loadingQueue addOperation:pageLoadOperation];
}

-(void)setupObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tableItemAdded:)
                                                 name:kNotificationTableItemAdded
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(searchChildUrl:)
                                                 name:kNotificationSearchChildUrl
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cancelAllOperation:)
                                                 name:kNotificationCancelAllOperation
                                               object:nil];
}

#pragma mark - Observers

-(void)cancelAllOperation:(NSNotification*)notification
{
    for (NSOperation *loadOperation in self.loadingQueue.operations) {
        [loadOperation cancel];
    }
}

-(void)tableItemAdded:(NSNotification*)notification
{
    PageUrl *pageUrl = notification.userInfo[kNotificationMessageData];
    [self handlePageUrl:pageUrl];
}

@end
