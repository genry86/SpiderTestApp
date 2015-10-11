//
//  HelperManager.m
//  Parser
//
//  Created by Genry on 8/16/15.
//  Copyright (c) 2015 Genry. All rights reserved.
//

#import "AlertHelper.h"

@implementation AlertHelper

 + (void)showAlertMessage:(NSString*)title message:(NSString*)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Ok"
                               style:UIAlertActionStyleDefault
                               handler:nil];
    
    [alertController addAction:okAction ];
    
    UIViewController *topCntroller = [AlertHelper topMostController];
    if(![topCntroller presentedViewController])
        [topCntroller presentViewController:alertController animated:YES completion:nil];
}

+ (UIViewController*) topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}

@end
