//
//  Task.m
//  MyTask
//
//  Created by Samir Husain on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Task.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJSON.h"

@implementation Task
@synthesize taskId,taskDescription,priority,taskDateTime,taskType,taskStatus,repeatInterval,alertTone,toBeCheked,taskTimeZone,email,note,syncId,syncStatus,deleteStatus;
- (id)init{
    self = [super init];
    if (self) {
        taskId = @"";
        taskDescription= @"";
        priority= taskPr_low;
        taskDateTime = [[NSDate date]retain];
        taskType= taskTy_reminder;
        taskStatus= @"0";
        repeatInterval= taskRptIntv_none;
        alertTone= taskAlertToneText_Default;
        toBeCheked= @"0";
        taskTimeZone = @"";
        email = @"";
        note = @"";
        syncStatus = @"New";
        syncId = @"";
        deleteStatus = @"0";
    }
    return self;
}

- (void)dealloc{
    
    [taskDateTime release];
    taskId = nil;
    taskDescription= nil;
    priority= nil;
    taskType= nil;
    taskStatus= nil;
    repeatInterval= nil;
    alertTone= nil;
    toBeCheked= nil;
    taskTimeZone = nil;
    email = nil;
    note = nil;
    syncStatus = nil;
    syncId = nil;
    deleteStatus = nil;
    
    [super dealloc];
}



- (void)setNotification {
   
    
    
    Class cls = NSClassFromString(@"UILocalNotification");
	if (cls != nil) {
          
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MMM dd, yyyy HH:mm"];
        NSString *dateString = [dateFormat stringFromDate:self.taskDateTime];
           
		UILocalNotification *notif = [[cls alloc] init];
        		                                         
		notif.fireDate = [dateFormat dateFromString:dateString]; 
        notif.timeZone = [NSTimeZone defaultTimeZone];
		notif.alertBody = self.taskDescription;
		notif.alertAction = @"Show me";
		notif.soundName = UILocalNotificationDefaultSoundName;
		notif.applicationIconBadgeNumber =  1 ;
        [notif setApplicationIconBadgeNumber:[[UIApplication sharedApplication] applicationIconBadgeNumber]+1];
		notif.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",self.taskId], @"taskID", nil] ;
     
        
        if([self.repeatInterval isEqualToString:taskRptIntv_hourly]){
            notif.repeatInterval = NSHourCalendarUnit;
        }
        else if([self.repeatInterval isEqualToString: taskRptIntv_daily]){
            notif.repeatInterval = NSDayCalendarUnit;
        }
        else if([self.repeatInterval isEqualToString: taskRptIntv_weekly]){
            notif.repeatInterval = NSWeekCalendarUnit;
        }
        else if ([self.repeatInterval isEqualToString: taskRptIntv_monthly]) {
            notif.repeatInterval = NSMonthCalendarUnit;
        }
        else if ([self.repeatInterval isEqualToString: taskRptIntv_yearly]) {
            notif.repeatInterval = NSYearCalendarUnit;
        }        
        
        
        if([self.alertTone isEqualToString:taskAlertToneText_Epsilon]){
            notif.soundName = taskAlertTone_Epsilon;
        }
        else if ([self.alertTone isEqualToString:taskAlertToneText_Chimes]) {
            notif.soundName = taskAlertTone_Chimes;
        }
        else if ([self.alertTone isEqualToString:taskAlertToneText_Blipper]) {
            notif.soundName = taskAlertTone_Blipper;
        }
        else if ([self.alertTone isEqualToString:taskAlertToneText_Berring]) {
            notif.soundName = taskAlertTone_Berring;
        }
        
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notif];
                
        [dateFormat release];
		[notif release];
      
        
        
	}
  
}




-(void)removeNotification{
      
    NSArray *arrayOfLocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications] ;
      for (UILocalNotification *localNotification in arrayOfLocalNotifications) {
        if ([[localNotification.userInfo valueForKey:@"taskID"] isEqualToString:self.taskId]) {
             [[UIApplication sharedApplication] cancelLocalNotification:localNotification] ;    
        }
    }
    

}

@end
