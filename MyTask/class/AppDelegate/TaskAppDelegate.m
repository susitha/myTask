//
//  AppDelegate.m
//  MyTask
//
//  Created by Susitha Janaka on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "TaskAppDelegate.h"
#import "AllTasksViewController.h"
#import "PendingTasksViewController.h"
#import "Commons.h"
#import "MakeTaskViewController.h"
#import "Sync.h"

@implementation TaskAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

NSString *kRemindMeNotificationDataKey = @"kRemindMeNotificationDataKey";


- (void)dealloc

{    
    [_window release];
    [_tabBarController release];
    [super dealloc];
}

- (void)applicationDidBecomeActive:(UIApplication *)application{

    
    Sync *sync= [[Sync alloc]init];
    [sync syncStart];

    
    NSString *taskID ;
    if (localNotif) {
        taskID = [localNotif.userInfo objectForKey:@"taskID"];
        [DBConnect UpdateFireDateNext:NO];
        task = [DBConnect getTask: [taskID intValue]];
        [viewController3 setTask:task];
       
        if (task != nil) {
            [self showTaskDetails];
        }
    }
    
    [sync release];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   
    
    [DBConnect createDatabaseIfNeeded];
       
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    AllTasksViewController *viewController1 = [[[AllTasksViewController alloc] initWithNibName:@"AllTasksViewController" bundle:nil] autorelease];
    viewController2 = [[[PendingTasksViewController alloc] initWithNibName:@"PendingTasksViewController" bundle:nil] autorelease];
    viewController3 = [[[MakeTaskViewController alloc] initWithNibName:@"MakeTaskViewController" bundle:nil] autorelease];
    
    allTaskNavController = [[UINavigationController alloc] initWithRootViewController:viewController1];
    UINavigationController *pendingTaskNavController = [[UINavigationController alloc] initWithRootViewController:viewController2 ];
    UINavigationController *makeTaskNavController = [[UINavigationController alloc] initWithRootViewController:viewController3 ];
    
    
    [[allTaskNavController navigationBar] setTintColor:[UIColor blackColor]];
    [[makeTaskNavController navigationBar] setTintColor:[UIColor blackColor]];
    [[pendingTaskNavController navigationBar] setTintColor:[UIColor blackColor]];
    
    
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:allTaskNavController,pendingTaskNavController,makeTaskNavController, nil];
    self.window.rootViewController = self.tabBarController; 
    
    [self.window makeKeyAndVisible];
    
    [pendingTaskNavController release];
    [makeTaskNavController release];
    [allTaskNavController release]; 
    
    
    localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0]; 
   
    return YES;
    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    UIApplicationState state = [application applicationState]; 
    
   [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];   
        
    NSString *taskID =  [notification.userInfo valueForKey:@"taskID"];
    Task *taskA = [DBConnect getTask: [taskID intValue]];  
    task = [taskA retain]; 
    if ([taskA.taskStatus isEqualToString:@"0"]) { 
        [DBConnect UpdateFireDateNext:NO]; 
      
        if (state == UIApplicationStateActive) { 
            theAlert = [[UIAlertView alloc] initWithTitle:@"MyTask" 
                                                  message:[NSString stringWithFormat:@"You have a pending task:%@",task.taskDescription]
                                                 delegate:self 
                                        cancelButtonTitle:@"Show me"
                                        otherButtonTitles:@"Cancel", nil];
            [theAlert show];
            [theAlert release]; 
        }else if(state == UIApplicationStateInactive){  
            task = [DBConnect getTask: [taskID intValue]];  
            if (task != nil) {
                [self showTaskDetails];
                
            } 
        } 
    } 
}

- (void)showTaskDetails{  
         
        MakeTaskViewController *mktView = [[MakeTaskViewController alloc]init];
        [mktView setTask:task];
        
        UINavigationController *mktNav = [[UINavigationController alloc] initWithRootViewController:mktView ];
        [[mktNav navigationBar] setTintColor:[UIColor blackColor]];
        
        mktView.isNotificationTriggered =YES;
    
        [self.tabBarController.selectedViewController presentModalViewController:mktNav animated:YES];
        [mktNav release];
        [mktView release];
    }


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0){
        [self showTaskDetails];
    }else {
        
    }
    
}





@end
