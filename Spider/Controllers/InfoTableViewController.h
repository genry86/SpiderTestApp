//
//  InfoTableViewController.h
//  Parser
//
//  Created by Genry on 8/15/15.
//  Copyright (c) 2015 Genry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoTableViewController : UIViewController<UITableViewDataSource, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *progressBar;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end
