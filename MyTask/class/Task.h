//
//  Task.h
//  MyTask
//
//  Created by Samir Husain on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Commons.h"

@interface Task : NSObject
{ 
    NSString *taskId;
   	NSString *taskDescription;
	NSString *priority;
    NSDate   *taskDateTime;
    NSString *taskStatus;
    NSString *taskTimeZone;
    NSString *email;
    NSString *note;
    NSString *syncId;
    NSString *syncStatus;
    NSString *taskType;
    NSString *repeatInterval; 
    NSString *alertTone;
    NSString *toBeCheked;
    NSString *deleteStatus;
    
}

@property (nonatomic, retain) NSString *taskId;
@property (nonatomic, retain) NSString *taskDescription;
@property (nonatomic, retain) NSString *priority;
@property (nonatomic, retain) NSDate *taskDateTime;
@property (nonatomic, retain) NSString *taskStatus; 
@property (nonatomic, retain) NSString *taskType;
@property (nonatomic, retain) NSString *repeatInterval;
@property (nonatomic, retain) NSString *alertTone;
@property (nonatomic, retain) NSString *toBeCheked;
@property (nonatomic, retain) NSString *taskTimeZone;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *note;
@property (nonatomic, retain) NSString *syncId;
@property (nonatomic, retain) NSString *syncStatus;
@property (nonatomic, retain) NSString *deleteStatus;

- (void)setNotification ;
- (void)removeNotification;


@end
