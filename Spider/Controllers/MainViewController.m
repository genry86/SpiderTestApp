//
//  MainViewController.m
//  Parser
//
//  Created by Genry on 8/15/15.
//  Copyright (c) 2015 Genry. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModePrimaryHidden;
}



#pragma mark - Navigation

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if (![self.ThreadCount.text integerValue] ||
        ![self.UrlQuantityTextFielad.text integerValue] ||
        ![self.SearchTextTextArea.text length] ||
        ![self.UrlTextField.text length]
        ) {

        [AlertHelper showAlertMessage:@"Error" message:@"Please set correct Data"];
        return NO;
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ShowProcess"])
    {
        DataManager *dataManager = [DataManager sharedManager];
        [dataManager reset];
        
        dataManager.maxThreadCount = [self.ThreadCount.text integerValue];
        dataManager.maxUrlCount = [self.UrlQuantityTextFielad.text integerValue];
        dataManager.searchText = self.SearchTextTextArea.text;
        dataManager.startUrl = self.UrlTextField.text;
    }
}

@end
