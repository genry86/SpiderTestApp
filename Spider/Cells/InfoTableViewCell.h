//
//  InfoTableViewCell.h
//  Spider
//
//  Created by Genry on 8/17/15.
//  Copyright (c) 2015 Genry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *indexLabel;
@property (strong, nonatomic) IBOutlet UILabel *urlLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;

@property (strong, nonatomic) PageUrl* pageUrl;
@end
