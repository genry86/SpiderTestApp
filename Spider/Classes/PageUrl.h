//
//  PageUrl.h
//  Parser
//
//  Created by Genry on 8/16/15.
//  Copyright (c) 2015 Genry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PageUrl : NSObject
@property (nonatomic, strong)   NSNumber *index;
@property (nonatomic, strong)   NSString *url;
@property (nonatomic, assign)   DownloadStatus status;
@property (atomic, strong)      NSString *errorInfo;
@property (nonatomic, strong)   NSArray *childrenUrls;

-(id)initWithUrl:(NSString*)url index:(NSNumber*)index;
@end
