//
//  MakeTaskViewController.h
//  MyTask
//
//  Created by Susitha Janaka on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskAppDelegate.h"
#import "Task.h"
#import "DBConnect.h"
#import "Commons.h"
#import "RequestDelegate.h"

@interface MakeTaskViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    IBOutlet UITableViewCell *cellTaskType;
    IBOutlet UITableViewCell *cellAlertTone;
    IBOutlet UITableViewCell *cellDueDate;
    IBOutlet UITableViewCell *cellPriority;
    IBOutlet UITableViewCell *cellRepeatInterval; 
    IBOutlet UITableViewCell *cellDescription;
    IBOutlet UITableViewCell *cellDeleteButton; 
    IBOutlet UITableViewCell *cellDoneDeleteButton;
    IBOutlet UITableViewCell *cellEmail;
    IBOutlet UITableViewCell *cellNote;
    //IBOutlet UITextView *textViewDescription;
    IBOutlet UITextField *textViewDescription;
    IBOutlet UITextField *textEmail;
    IBOutlet UITextField *textNote;
    IBOutlet UITableView *dataEntryTable;
    IBOutlet UILabel *labelDueDate;  
    IBOutlet UILabel *labelRptInterval;  
    IBOutlet UILabel *labelTone;
    IBOutlet UILabel *labelNote;
    IBOutlet UILabel *labelTaskType;
    IBOutlet UILabel *labelPriority;
    IBOutlet UISegmentedControl *segmentTaskType;
    IBOutlet UISegmentedControl *segmentTaskPriority;
    BOOL isNotificationTriggered;
    BOOL isPushed;
    BOOL isViewed;

    NSMutableArray *sendSelectedEmails;
    NSMutableArray *tempSelectedEmails;
    NSMutableArray *emails;
    
    Task *task;
   
    NSString *dateString;
    NSDateFormatter *format;   
    
}
@property (nonatomic, retain) IBOutlet UITableViewCell *cellDescription;     
@property (nonatomic, retain) IBOutlet UITableViewCell *cellTaskType;
@property (nonatomic, retain) IBOutlet UITableViewCell *cellAlertTone;
@property (nonatomic, retain) IBOutlet UITableViewCell *cellDueDate;
@property (nonatomic, retain) IBOutlet UITableViewCell *cellPriority;
@property (nonatomic, retain) IBOutlet UITableViewCell *cellRepeatInterval; 
@property (nonatomic, retain) IBOutlet UITableViewCell *cellDeleteButton; 
@property (nonatomic, retain) IBOutlet UITableView *dataEntryTable;
@property (nonatomic, retain) IBOutlet UITextField *textViewDescription;
@property (nonatomic, retain) IBOutlet UILabel *labelDueDate;
@property (nonatomic, retain) IBOutlet UILabel *labelRptInterval;
@property (nonatomic, retain) IBOutlet UILabel *labelTone;
@property (nonatomic, retain) IBOutlet UITextField *textEmail;
@property (nonatomic, retain) IBOutlet UILabel *labelEmail;
@property (nonatomic, retain) IBOutlet UILabel *labelNote;
@property (nonatomic, retain) NSDateFormatter *format;
@property (nonatomic, retain) NSDateFormatter *formatRelativeDate;
@property (nonatomic, retain) Task *task;
@property (nonatomic, assign) BOOL isPushed;
@property (nonatomic, assign) BOOL isNotificationTriggered;

//@property (copy) NSMutableArray *sendSelectedEmails;


@property (copy) NSDate	*sendDateTime;
@property (copy) NSString *sendInterval;
@property (copy) NSString *sendTone;
@property (copy) NSString *sendEmail;
@property (copy) NSString *sendNoteText;

- (void)cancel;
- (IBAction)hideKeyboard:(id)sender;
- (IBAction)deleteTask:(id)sender;
- (void)setTaskDetailToView;
//- (void) setPickedDateTime:(NSDate *)pickedDateTime;



@end
