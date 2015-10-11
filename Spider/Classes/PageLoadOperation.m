//
//  PageLoadOperation.m
//  Parser
//
//  Created by Genry on 8/16/15.
//  Copyright (c) 2015 Genry. All rights reserved.
//

#import "PageLoadOperation.h"
#import "PageUrl.h"

@interface PageLoadOperation()
@property (nonatomic, strong) PageUrl* pageUrl;
@end

@implementation PageLoadOperation

- (id)initWithURL:(PageUrl*)pageUrl
{
    self = [super init];
    if (self) {
        [self setPageUrl:pageUrl];
    }
    return self;
}

-(NSArray *)detectUrls:(NSString*)pageContent
{
    NSError *error;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink
                                                               error:&error];
    NSArray *matches = [detector matchesInString:pageContent
                                         options:0
                                           range:NSMakeRange(0, [pageContent length])];
    
    return [matches valueForKeyPath:@"URL.description"];
}

-(BOOL)searchTextFound:(NSString*)pageContent
{
    NSString *searchText = [[DataManager sharedManager] searchText];
    return ([pageContent rangeOfString:searchText].location != NSNotFound);
}

- (void)main {
    if([[DataManager sharedManager] isLimitOfUrlsReached]) [self cancel];
    
    PageUrl *pageUrl = self.pageUrl;
    NSError *error;
    pageUrl.status = DownloadStatusDawnloading;

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:pageUrl.url]];
    [request setHTTPMethod:@"GET"];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
    NSString *webpageString = [[NSString alloc] initWithBytes:[returnData bytes] length:[returnData length] encoding:NSUTF8StringEncoding];
    
    if (error) {
        pageUrl.errorInfo = error.localizedDescription;
        pageUrl.status = DownloadStatusError;
    }
    else if(!webpageString || ![webpageString length])
    {
        pageUrl.errorInfo = @"Bad content";
        pageUrl.status = DownloadStatusError;
    }
    else if ([self searchTextFound:webpageString])
    {
        self.pageUrl.status = DownloadStatusFound;
    }
    else
    {
        pageUrl.childrenUrls = [self detectUrls:webpageString];
        self.pageUrl.status = DownloadStatusNotFound;
    }
}
@end
