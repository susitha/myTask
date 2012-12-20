//
//  AppDelegate.h
//  MyTask
//
//  Created by Samir Husain on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Commons.h"
#import "Task.h"
#import "DBConnect.h"

@class MakeTaskViewController;
@class PendingTasksViewController;

@interface TaskAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>
{
    
    NSString *databasePath;
    UIImageView *splashView; 
    MakeTaskViewController *viewController3; 
    PendingTasksViewController *viewController2;    
    BOOL isLocalNotificationTriggerd;
    UIAlertView *theAlert;
    Task *task;
    BOOL showTask;
    UINavigationController *allTaskNavController;
    UILocalNotification *localNotif;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController; 

@end
