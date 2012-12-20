//
//  DBConnect.m
//  MyTask
//
//  Created by Susitha Janaka on 7/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DBConnect.h"
#import "Commons.h"
#import "StoredEmail.h"

@implementation DBConnect




+(NSString *) getPrimaryKey{ 
    NSDate *curDate = [[NSDate alloc]init];   
    NSTimeInterval inter = [curDate timeIntervalSince1970]; //return as double
    [curDate release]; 
    NSString *str = [NSString stringWithFormat:@"%f",inter]; 
    NSString *mutstr = [str stringByReplacingOccurrencesOfString:@"." withString:@"C"]; 
    return mutstr; 
}


+(void)createDatabaseIfNeeded {
	BOOL success;
	NSError *error; 
	NSFileManager *FileManager = [NSFileManager defaultManager] ; 
	NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:dbName]; 
	success = [FileManager fileExistsAtPath:databasePath]; 
	if(success) return; 
	NSString *dbPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbName]; 
  	success = [FileManager copyItemAtPath:dbPath toPath:databasePath error:&error]; 
    	
    if(!success)
		NSAssert1(0, @"Failed to copy the database. Error: %@.", [error localizedDescription]); 
    
}

#pragma mark - TASK
+ (NSString *)insertNewTask:(Task *)task{
    NSString *lastInsertedTaskId = @"";
     
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:dbName];
   
    sqlite3 *database;
    
    if(sqlite3_open([filePath UTF8String], &database) == SQLITE_OK) {
        
        const char *sqlStatement = "insert into tasks (task_description, task_priority, task_type, task_dateTime,repeat_interval, time_zone, email, note, alert_tone, task_status,task_toBeCheked, sync_status, task_delete_status) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)";
		
       
        sqlite3_stmt *compiledStatement;
                        
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)    {
           
			sqlite3_bind_text( compiledStatement, 1, [task.taskDescription UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 2, [task.priority UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 3, [task.taskType UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int ( compiledStatement, 4, [task.taskDateTime  timeIntervalSince1970]);
            sqlite3_bind_text( compiledStatement, 5, [task.repeatInterval UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 6, [task.taskTimeZone UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 7, [task.email UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 8, [task.note UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 9, [task.alertTone UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 10,[task.taskStatus UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 11,[task.toBeCheked UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 12,[task.syncStatus UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 13,[task.deleteStatus UTF8String], -1, SQLITE_TRANSIENT);
        }
        
       
		if(sqlite3_step(compiledStatement) != SQLITE_DONE ) {
			NSLog( @"add new Task Error: %s", sqlite3_errmsg(database) );
		}else{
            lastInsertedTaskId = [NSString stringWithFormat:@"%lld",sqlite3_last_insert_rowid(database)];
        }
                        
		sqlite3_finalize(compiledStatement); 
	}
	
    sqlite3_close(database); 
    
    
       
    return lastInsertedTaskId;

}


+ (NSString *)updateTask:(Task *)task {
     
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:dbName];
    
    sqlite3 *database; 
	if(sqlite3_open([filePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement = "UPDATE tasks SET task_description = ?, task_priority = ?, task_type = ?, task_dateTime = ?, repeat_interval = ?, alert_tone = ?, task_status = ?, task_toBeCheked = ?, email = ?,note = ?, sync_status= ?, task_delete_status=?, sync_id = ? WHERE task_id = ? ";
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)    {
            
            sqlite3_bind_text( compiledStatement, 1, [task.taskDescription UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 2, [task.priority UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 3, [task.taskType UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int ( compiledStatement, 4, [task.taskDateTime  timeIntervalSince1970]);
            sqlite3_bind_text( compiledStatement, 5, [task.repeatInterval UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 6, [task.alertTone UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 7, [task.taskStatus UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 8, [task.toBeCheked UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 9, [task.email UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 10, [task.note UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 11, [task.syncStatus UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 12, [task.deleteStatus UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 13, [task.syncId  UTF8String],-1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 14, [task.taskId UTF8String], -1, SQLITE_TRANSIENT);

           
                       
		}
		if(sqlite3_step(compiledStatement) != SQLITE_DONE ) {
			NSLog( @"update Task Error: %s", sqlite3_errmsg(database) );
		}
        
		sqlite3_finalize(compiledStatement);
	}
    
	sqlite3_close(database); 
    return task.taskId ;
}

+ (NSString *)updateTaskSyncStatus:(Task *)task {
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:dbName];
    
    sqlite3 *database;
	if(sqlite3_open([filePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement = "UPDATE tasks SET sync_status =  ? , sync_id = ?   WHERE task_id = ? ";
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)    {
            
            sqlite3_bind_text( compiledStatement, 1, [task.syncStatus UTF8String] ,-1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 2, [task.syncId  UTF8String],-1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 3, [task.taskId UTF8String] ,-1, SQLITE_TRANSIENT);
            
            
		}
		if(sqlite3_step(compiledStatement) != SQLITE_DONE ) {
			NSLog( @"update Task sync status Error: %s", sqlite3_errmsg(database) );
		}
        
		sqlite3_finalize(compiledStatement);
	}
    
	sqlite3_close(database);
    return task.taskId ;

    
    
}

+ (void)deleteTask:(Task *)task { 
    sqlite3 *database;
    
     NSString *filePath = [documentsDirectory stringByAppendingPathComponent:dbName];
    
	if(sqlite3_open([filePath UTF8String], &database) == SQLITE_OK) {
        
        const char *sqlStatement = "DELETE FROM tasks WHERE task_id=?";
        
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)    {
            sqlite3_bind_text( compiledStatement, 1, [task.taskId UTF8String], -1, SQLITE_TRANSIENT);
        }
        if(sqlite3_step(compiledStatement) != SQLITE_DONE ) {
            NSLog( @"deleteFolder Error: %s", sqlite3_errmsg(database) );
        }
        
        sqlite3_finalize(compiledStatement); 
	}
	sqlite3_close(database);
}

+ (NSMutableArray *) getAllTasks{
    sqlite3 *database; 
    NSMutableArray *array = [[[NSMutableArray alloc]init] autorelease];
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:dbName]; 
    
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        const char *sql = "select task_id, task_description, task_dateTime, task_priority,  task_type, repeat_interval, alert_tone, task_status, task_toBeCheked,email,note,sync_id from tasks WHERE task_delete_status = 0 ORDER BY task_DateTime desc";
        sqlite3_stmt *selectStatement; 
        int returnValue = sqlite3_prepare_v2(database, sql, -1, &selectStatement, NULL);
        if(returnValue == SQLITE_OK)
        { 
            while(sqlite3_step(selectStatement) == SQLITE_ROW)
            {  
                Task *task = [[Task alloc]init]; 
                const char *charString = (char *)sqlite3_column_text(selectStatement, 0);
                task.taskId =  [NSString stringWithUTF8String:charString];
                
                charString = (char *)sqlite3_column_text(selectStatement, 1);
                if (charString) {
                    task.taskDescription = [NSString stringWithUTF8String:charString];
                }
                int dateTime = sqlite3_column_int(selectStatement, 2);
                     task.taskDateTime = [NSDate dateWithTimeIntervalSince1970:dateTime];
               charString= (char *)sqlite3_column_text(selectStatement, 3);
                if (charString) {
                    task.priority = [NSString stringWithUTF8String:charString];
                } 
                charString= (char *)sqlite3_column_text(selectStatement, 4);
                if (charString) {
                    task.taskType = [NSString stringWithUTF8String:charString];
                }
                charString = (char *)sqlite3_column_text(selectStatement, 5);
                if (charString) {
                    task.repeatInterval = [NSString stringWithUTF8String:charString];
                }
                charString = (char *)sqlite3_column_text(selectStatement, 6);
                if (charString) {
                    task.alertTone = [NSString stringWithUTF8String:charString];
                }
               charString = (char *)sqlite3_column_text(selectStatement, 7);
                if (charString) {
                    task.taskStatus = [NSString stringWithUTF8String:charString];
                }
                charString = (char *)sqlite3_column_text(selectStatement, 8);
                if (charString) {
                    task.toBeCheked = [NSString stringWithUTF8String:charString];
                }
                charString = (char *)sqlite3_column_text(selectStatement, 9);
                if (charString) {
                    task.email = [NSString stringWithUTF8String:charString];
                }
                charString = (char *)sqlite3_column_text(selectStatement, 10);
                if (charString) {
                    task.note = [NSString stringWithUTF8String:charString];
                }
                charString = (char *)sqlite3_column_text(selectStatement, 11);
                if (charString) {
                    task.syncId = [NSString stringWithUTF8String:charString];
                }
                [array addObject:task];
                [task release];
            }
        }else {
            NSLog(@"getAllTasks error");
        } 
        sqlite3_finalize(selectStatement);
    } 
    else
        sqlite3_close(database);
    return array;
}

+ (NSMutableArray *) getAllToBeCheckedTasks{
    sqlite3 *database;
    
    NSMutableArray *array = nil; 
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:dbName];
    
    
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {   
        NSString *sqlString = [NSString stringWithFormat:@"select task_id, task_description, task_dateTime, task_priority,  task_type, repeat_interval, alert_tone, task_status , task_toBeCheked from tasks where task_toBeCheked = 1  and task_status = 0 ORDER BY task_DateTime desc"];
                
        const char *sql = [sqlString UTF8String];
        
        sqlite3_stmt *selectStatement; 
        int returnValue = sqlite3_prepare_v2(database, sql, -1, &selectStatement, NULL);
        if(returnValue == SQLITE_OK)
        { 
            while(sqlite3_step(selectStatement) == SQLITE_ROW)
            { 
                if (array == nil) {
                    array = [[[NSMutableArray alloc]init] autorelease];
                }
                Task *task = [[Task alloc]init];
                
                const char *charString = (char *)sqlite3_column_text(selectStatement, 0);
                task.taskId =  [NSString stringWithUTF8String:charString];
                
                charString = (char *)sqlite3_column_text(selectStatement, 1);
                if (charString) {
                    task.taskDescription = [NSString stringWithUTF8String:charString];
                }
                int dateTime = sqlite3_column_int(selectStatement, 2);
                task.taskDateTime = [NSDate dateWithTimeIntervalSince1970:dateTime];
                charString= (char *)sqlite3_column_text(selectStatement, 3);
                if (charString) {
                    task.priority = [NSString stringWithUTF8String:charString];
                } 
                charString= (char *)sqlite3_column_text(selectStatement, 4);
                if (charString) {
                    task.taskType = [NSString stringWithUTF8String:charString];
                }
                charString = (char *)sqlite3_column_text(selectStatement, 5);
                if (charString) {
                    task.repeatInterval = [NSString stringWithUTF8String:charString];
                }
                charString = (char *)sqlite3_column_text(selectStatement, 6);
                if (charString) {
                    task.alertTone = [NSString stringWithUTF8String:charString];
                }
                charString = (char *)sqlite3_column_text(selectStatement, 7);
                if (charString) {
                    task.taskStatus = [NSString stringWithUTF8String:charString];
                }
                charString = (char *)sqlite3_column_text(selectStatement, 8);
                if (charString) {
                    task.toBeCheked = [NSString stringWithUTF8String:charString];
                }
                [array addObject:task];
                [task release];
            }
        }else {
            NSLog(@"getAllToBeCheckedTasks error");
        } 
        sqlite3_finalize(selectStatement);
    } 
    else
        sqlite3_close(database);
    return array;
}

+ (NSMutableArray *) getAllUnsyncedTasks{

    sqlite3 *database;
    
    NSMutableArray *array = nil;
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:dbName];
    
    
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *sqlString = [NSString stringWithFormat:@"select task_id, task_description, task_dateTime, task_priority,  task_type, repeat_interval, alert_tone, task_status , time_zone, email, note,sync_id, task_delete_status from tasks where sync_status <> \"Synced\"  "];
        
        const char *sql = [sqlString UTF8String];
        
        sqlite3_stmt *selectStatement;
        int returnValue = sqlite3_prepare_v2(database, sql, -1, &selectStatement, NULL);
        if(returnValue == SQLITE_OK)
        {
            while(sqlite3_step(selectStatement) == SQLITE_ROW)
            {
                if (array == nil) {
                    array = [[[NSMutableArray alloc]init] autorelease];
                }
                Task *task = [[Task alloc]init];
                
                const char *charString = (char *)sqlite3_column_text(selectStatement, 0);
                task.taskId =  [NSString stringWithUTF8String:charString];
                
                charString = (char *)sqlite3_column_text(selectStatement, 1);
                if (charString) {
                    task.taskDescription = [NSString stringWithUTF8String:charString];
                }
                int dateTime = sqlite3_column_int(selectStatement, 2);
                task.taskDateTime = [NSDate dateWithTimeIntervalSince1970:dateTime];
                charString= (char *)sqlite3_column_text(selectStatement, 3);
                if (charString) {
                    task.priority = [NSString stringWithUTF8String:charString];
                }
                charString= (char *)sqlite3_column_text(selectStatement, 4);
                if (charString) {
                    task.taskType = [NSString stringWithUTF8String:charString];
                }
                charString = (char *)sqlite3_column_text(selectStatement, 5);
                if (charString) {
                    task.repeatInterval = [NSString stringWithUTF8String:charString];
                }
                charString = (char *)sqlite3_column_text(selectStatement, 6);
                if (charString) {
                    task.alertTone = [NSString stringWithUTF8String:charString];
                }
                charString = (char *)sqlite3_column_text(selectStatement, 7);
                if (charString) {
                    task.taskStatus = [NSString stringWithUTF8String:charString];
                }
                charString = (char *)sqlite3_column_text(selectStatement, 8);
                if (charString) {
                    task.taskTimeZone = [NSString stringWithUTF8String:charString];
                }
                charString = (char *)sqlite3_column_text(selectStatement, 9);
                if (charString) {
                    task.email = [NSString stringWithUTF8String:charString];
                }
                charString = (char *)sqlite3_column_text(selectStatement, 10);
                if (charString) {
                    task.note = [NSString stringWithUTF8String:charString];
                }
                charString = (char *)sqlite3_column_text(selectStatement, 11);
                if (charString) {
                    task.syncId = [NSString stringWithUTF8String:charString];
                }
                charString = (char *)sqlite3_column_text(selectStatement, 12);
                if (charString) {
                    task.deleteStatus = [NSString stringWithUTF8String:charString];
                }
                [array addObject:task];
                [task release];
            }
        }else {
            NSLog(@"getAllUnsyncedTasks error");
        }
        sqlite3_finalize(selectStatement);
    }
    else
        sqlite3_close(database);

    
    
    return array;
}

+ (NSMutableArray *) getAllpendingTasks{
    sqlite3 *database;
    
    NSMutableArray *array = nil; 
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:dbName];
    
    NSDate *now = [[NSDate alloc]init] ;
    
   int nowTimeStamp =[now timeIntervalSince1970] ;
    
    
    [now release]; 

    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {   
        NSString *sqlString = [NSString stringWithFormat:@"select task_id, task_description, task_dateTime, task_priority,  task_type, repeat_interval, alert_tone, task_status , task_toBeCheked , task_delete_status,sync_id,email,note from tasks where task_dateTime <= %d  and task_status = 0 and task_delete_status = 0 ORDER BY task_DateTime  desc",nowTimeStamp];
               
        const char *sql = [sqlString UTF8String];
        
        sqlite3_stmt *selectStatement; 
        int returnValue = sqlite3_prepare_v2(database, sql, -1, &selectStatement, NULL);
        if(returnValue == SQLITE_OK)
        { 
            while(sqlite3_step(selectStatement) == SQLITE_ROW)
            { 
                if (array == nil) {
                    array = [[[NSMutableArray alloc]init] autorelease];
                }
                Task *task = [[Task alloc]init];
                
                const char *charString = (char *)sqlite3_column_text(selectStatement, 0);
                task.taskId =  [NSString stringWithUTF8String:charString];
                
                charString = (char *)sqlite3_column_text(selectStatement, 1);
                if (charString) {
                    task.taskDescription = [NSString stringWithUTF8String:charString];
                }
                int dateTime = sqlite3_column_int(selectStatement, 2);
                task.taskDateTime = [NSDate dateWithTimeIntervalSince1970:dateTime];
                charString= (char *)sqlite3_column_text(selectStatement, 3);
                if (charString) {
                    task.priority = [NSString stringWithUTF8String:charString];
                } 
                charString= (char *)sqlite3_column_text(selectStatement, 4);
                if (charString) {
                    task.taskType = [NSString stringWithUTF8String:charString];
                }
                charString = (char *)sqlite3_column_text(selectStatement, 5);
                if (charString) {
                    task.repeatInterval = [NSString stringWithUTF8String:charString];
                }
                charString = (char *)sqlite3_column_text(selectStatement, 6);
                if (charString) {
                    task.alertTone = [NSString stringWithUTF8String:charString];
                }
                charString = (char *)sqlite3_column_text(selectStatement, 7);
                if (charString) {
                    task.taskStatus = [NSString stringWithUTF8String:charString];
                }
                charString = (char *)sqlite3_column_text(selectStatement, 8);
                if (charString) {
                    task.toBeCheked = [NSString stringWithUTF8String:charString];
                }
                
                charString = (char *)sqlite3_column_text(selectStatement, 9);
                if (charString) {
                    task.deleteStatus = [NSString stringWithUTF8String:charString];
                }
                charString = (char *)sqlite3_column_text(selectStatement, 10);
                if (charString) {
                    task.syncId = [NSString stringWithUTF8String:charString];
                }
                charString = (char *)sqlite3_column_text(selectStatement, 11);
                if (charString) {
                    task.email = [NSString stringWithUTF8String:charString];
                }
                charString = (char *)sqlite3_column_text(selectStatement, 12);
                if (charString) {
                    task.note = [NSString stringWithUTF8String:charString];
                }
                
                [array addObject:task];
                [task release];
            }
        }else {
            NSLog(@"getAllpendingTask error");
        } 
        sqlite3_finalize(selectStatement);
    } 
    else
        sqlite3_close(database);
    return array;
}

+ (Task *) getTask:(int)taskID{
    
    
    sqlite3 *database;
    Task *task = [[[Task alloc] init] autorelease]; 
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:dbName];
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *sqlString = [NSString stringWithFormat:@"select task_id, task_description, task_dateTime, task_priority,  task_type, repeat_interval, alert_tone, task_status, task_toBeCheked, task_delete_status,sync_id,email,note from tasks WHERE  task_id = '%d' LIMIT 1",taskID];
        sqlite3_stmt *selectStatement;
        
        
        int returnValue = sqlite3_prepare_v2(database, [sqlString UTF8String], -1, &selectStatement, NULL);
        if(returnValue == SQLITE_OK)
        {
            
            while(sqlite3_step(selectStatement) == SQLITE_ROW)
            {   
                const char *charString = (char *)sqlite3_column_text(selectStatement, 0);
                task.taskId =  [NSString stringWithUTF8String:charString];
                
                charString = (char *)sqlite3_column_text(selectStatement, 1);
                if (charString) {
                    task.taskDescription = [NSString stringWithUTF8String:charString];
                }
                int dateTime = sqlite3_column_int(selectStatement, 2);
                task.taskDateTime = [NSDate dateWithTimeIntervalSince1970:dateTime];
                charString= (char *)sqlite3_column_text(selectStatement, 3);
                if (charString) {
                    task.priority = [NSString stringWithUTF8String:charString];
                } 
                charString= (char *)sqlite3_column_text(selectStatement, 4);
                if (charString) {
                    task.taskType = [NSString stringWithUTF8String:charString];
                }
                charString = (char *)sqlite3_column_text(selectStatement, 5);
                if (charString) {
                    task.repeatInterval = [NSString stringWithUTF8String:charString];
                }
                charString = (char *)sqlite3_column_text(selectStatement, 6);
                if (charString) {
                    task.alertTone = [NSString stringWithUTF8String:charString];
                }
                charString = (char *)sqlite3_column_text(selectStatement, 7);
                if (charString) {
                    task.taskStatus = [NSString stringWithUTF8String:charString];
                }
                charString = (char *)sqlite3_column_text(selectStatement, 8);
                if (charString) {
                    task.toBeCheked = [NSString stringWithUTF8String:charString];
                }
                charString = (char *)sqlite3_column_text(selectStatement, 9);
                if (charString) {
                    task.deleteStatus = [NSString stringWithUTF8String:charString];
                }
                charString = (char *)sqlite3_column_text(selectStatement, 10);
                if (charString) {
                    task.syncId = [NSString stringWithUTF8String:charString];
                }
                charString = (char *)sqlite3_column_text(selectStatement, 11);
                if (charString) {
                    task.email = [NSString stringWithUTF8String:charString];
                }
                charString = (char *)sqlite3_column_text(selectStatement, 12);
                if (charString) {
                    task.note = [NSString stringWithUTF8String:charString];
                }
            }
        }else {
            NSLog(@"get Task error");
        } 
        sqlite3_finalize(selectStatement);
    } 
    else
        sqlite3_close(database);
    return task;
} 

+(void)UpdateFireDateNext:(BOOL)next{
    
    NSArray *arrayOfLocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications] ;
    
    for (UILocalNotification *localNotification in arrayOfLocalNotifications) {
        
        if ( [[NSDate date] timeIntervalSinceDate:localNotification.fireDate]>0.0 ) {
            
            NSCalendar *calendar = localNotification.repeatCalendar;
            if (!calendar) {
                calendar = [NSCalendar currentCalendar];
            }
            
            Task *taskR = [DBConnect getTask:[[localNotification.userInfo objectForKey:@"taskID"] intValue]] ;
            
            if([taskR.taskDateTime timeIntervalSinceNow] < 0.0){ 
                
                NSDateComponents *comps = [[NSCalendar currentCalendar] components:localNotification.repeatInterval fromDate:localNotification.fireDate toDate:[NSDate date]  options:0];
                [comps setSecond:0];
                NSDate *nextFireDate = [calendar dateByAddingComponents:comps toDate:localNotification.fireDate options:0];
                
                if (next == YES) {
                    
                    NSDateComponents *components = [[[NSDateComponents alloc] init] autorelease];
                    if (localNotification.repeatInterval == NSHourCalendarUnit) {
                        components.Hour = 1;
                    }else if(localNotification.repeatInterval == NSDayCalendarUnit)  {
                        components.day = 1;
                    }else if(localNotification.repeatInterval == NSWeekCalendarUnit) {
                        components.week = 1;
                    }else if (localNotification.repeatInterval == NSMonthCalendarUnit) {
                        components.month = 1;
                    }else if (localNotification.repeatInterval == NSYearCalendarUnit) {
                        components.year = 1;
                    }
                   
                    nextFireDate = [calendar dateByAddingComponents:components toDate: nextFireDate options:0];
                }           
                
                taskR.taskDateTime = nextFireDate ;
                
                [DBConnect updateTask:taskR];
                
            }
            
        }
        
    }
    
}

#pragma mark insert email

+ (NSString *)insertNewEmail:(StoredEmail *)email{
   
    NSLog(@"email %@",email);
    NSString *lastInsertedEmailId = @"";
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:dbName];
    
    sqlite3 *database;
    
    if(sqlite3_open([filePath UTF8String], &database) == SQLITE_OK) {
        
        const char *sqlStatement = "insert into emails (task_email) VALUES (?)";
		
        
        sqlite3_stmt *compiledStatement;
        
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)    {
            
			sqlite3_bind_text( compiledStatement, 1, [email.storedEmail UTF8String], -1, SQLITE_TRANSIENT);
            
        }
        
        
		if(sqlite3_step(compiledStatement) != SQLITE_DONE ) {
			NSLog( @"add new Email Error: %s", sqlite3_errmsg(database) );
		}else{
            lastInsertedEmailId = [NSString stringWithFormat:@"%lld",sqlite3_last_insert_rowid(database)];
        }
        
		sqlite3_finalize(compiledStatement);
	}
	
    sqlite3_close(database);
    
    
    
    return lastInsertedEmailId;
    
}

+ (void)deleteEmail:(StoredEmail *)email {
    sqlite3 *database;
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:dbName];
    
	if(sqlite3_open([filePath UTF8String], &database) == SQLITE_OK) {
        
        const char *sqlStatement = "DELETE FROM emails WHERE email_id=?";
        
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)    {
            sqlite3_bind_text( compiledStatement, 1, [email.emailId UTF8String], -1, SQLITE_TRANSIENT);
        }
        if(sqlite3_step(compiledStatement) != SQLITE_DONE ) {
            NSLog( @"deleteFolder Error: %s", sqlite3_errmsg(database) );
        }
        
        sqlite3_finalize(compiledStatement);
	}
	sqlite3_close(database);
}

+ (NSMutableArray *) getAllEmails{
    sqlite3 *database;
    NSMutableArray *array = [[[NSMutableArray alloc]init] autorelease];
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:dbName];
    
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        const char *sql = "select email_id, task_email from emails";
        sqlite3_stmt *selectStatement;
        int returnValue = sqlite3_prepare_v2(database, sql, -1, &selectStatement, NULL);
        if(returnValue == SQLITE_OK)
        {
            while(sqlite3_step(selectStatement) == SQLITE_ROW)
            {
                StoredEmail *email = [[StoredEmail alloc]init];
                const char *charString = (char *)sqlite3_column_text(selectStatement, 0);
                email.emailId =  [NSString stringWithUTF8String:charString];
                
                charString = (char *)sqlite3_column_text(selectStatement, 1);
                if (charString) {
                    email.storedEmail= [NSString stringWithUTF8String:charString];
                }
                [array addObject:email];
                               
                [email release];
            }
        }else {
            NSLog(@"getAllEmails error");
        }
        sqlite3_finalize(selectStatement);
    }
    else
        sqlite3_close(database);
    return array;
}

+ (BOOL) isEmailExists:(NSString *)email{

       
    sqlite3 *database;
    NSInteger numrows = 0;
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:dbName];
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *sqlString = [NSString stringWithFormat:@"select email_id, task_email from emails WHERE  task_email = '%@' LIMIT 1",email];
        sqlite3_stmt *selectStatement;
                
        int returnValue = sqlite3_prepare_v2(database, [sqlString UTF8String], -1, &selectStatement, NULL);
        if(returnValue == SQLITE_OK)
        {
            
            while(sqlite3_step(selectStatement) == SQLITE_ROW)
            {                              
                    numrows= sqlite3_column_int(selectStatement, 0);
                               
            }
        }else {
            NSLog(@"isEmailExists error");
        }
        sqlite3_finalize(selectStatement);
    }
    else
        sqlite3_close(database);
        
    if(numrows > 0){
        return YES;
        
    }else{
        
         
        return NO;
    }
    
}





+ (NSString *)insertNewTaskEmail:(TaskEmail *)taskEmail{

    NSString *lastInsertedEmailId = @"";
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:dbName];
    
    sqlite3 *database;
    
    if(sqlite3_open([filePath UTF8String], &database) == SQLITE_OK) {
        
        const char *sqlStatement = "insert into task_emails (task_email,task_id) VALUES (?,?)";
		
        
        sqlite3_stmt *compiledStatement;
        
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)    {
            
			sqlite3_bind_text( compiledStatement, 1, [taskEmail.email UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( compiledStatement, 2, [taskEmail.taskId UTF8String], -1, SQLITE_TRANSIENT);
            
        }
               
		if(sqlite3_step(compiledStatement) != SQLITE_DONE ) {
			NSLog( @"add new task_Email Error: %s", sqlite3_errmsg(database) );
		}else{
            lastInsertedEmailId = [NSString stringWithFormat:@"%lld",sqlite3_last_insert_rowid(database)];
        }
        
		sqlite3_finalize(compiledStatement);
	}
	
    sqlite3_close(database);
    
    return lastInsertedEmailId;

}

+ (NSMutableArray *) getAllTaskEmails:(Task *)task{
    sqlite3 *database;
    NSMutableArray *array = [[[NSMutableArray alloc]init] autorelease];
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:dbName];
    
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *sqlString = [NSString stringWithFormat:@"select email_id, task_email from task_emails where task_id = %@ ", task.taskId];
                
        const char *sql = [sqlString UTF8String];
        
        sqlite3_stmt *selectStatement;
        int returnValue = sqlite3_prepare_v2(database, sql, -1, &selectStatement, NULL);
        if(returnValue == SQLITE_OK)
        {
            while(sqlite3_step(selectStatement) == SQLITE_ROW)
            {
                if (array == nil) {
                    array = [[[NSMutableArray alloc]init] autorelease];
                }
        
                TaskEmail *taskEmail = [[TaskEmail alloc]init];
                const char *charString = (char *)sqlite3_column_text(selectStatement, 0);
                taskEmail.emailId =  [NSString stringWithUTF8String:charString];
                
                charString = (char *)sqlite3_column_text(selectStatement,0);
                if (charString) {
                    taskEmail.taskId = [NSString stringWithUTF8String:charString];
                }
                
                charString = (char *)sqlite3_column_text(selectStatement, 1);
                if (charString) {
                    taskEmail.email = [NSString stringWithUTF8String:charString];
                }
                
                [array addObject:taskEmail];
                
                [taskEmail release];
            }
        }else {
            NSLog(@"getAllTaskEmails error");
        }
        sqlite3_finalize(selectStatement);
    }
    else
        sqlite3_close(database);
    return array;
}

+ (void)deleteTaskEmails:(Task *)task {
    sqlite3 *database;
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:dbName];
    
	if(sqlite3_open([filePath UTF8String], &database) == SQLITE_OK) {
        
        const char *sqlStatement = "DELETE FROM task_emails WHERE task_id=?";
        
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)    {
            sqlite3_bind_text( compiledStatement, 1, [task.taskId UTF8String], -1, SQLITE_TRANSIENT);
        }
        if(sqlite3_step(compiledStatement) != SQLITE_DONE ) {
            NSLog( @"deleteFolder Error: %s", sqlite3_errmsg(database) );
        }
        
        sqlite3_finalize(compiledStatement);
	}
	sqlite3_close(database);
}


@end
