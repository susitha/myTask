//
//  DBConnect.h
//  MyTask
//
//  Created by Samir Husain on 7/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Task.h"
#import "StoredEmail.h"
#import "TaskEmail.h"

@interface DBConnect : NSObject

+(void)createDatabaseIfNeeded;
+(NSString *) getPrimaryKey;



+ (NSString *)insertNewTask:(Task *)task;
+ (NSString *)updateTask:(Task *)task;
+ (void) deleteTask:(Task *)task; 
+ (NSMutableArray *) getAllTasks;
+ (NSMutableArray *) getAllpendingTasks;
+ (NSMutableArray *) getAllToBeCheckedTasks;
+ (NSMutableArray *) getAllUnsyncedTasks;
+ (NSString *)updateTaskSyncStatus:(Task *)task;
+ (Task *) getTask:(int)taskID;


+ (NSString *)insertNewEmail:(StoredEmail *)email;
+ (NSMutableArray *) getAllEmails;
+ (void)deleteEmail:(StoredEmail *)email;
+ (BOOL) isEmailExists:(NSString *)email;


+ (NSString *)insertNewTaskEmail:(TaskEmail *)taskEmail;
+ (NSMutableArray *) getAllTaskEmails:(Task *)task;
+ (void)deleteTaskEmails:(Task *)task;


+(void)UpdateFireDateNext:(BOOL)next;

@end
