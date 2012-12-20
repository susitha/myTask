//
//  customTableCell.h
//  MyTask
//
//  Created by Samir Husain on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "PendingTasksViewController.h"
#import "Commons.h"
 

@class PendingTasksViewController;
@interface CustomTblCell : UITableViewCell
{
    UIImage *backGroundImg;  
    UIButton *taskPriorityButton;
    Task  *task;
    UIButton *taskStatusButton; 
    PendingTasksViewController *pTaskViewController;
    UIImage *notfyImage;
    int rowNo;
} 
 
- (void)setTask:(Task*)task;
- (id)initWithPriority:(NSString *)tPriority status:(NSString *)tStatus repeatInterval:(NSString *)tInterval;
- (void)setPtaskVeiwControler:(PendingTasksViewController *)vc;
- (void)setRow:(int)row;

@end
