//
//  InfoTableViewCell.m
//  Spider
//
//  Created by Genry on 8/17/15.
//  Copyright (c) 2015 Genry. All rights reserved.
//

#import "InfoTableViewCell.h"
#import "PageUrl.h"
@implementation InfoTableViewCell


-(void)setPageUrl:(PageUrl *)pageUrl
{
    self.indexLabel.text = [pageUrl.index stringValue];
    self.urlLabel.text = pageUrl.url;
    
    self.statusLabel.textColor = [UIColor blackColor];
    
    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.statusLabel.font = [UIFont systemFontOfSize:11];
    self.urlLabel.font = [UIFont systemFontOfSize:11];
    
    switch (pageUrl.status) {
        case DownloadStatusPending:
            self.statusLabel.text = kFieldStatusPending;
            break;
        case DownloadStatusDawnloading:
            self.statusLabel.text = kFieldStatusDawnloading;
            self.statusLabel.textColor = [UIColor blueColor];
            break;
        case DownloadStatusNotFound:
            self.statusLabel.text = kFieldStatusNotFound;
            break;
        case DownloadStatusError:
            self.statusLabel.text = pageUrl.errorInfo;
            self.statusLabel.textColor = [UIColor redColor];
            break;
        case DownloadStatusFound:
            self.statusLabel.text = kFieldStatusFound;
            self.statusLabel.textColor = [UIColor greenColor];
            self.contentView.backgroundColor = [UIColor lightGrayColor];
            self.statusLabel.font = [UIFont boldSystemFontOfSize:16];
             self.urlLabel.font = [UIFont boldSystemFontOfSize:15];
            break;
    }
    
    [self.backgroundView setNeedsDisplay];

}

- (void)awakeFromNib {
    self.contentView.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
