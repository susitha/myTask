//
//  Sync.h
//  MyTask
//
//  Created by Samir on 11/6/12.
//
//

#import <Foundation/Foundation.h>
#import "DBConnect.h"
#import "Task.h"
#import "RequestDelegate.h"

@interface Sync : NSObject{
   
    NSMutableArray *unsyncedTasks;
    
}


-(void)syncStart;

@end
