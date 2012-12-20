//
//  ThirdViewController.h
//  MyTask
//
//  Created by Samir Husain on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "Task.h"
@interface AddTaskViewController : UIViewController<UITextViewDelegate>
{
    UIButton *priorityButton;
    UITextView *taskDescription;
    NSString *databasePath; 
   // NSString *databaseName;
    UIDatePicker *dateTimePicker;
    IBOutlet UISegmentedControl *prioritySegmentedControl;
    NSNumber *lastTaskId;  
    Task *task;
}
@property (nonatomic,retain) Task *task;

@property (nonatomic,retain) IBOutlet UIButton *priorityButton;
@property (nonatomic,retain) IBOutlet UITextView *taskDescription;
@property (nonatomic,retain) IBOutlet UIDatePicker *dateTimePicker;
@property (nonatomic,retain) IBOutlet UISegmentedControl *prioritySegmentedControl;


-(IBAction)changePriority:(id)sender;
-(IBAction)changeButtonColor:(id)sender;
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (IBAction) saveData;
@end
