//
//  PageUrl.m
//  Parser
//
//  Created by Genry on 8/16/15.
//  Copyright (c) 2015 Genry. All rights reserved.
//

#import "PageUrl.h"

@implementation PageUrl

-(id)initWithUrl:(NSString*)url index:(NSNumber*)index
{
    self = [self init];
    if (self) {
        self.url = url;
        self.status = DownloadStatusPending;
        self.index = index;
    }
    return self;
}

-(void)setStatus:(DownloadStatus)status
{
    _status = status;

    dispatch_async(dispatch_get_main_queue(),
   ^{
       if (_status == DownloadStatusFound) {
           [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCancelAllOperation object:nil];
           [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSearchTextFound object:nil userInfo:@{kNotificationMessageData:self}];
       }
       if (status != DownloadStatusPending)
           [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationMessageUrlStatusChanged
                                                               object:self
                                                             userInfo:@{kNotificationMessageData:self}];
    });
}

@end
