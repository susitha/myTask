//
//  Sync.m
//  MyTask
//
//  Created by Samir on 11/6/12.
//
//

#import "Sync.h"



@implementation Sync




-(void)syncStart{
    unsyncedTasks = [[NSMutableArray alloc]init];
    unsyncedTasks = [DBConnect getAllUnsyncedTasks];

    RequestDelegate *rd = [RequestDelegate sharedInstance];
    
    for(Task *task in  unsyncedTasks ) {
        
        task.syncStatus = textSyncStatus_syncing;
        [DBConnect updateTaskSyncStatus:task];
        [rd insertEmailNotificationWithTask:task];
       
    }

    //[unsyncedTasks release];
}

-(void)dealloc{
    
  //  [unsyncedTasks dealloc];
    
    [super dealloc];
    

}


@end

