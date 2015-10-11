//
//  GlobalTypes.m
//  Parser
//
//  Created by Genry on 8/16/15.
//  Copyright (c) 2015 Genry. All rights reserved.
//



typedef NS_ENUM(NSInteger, DownloadStatus)
{
    DownloadStatusPending = 0,
    DownloadStatusDawnloading,
    DownloadStatusNotFound,
    DownloadStatusError,
    DownloadStatusFound
};

// Notification key for user data
static NSString *const kNotificationMessageData = @"kNotificationMessageData";

// New Url added to main urls array (to add new cell to table view)
static NSString *const kNotificationMessageUrlAdded = @"kNotificationMessageUrlAdded";
// ststus of some url changed (to update table view cell)
static NSString *const kNotificationMessageUrlStatusChanged = @"kNotificationMessageUrlStatusChanged";

// appropriate to url, new cell added
static NSString *const kNotificationTableItemAdded = @"kNotificationTableItemAdded";

// searched text not found and we start searching child urls on page
static NSString *const kNotificationSearchChildUrl = @"kNotificationSearchChildUrl";

//Cancel all operations
static NSString *const kNotificationCancelAllOperation = @"kNotificationCancelAllOperation";

//Saerch text Found
static NSString *const kNotificationSearchTextFound= @"kNotificationSearchTextFound";

static NSString *const kFieldStatusFound = @"Found";
static NSString *const kFieldStatusPending = @"Pending";
static NSString *const kFieldStatusDawnloading = @"Dawnloading";
static NSString *const kFieldStatusNotFound = @"Not Found";