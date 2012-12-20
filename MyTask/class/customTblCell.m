//
//  customTableCell.m
//  MyTask
//
//  Created by Samir Husain on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomTblCell.h"
#import "AllTasksViewController.h"
#import "PendingTasksViewController.h"
#import "DBConnect.h"

@implementation CustomTblCell

- (id)initWithPriority:(NSString *)tPriority status:(NSString *)tStatus repeatInterval:(NSString *)tInterval
{

    self = [super init];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setBackgroundColor:[UIColor clearColor]];
        taskPriorityButton = [UIButton buttonWithType:UIButtonTypeCustom];
        taskPriorityButton.frame = CGRectMake(218, 0, 40, 51);
        UIImage *taskPImage;
        if ([tPriority isEqualToString:taskPr_high]) {
            taskPImage = [UIImage imageNamed:taskPrImage_high];
        }else if([tPriority isEqualToString:taskPr_medium]){
            taskPImage = [UIImage imageNamed:taskPrImage_medium];
        }else{
            taskPImage = [UIImage imageNamed:taskPrImage_low] ;
        }  
        
        
        [taskPriorityButton setImage:taskPImage forState:UIControlStateNormal]; 
        [taskPriorityButton setContentMode:UIViewContentModeCenter];
        [taskPriorityButton addTarget:self action:@selector(priorityButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:taskPriorityButton];
        
        if ([tInterval isEqualToString:taskRptIntv_none]) {
            taskStatusButton = [UIButton buttonWithType:UIButtonTypeCustom];
            taskStatusButton.frame = CGRectMake(253, 0, 30, 51);
            UIImage *taskSImage = [[[UIImage alloc]init]autorelease]; 
            
            if ([tStatus isEqualToString:textNotDone]) {
                taskSImage = [UIImage imageNamed:@"notDone.png"];
            }else if ([tStatus isEqualToString:textDone]){
                taskSImage = [UIImage imageNamed:@"done.png"];
            } 
            
            [taskStatusButton setImage:taskSImage forState:UIControlStateNormal];
            [taskStatusButton setContentMode:UIViewContentModeCenter];
            [taskStatusButton addTarget:self action:@selector(statusButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:taskStatusButton]; 
        } 
        
        
        
        
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator]; 
    } 
    return self;

    
}



- (void)priorityButtonClicked:(id)sender{
    
    UIImage *taskPImage = [[[UIImage alloc]init]autorelease]; 
    if([task.priority isEqualToString:taskPr_high ]){
        taskPImage = [UIImage imageNamed:taskPrImage_low];  
        task.priority  = taskPr_low;
    }else if([task.priority isEqualToString:taskPr_medium ]){
        taskPImage = [UIImage imageNamed:taskPrImage_high]; 
        task.priority  = taskPr_high;
    }else if([task.priority isEqualToString:taskPr_low ]){
        taskPImage = [UIImage imageNamed:taskPrImage_medium]; 
        task.priority  = taskPr_medium;
    }
    task.syncStatus = textSyncStatus_edited;
    [DBConnect updateTask:task];   
    [taskPriorityButton setImage:taskPImage forState:UIControlStateNormal]; 
    [taskPriorityButton setContentMode:UIViewContentModeCenter];

}


- (void)statusButtonClicked:(id)sender{
    
    UIImage *taskSImage; 
    
    if ([task.taskStatus isEqualToString:textNotDone] && [task.repeatInterval isEqualToString:taskRptIntv_none]) {
        taskSImage = [UIImage imageNamed:@"done.png"];
        task.taskStatus = textDone; 
        task.toBeCheked = 0;
        task.syncStatus = textSyncStatus_edited;
        [DBConnect updateTask:task];
        [task removeNotification];
        if (pTaskViewController) { 
            NSIndexPath *iPath = [NSIndexPath indexPathForRow:rowNo inSection:0];
            [pTaskViewController deleteTableViewCell:iPath];
        }
    }else if([task.taskStatus isEqualToString:textDone] && [task.repeatInterval isEqualToString:taskRptIntv_none]){
        taskSImage = [UIImage imageNamed:@"notDone.png"] ;
        task.taskStatus = textNotDone;
        task.syncStatus = textSyncStatus_edited;
        [DBConnect updateTask:task];
        [task removeNotification];
        
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MMM dd, yyyy HH:mm"];
        NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
        NSDate *nowDate = [dateFormat dateFromString:dateString ];
        
        if([task.taskDateTime timeIntervalSince1970] > [nowDate timeIntervalSince1970] ){
            [task setNotification];
        }
        
        [dateFormat release];
        
    }else {
        taskSImage = [UIImage imageNamed:@"notDone.png"] ;
    }  
    
    [taskStatusButton setImage:taskSImage forState:UIControlStateNormal];
    [taskStatusButton setContentMode:UIViewContentModeCenter];
    
    
}



	
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated]; 
}


-(void)drawRect:(CGRect)rect{ 
    
    UIImage *taskTypeImage = [[[UIImage alloc]init ]autorelease];
    if([task.taskType isEqualToString:taskTy_meeting]){
        taskTypeImage = [UIImage imageNamed:taskTyImage_meeting];
    }else if([task.taskType isEqualToString:taskTy_call]){
        taskTypeImage = [UIImage imageNamed:taskTyImage_call];
    }else if([task.taskType isEqualToString:taskTy_reminder]){
        taskTypeImage = [UIImage imageNamed:taskTyImage_reminder];
    }
    
    backGroundImg = [UIImage imageNamed:@"cellbg.png"]; 
    
    [backGroundImg drawInRect:CGRectMake(0, 0, 320, 51)];
    [taskTypeImage drawInRect:CGRectMake(5, 5, 40, 40 )];
    if (![task.repeatInterval isEqualToString:taskRptIntv_none]) {
        UIImage *taskRptImage = [UIImage imageNamed:taskRepeatImage];
        [taskRptImage drawInRect:CGRectMake(260, 15, 20, 20)]; 
    }
    
        
    NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init]autorelease]; 
    [dateFormat setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormat setDateStyle:NSDateFormatterMediumStyle];
    [dateFormat setDoesRelativeDateFormatting:YES]; 
    
    [[UIColor whiteColor] set];
    
    if([task.taskDescription length]>25){
        NSString *taskDescriptionText= [[task.taskDescription substringWithRange:NSMakeRange(0, 24)] stringByAppendingString:@"..."];    
        [taskDescriptionText drawInRect:CGRectMake(50, 5, 190, 10) withFont:[UIFont fontWithName:@"Helvetica" size:14]];
    }else {
        [task.taskDescription drawInRect:CGRectMake(50, 5, 190, 10) withFont:[UIFont fontWithName:@"Helvetica" size:14]];
    }
    
    [[UIColor whiteColor] set];
    
    NSString *dateTimeFmtd = [NSString stringWithFormat:@"%@",[dateFormat stringFromDate:task.taskDateTime]]; 
    [dateTimeFmtd drawAtPoint:CGPointMake(50, 25) withFont:[UIFont fontWithName:@"Helvetica" size:12]]; 
} 
 
-(void)setTask:(Task*)atask{
    task = atask; 
}

- (void)setPtaskVeiwControler:(PendingTasksViewController *)vc{
    pTaskViewController = vc;
}

- (void)setRow:(int)row{
    rowNo = row;
}

@end
