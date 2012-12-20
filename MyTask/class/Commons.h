//
//  Commons.h
//  MyTask
//
//  Created by Susitha Janaka on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Task.h"
//#import "DBConnect.h"

#define documentsDirectory  ([NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0])

#define dbName @"taskdb.sqlite" 

#define taskPr_high @"High"
#define taskPr_medium @"Medium"
#define taskPr_low @"Low"

#define taskPrImage_high @"highPriorityimage.png"
#define taskPrImage_medium @"mediumPriorityimage.png"
#define taskPrImage_low @"lowPriorityimage.png"

#define taskTy_call @"Call"
#define taskTy_meeting @"Meeting"
#define taskTy_reminder @"Reminder"

#define taskTyImage_call @"callImage.png"
#define taskTyImage_meeting @"meetingImage.png"
#define taskTyImage_reminder @"reminder.png"
#define taskRepeatImage @"repeatImage.png"


#define taskRptIntv_none @"None"
#define taskRptIntv_hourly @"Hourly"
#define taskRptIntv_daily @"Daily"
#define taskRptIntv_weekly @"Weekly"
#define taskRptIntv_monthly @"Monthly"
#define taskRptIntv_yearly @"Yearly"


#define taskAlertToneText_Default @"Default" 
#define taskAlertToneText_Epsilon @"Epsilon"
#define taskAlertToneText_Berring @"Berring"
#define taskAlertToneText_Blipper @"Blipper"
#define taskAlertToneText_Chimes @"Chimes"

#define taskAlertTone_Default @"TriTone"
#define taskAlertTone_Epsilon @"Epsilon.aif"
#define taskAlertTone_Berring @"Berring.aif"
#define taskAlertTone_Blipper @"Blipper.aif"
#define taskAlertTone_Chimes @"Chimes.aif"

#define textDone @"1"
#define textNotDone @"0"

#define textSyncStatus_new @"New"
#define textSyncStatus_edited @"Edited"
#define textSyncStatus_synced @"Synced"
#define textSyncStatus_deleted @"Deleted"
#define textSyncStatus_syncing @"Syncing"

//#define remoteWebServerURL @"http://localhost/mytask/sync.php"
#define remoteWebServerURL @"http://beta.cenango.com/mytask/sync.php"

@interface Commons : NSObject{
    
    enum priority{
        p_high   = 1,
        p_low    = 2,
        p_medium = 3,
    };
    
    enum repeatInterval{
        r_hourly  = 1,
        r_daily   = 2,
        r_weekly  = 3,
        r_monthly = 4,
        r_yearly  = 5,
    };

}




 
@end
