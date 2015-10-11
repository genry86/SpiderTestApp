//
//  DataManager.h
//  Parser
//
//  Created by Genry on 8/16/15.
//  Copyright (c) 2015 Genry. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PageUrl;

@interface DataManager : NSObject

+ (id)sharedManager;
@property(atomic, strong) NSMutableArray* urls;
@property(nonatomic, assign) NSInteger maxUrlCount;
@property(nonatomic, strong) NSString *searchText;
@property(nonatomic, strong) NSString *startUrl;

-(void)reset;
-(void)setMaxThreadCount:(NSInteger)maxThreadCount;
-(void)addNewUrl:(NSString*)url;

-(BOOL)isLimitOfUrlsReached;
-(BOOL)found;
-(PageUrl*)foundPageUrl;

-(void)startProcess;
-(void)handlePageUrl:(PageUrl*)pageUrl;

@end
