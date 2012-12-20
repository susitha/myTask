//
//  MakeTaskViewController.m
//  MyTask
//
//  Created by Susitha Janaka on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MakeTaskViewController.h"
#import "DatePickViewController.h"
#import "TonePickViewController.h"
#import "RptIntervalViewController.h"
#import "PendingTasksViewController.h"
#import "EmailViewController.h"
#import "NoteViewController.h"

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJSON.h"
#import "RequestDelegate.h"

#import "Sync.h"

#define kOFFSET_FOR_KEYBOARD 280.0


#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation MakeTaskViewController

@synthesize cellTaskType,cellAlertTone,cellDueDate,cellPriority,cellRepeatInterval,cellDeleteButton;
@synthesize dataEntryTable,cellDescription;
@synthesize sendDateTime;
@synthesize labelDueDate;
@synthesize labelRptInterval;
@synthesize labelTone;
@synthesize format;
@synthesize formatRelativeDate;
@synthesize sendInterval;
@synthesize sendTone;
@synthesize sendEmail;
@synthesize sendNoteText;
@synthesize task;
@synthesize isPushed;
@synthesize isNotificationTriggered;
@synthesize textEmail;
@synthesize textViewDescription;
@synthesize labelNote;
//@synthesize sendSelectedEmails;


-(void)dealloc{

    [_labelEmail release];
    [super dealloc];
    [sendSelectedEmails release];
    [format release];
    [formatRelativeDate release];
    [cellDescription release];
    [cellTaskType release];
    [cellAlertTone release];
    [cellDueDate release];
    [cellPriority release];
    [cellRepeatInterval release];
    [cellDeleteButton release];
    [dataEntryTable release];
    [labelDueDate release];
    [labelRptInterval release];
    [labelTone release];
    [labelNote release];
    [task release];
    
    
    
}



- (void)shiftUpLayout{
    if ([textEmail isFirstResponder]  )
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        
        int y;
        if (self.navigationController.view.frame.size.height >480) {
            y = -30;
        }else{
            y = -120;
        }
        [self.view setFrame:CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height)];
        [UIView commitAnimations];
    }
//    }else if([textNote isFirstResponder]){
//        
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationBeginsFromCurrentState:YES];
//        [UIView setAnimationDuration:0.3f];
//        
//        int y;
//        if (self.navigationController.view.frame.size.height >480) {
//            y = -75;
//        }else{
//            y = -164;
//        }
//        [self.view setFrame:CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height)];
//        [UIView commitAnimations];
//    }


}

- (void)shiftDownLayout{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.2f];
    [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [UIView commitAnimations];

}


- (void)keyboardWillShow:(NSNotification *)note
{
     [self shiftUpLayout];
}

- (void)keyboardWillHide:(NSNotification *)note
{
    [self shiftDownLayout];
}


-(BOOL)isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; 
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(BOOL)isPastDate:(NSDate *)theDate{
    
    NSString *dateStr = [format stringFromDate:theDate];
    NSDate *taskDateTime = [format dateFromString:dateStr];
    NSString *dateStrNow = [format stringFromDate:[NSDate date]];
    NSDate *dateNow =  [format dateFromString:dateStrNow];
       
    if(  [dateNow timeIntervalSince1970] >= [taskDateTime timeIntervalSince1970]  ){
        return TRUE;
    }else {
        return FALSE;
    }
    
}


-(void)disableMakeTaskView{
    
    [cellDueDate setAccessoryType:UITableViewCellAccessoryNone];
    [cellRepeatInterval setAccessoryType:UITableViewCellAccessoryNone];
    [cellAlertTone setAccessoryType:UITableViewCellAccessoryNone];
    
    segmentTaskType.hidden = YES;
    segmentTaskPriority.hidden = YES;
   // textViewDescription.editable = NO;
    textViewDescription.enabled = NO;
    labelTaskType.hidden = NO;
    labelPriority.hidden = NO;
    textEmail.enabled = NO;
    
}

-(void)enableMakeTaskView{
    
    [cellDueDate setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cellRepeatInterval setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cellAlertTone setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    segmentTaskType.hidden = NO;
    segmentTaskPriority.hidden = NO;
   // textViewDescription.editable = YES;
    textViewDescription.enabled = YES;
    labelTaskType.hidden = YES;
    labelPriority.hidden = YES;
}


-(IBAction)doneTask:(id)sender{
    
    if([task.repeatInterval isEqualToString:taskRptIntv_none]){
        task.taskStatus = @"1";
        
        if(![self isPastDate:sendDateTime]){
            [task removeNotification];
        }
        isNotificationTriggered = NO;
    }
    task.syncStatus = textSyncStatus_edited;
    task.toBeCheked = 0;
    
    [DBConnect updateTask:task];
    
    self.title = @"Add Task";
    if (isPushed) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self dismissModalViewControllerAnimated:YES];
    }
    
    
}

-(IBAction)dismissView:(id)sender{
    
    isNotificationTriggered = NO;
    [self enableMakeTaskView];
    [self cancel];
    [self dismissModalViewControllerAnimated:YES];
   

}



#pragma mark Save Task 

- (void) saveTask:(id)sender {
        
    [textViewDescription resignFirstResponder];
        
    if( [textViewDescription.text isEqualToString: @""]){
        
        UIAlertView *altTitle = [[UIAlertView alloc]initWithTitle:nil message:@"Enter task title" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [altTitle show];
        [altTitle release];
    }else if (![textEmail.text  isEqualToString:@""] && ![self isValidEmail:textEmail.text] ) {
        UIAlertView *altTitle = [[UIAlertView alloc]initWithTitle:nil message:@"Enter valid email" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [altTitle show];
        [altTitle release];
        
    }else if ([self isPastDate:sendDateTime]) {
        
        UIAlertView *altTitle = [[UIAlertView alloc]initWithTitle:nil message:@"Enter future date" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [altTitle show];
        [altTitle release];
        
    }else {
        
        Task *taskObj = [[Task alloc] init];
        
        NSString *dateStr;
        
        if(sendDateTime != nil ){
            dateStr = [format stringFromDate:sendDateTime];
        }else{
            dateStr =  [format stringFromDate:[NSDate date]];
        }
        taskObj.toBeCheked = @"1";
        taskObj.taskStatus = @"0";
        taskObj.taskType = [segmentTaskType titleForSegmentAtIndex:segmentTaskType.selectedSegmentIndex ];
        taskObj.repeatInterval = sendInterval;
        taskObj.priority = [segmentTaskPriority titleForSegmentAtIndex:segmentTaskPriority.selectedSegmentIndex] ;
        taskObj.alertTone = sendTone ;
        taskObj.taskDateTime = [format dateFromString:dateStr];
        taskObj.taskDescription = textViewDescription.text ;
        taskObj.email = sendEmail ;
        taskObj.note = sendNoteText;
        NSTimeZone *tzone  = [NSTimeZone defaultTimeZone];
        NSString *zone = [tzone name];
        taskObj.taskTimeZone = zone;
        
        
        if (task != nil) {
            taskObj.taskId = task.taskId;
            taskObj.syncId = task.syncId;
            taskObj.syncStatus = textSyncStatus_edited;
            
            [DBConnect deleteTaskEmails:taskObj];
            
            for (int i = 0; i < [sendSelectedEmails count]; i++){
                TaskEmail *tEmail = [[TaskEmail alloc]init];
                tEmail.email = [sendSelectedEmails objectAtIndex:i];
                tEmail.taskId = taskObj.taskId;
                [DBConnect insertNewTaskEmail:tEmail];
                [tEmail release];
                
            }
            
            [sendSelectedEmails removeAllObjects];
            
            [DBConnect updateTask:taskObj];
            
            [taskObj removeNotification];
            [taskObj setNotification];
            self.title =@"Add Task";
            if (isPushed) {
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                self.tabBarController.selectedIndex = 0;
            }
            
        }else{
            
            taskObj.taskId = [DBConnect insertNewTask:taskObj];
            [taskObj setNotification];
           
            for (int i = 0; i < [sendSelectedEmails count]; i++){
                TaskEmail *tEmail = [[TaskEmail alloc]init];
                tEmail.email = [sendSelectedEmails objectAtIndex:i];
                tEmail.taskId = taskObj.taskId;
                [DBConnect insertNewTaskEmail:tEmail];
               [tEmail release];
                
            }
            
            [sendSelectedEmails removeAllObjects];
            
            self.tabBarController.selectedIndex = 0;
            Sync *sync= [[Sync alloc]init];
            [sync syncStart];
            
            [sync release];
            
        }
        
        [self cancel];
        
        [taskObj release];
    }
   
    
}


#pragma mark change task atype

-(IBAction)changeTaskType:(id)sender{
    
    if ( task!= nil) {
         task.taskType = [segmentTaskType titleForSegmentAtIndex:segmentTaskType.selectedSegmentIndex ];
    }
    

}



#pragma mark change task

-(IBAction)changeTaskPriority:(id)sender{
    
    if ( task!= nil) {
        task.priority = [segmentTaskPriority titleForSegmentAtIndex:segmentTaskPriority.selectedSegmentIndex ];
    }
    
    
}

#pragma mark Delete Task 

- (IBAction)deleteTask:(id)sender{

    //[DBConnect deleteTask:task];
    
    
    [task removeNotification];
    
    task.deleteStatus = @"1";
    task.syncStatus = textSyncStatus_deleted;
    //[DBConnect deleteTask:taskDel];
    [DBConnect updateTask:task];
    [self cancel];
    if (isPushed) {
        [self.navigationController popViewControllerAnimated:YES];   
    }else {
        [self dismissModalViewControllerAnimated:YES];
    }
    isNotificationTriggered = NO;
    
    
}
- (IBAction)hideKeyboard:(id)sender{
     [textViewDescription resignFirstResponder];

}

#pragma mark Set isNotificationTriggered

- (void) setIsNotificationTriggered:(BOOL)status{
        
    isNotificationTriggered  =  status;

}


#pragma mark  Get dateTime
- (void) setPickedDateTime:(NSString *)pickedDateTime
{
    self.sendDateTime =[ format dateFromString:pickedDateTime];
    self.task.taskDateTime = sendDateTime;
    [dataEntryTable reloadData];
    
}



#pragma mark Get interval
- (void) setPickedInterval:(NSString *)pickedInterval
{   if(task != nil){
        task.repeatInterval = pickedInterval;
    }else {
        sendInterval = pickedInterval;
    }
        [dataEntryTable reloadData];
    
}

#pragma mark Get Tone
- (void) setPickedTone:(NSString *)pickedTone{
    
    if (task != nil){
        task.alertTone = pickedTone;
    }else {
        sendTone = pickedTone;
    }    
    [dataEntryTable reloadData];
    
}

#pragma mark Get Email

- (void) setEmail:(NSString *)pickedEmail
{
 
   // self.labelEmail.text = pickedEmail;
 
    if (task != nil){
        task.email = pickedEmail;
    }else {
        sendEmail = pickedEmail;
    }
    
    [dataEntryTable reloadData];
    
}


#pragma mark Get Selected Emails

- (void) setSelectedEmails:(NSMutableArray *)pickedSelectedEmails{

    sendSelectedEmails = pickedSelectedEmails;
  
   
}

#pragma mark Get Note

- (void)setNote:(NSString *)pickedNoteText{
   
    
    self.labelNote.text = pickedNoteText;
    
    if (task != nil){
        task.note = pickedNoteText;
    }else{
        sendNoteText = pickedNoteText;
    }
    
    [dataEntryTable reloadData];
}


#pragma mark

-(void)cancel{
    
  
    [sendSelectedEmails removeAllObjects];
    textViewDescription.text = @"";
    segmentTaskType.selectedSegmentIndex = 0;
    segmentTaskPriority.selectedSegmentIndex = 0;
    sendDateTime = nil;
    sendTone = taskAlertToneText_Default;
    sendInterval = taskRptIntv_none; 
    task = nil;
    sendEmail = @"";
    sendNoteText = @"";
    [dataEntryTable reloadData];
    
}


-(IBAction)clearData:(id)sender{
    
    [self cancel];

}


#pragma mark textView delegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    task.taskDescription = textView.text;
    
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark textField delegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.textViewDescription) {
        [textField resignFirstResponder];
    } else if (textField == self.textEmail ) {
        [textField resignFirstResponder];
    }
    
    
    
    return YES;
}

#pragma mark UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // if(indexPath.section == 0 && indexPath.row == 0){
    //return 70.0;
    //}else{
    return 44.0;
    //}
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [textViewDescription resignFirstResponder];
    
    
    
    if(indexPath.section == 0 && indexPath.row == 4 && !isNotificationTriggered ){
        
        TonePickViewController *controller = [[TonePickViewController alloc] init];
        [controller setDelegate:self];
        
        if(sendTone != nil || task == nil ){
            controller.pickedTone = sendTone;
        }else {
            controller.pickedTone = task.alertTone;
        }
        
        controller.hidesBottomBarWhenPushed = YES;
        [[self navigationController] pushViewController:controller animated:YES];
        [controller release];
        
    }
    
    if(indexPath.section == 0 && indexPath.row == 5 && !isNotificationTriggered){
        
        RptIntervalViewController *rptIntervalcontroller = [[RptIntervalViewController alloc] init];
        [rptIntervalcontroller setDelegate:self];
        
        if(sendInterval != nil || task == nil){
            rptIntervalcontroller.pickedInterval = sendInterval;
        }else {
            rptIntervalcontroller.pickedInterval = task.repeatInterval;
        }
        
        rptIntervalcontroller.hidesBottomBarWhenPushed = YES;
        [[self navigationController] pushViewController:rptIntervalcontroller animated:YES];
        
        [rptIntervalcontroller release];
        
    }else if(indexPath.section == 0 && indexPath.row == 6 ){
        tempSelectedEmails = [[NSMutableArray alloc]init];
        EmailViewController *emailViewController = [[EmailViewController alloc]init];
        [emailViewController setDelegate:self];
        
        //NSMutableArray *emails = [[NSMutableArray alloc] init];
        
        if(!([sendSelectedEmails count] == 0) || task == nil){
            emailViewController.pickedEmail = sendEmail ;
            
            emailViewController.selectedEmails = sendSelectedEmails;
        }else {
            
            emailViewController.pickedEmail = task.email;
            emails = [DBConnect getAllTaskEmails:task];
            [emailViewController.selectedEmails removeAllObjects];
            
            for (int i = 0 ; i < [emails count]; i++) {
                
                TaskEmail *tem = [emails objectAtIndex:i];
                [tempSelectedEmails addObject:tem.email];
            }
                     
            emailViewController.selectedEmails = tempSelectedEmails;
            
        }
                
        
        emailViewController.hidesBottomBarWhenPushed = YES;
        [[self navigationController] pushViewController:emailViewController animated:YES];
        
        [emailViewController release];
        
        
        
    }else if(indexPath.section == 0 && indexPath.row == 7 ){
        
        NoteViewController *noteViewController = [[NoteViewController alloc]init];
        [noteViewController setDelegate:self];
        
        if(self.sendNoteText != nil || task == nil){
           noteViewController.pickedNoteText = self.sendNoteText ;
        }else {
           noteViewController.pickedNoteText = task.note;
       }
        
        noteViewController.hidesBottomBarWhenPushed = YES;
        [[self navigationController] pushViewController:noteViewController animated:YES];
        
        [noteViewController release];
        
    }else if(indexPath.section == 0 && indexPath.row == 1 && !isNotificationTriggered){
        
        DatePickViewController *controller = [[DatePickViewController alloc] init];
        [controller setDelegate:self];
        
        if(sendDateTime != nil){
            controller.pickedDateTime = sendDateTime;
        }
        controller.hidesBottomBarWhenPushed = YES;
        [[self navigationController] pushViewController:controller animated:YES];
        [controller release];
        
    }else{
        return ;
    }
    
    
}


#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0){
       if(task != nil){
           return 9;
       }else{
           return 8;
       }
    }else if (section == 1){
        return 1;
    }else {
        return 1;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
       
    NSDate *nowDate = [NSDate date];   
    
    if(indexPath.section == 0 && indexPath.row == 0){
        
        return cellDescription;
        
    }else if(indexPath.section == 0 && indexPath.row == 1){
        
        if (sendDateTime != nil) {dateString = [formatRelativeDate stringFromDate:sendDateTime];
        }else{dateString = [formatRelativeDate stringFromDate:nowDate];}
        labelDueDate.text = dateString;
        
        return cellDueDate;
    
    }else if(indexPath.section == 0 && indexPath.row == 2){
        return cellTaskType;
    }else if(indexPath.section == 0 && indexPath.row == 3){
        return cellPriority;
    }else if(indexPath.section == 0 && indexPath.row == 4){
        
        labelTone.text = sendTone;
        return cellAlertTone;  
        
    }else if(indexPath.section == 0 && indexPath.row == 5){
        labelRptInterval.text = sendInterval;
        return cellRepeatInterval;
       
        
    }else if(indexPath.section == 0 && indexPath.row == 6){
       // self.labelEmail.text = sendEmail;
       return cellEmail;
    
    }else if(indexPath.section == 0 && indexPath.row == 7){
        self.labelNote.text = sendNoteText;
    return cellNote;
    
    }else if(indexPath.section == 0 && indexPath.row == 8){
        if([task.taskStatus isEqualToString:@"1"] || ![task.repeatInterval isEqualToString:taskRptIntv_none]){
            return cellDeleteButton;
        }else {
            return cellDoneDeleteButton;
        }    
    }else {
        return nil;
    }
    
}      

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   
   // if(task != nil){return 2;
   /// }else{
        return 1;
    //}
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
           self.title = NSLocalizedString(@"Add Task", @"First");
           self.tabBarItem.image = [UIImage imageNamed:@"pen.png"];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
     [super didReceiveMemoryWarning];
}

#pragma mark set task detatils to view

- (void)setTaskDetailToView{

    [dataEntryTable reloadData];
        
    
    format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMM dd, yyyy HH:mm"];
    
    formatRelativeDate = [[NSDateFormatter alloc] init];
    [formatRelativeDate setTimeStyle:NSDateFormatterShortStyle];
    [formatRelativeDate setDateStyle:NSDateFormatterMediumStyle];
    [formatRelativeDate setDoesRelativeDateFormatting:YES];
      
    if (task != nil) {
        
        if (!isNotificationTriggered) {
            self.title = NSLocalizedString(@"Edit", @"First");
        }else {
            self.title = NSLocalizedString(@"Task", @"First");

        }
           
        self.tabBarController.tabBar.hidden = YES;
        
        textViewDescription.text = task.taskDescription;
        
        
        
        if (isNotificationTriggered) {
            labelTaskType.text = task.taskType;
        }else {
            if ([task.taskType isEqualToString:taskTy_call]) {
                segmentTaskType.selectedSegmentIndex = 0; 
            }else if ([task.taskType isEqualToString:taskTy_reminder]) {
                segmentTaskType.selectedSegmentIndex = 1; 
            }else if ([task.taskType isEqualToString:taskTy_meeting]) {
                segmentTaskType.selectedSegmentIndex = 2; 
            }  
        }
        
        
        if (isNotificationTriggered) {
            labelPriority.text = task.priority;
        }else {
            if([task.priority isEqualToString:taskPr_low]){
                segmentTaskPriority.selectedSegmentIndex = 0;
            }else if([task.priority isEqualToString:taskPr_medium]){
                segmentTaskPriority.selectedSegmentIndex = 1;
            }else if([task.priority isEqualToString:taskPr_high]){
                segmentTaskPriority.selectedSegmentIndex = 2;    
            }
        }
        
        sendDateTime = task.taskDateTime;
        sendTone = task.alertTone;
        sendInterval = task.repeatInterval;
        sendEmail = task.email;
        sendNoteText = task.note;
        
        emails = [DBConnect getAllTaskEmails:task];
        //sendSelectedEmails = emails;
    }
    
    if (sendInterval == nil) {
        sendInterval = taskRptIntv_none;
    }
    if (sendTone == nil) {
        sendTone = @"Default";            
    }  
    
    
   

}

#pragma mark - View lifecycle

- (void)viewDidAppear:(BOOL)animated{

}

- (void)viewWillAppear:(BOOL)animated{ 
       
    if( !isNotificationTriggered ){
        if(task == nil){
            [textViewDescription becomeFirstResponder];
        }
    
//        //if(task != nil){
//            NSMutableArray *emails = [[NSMutableArray alloc] init];
//            emails = [DBConnect getAllTaskEmails:task];
//            TaskEmail *tem = [emails objectAtIndex:0];
//            
//            EmailViewController = 
       // }
         
        
        UISegmentedControl *button = [[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Save", nil]] autorelease];
        button.momentary = YES;
        button.segmentedControlStyle = UISegmentedControlStyleBar;
        button.tintColor = UIColorFromRGB(0x0d9c23);
        UIBarButtonItem *addButton = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
              
        [button addTarget:self
                    action:@selector(saveTask:)
          forControlEvents:UIControlEventValueChanged];
        self.navigationItem.rightBarButtonItem = addButton;
        
        //[addButton release];
       
        if(!isPushed){
            UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStyleDone target:self action:@selector(clearData:)];
            self.navigationItem.leftBarButtonItem = cancelButton;
            
            [cancelButton release];
     
         }
        
        [self enableMakeTaskView];
        
    }else {
        
        NSLog(@"triggered");
        
        UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc] initWithTitle:@"Dismiss" style:UIBarButtonItemStyleDone target:self action:@selector(dismissView:)];
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = dismissButton;
        [dismissButton release];
        
        [self disableMakeTaskView];        
        
    }
    

    
    [self setTaskDetailToView];
    
    self.navigationController.navigationBarHidden = NO;
}




- (void)viewWillDisappear:(BOOL)animated{
   
} 



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    textEmail.delegate = self;
    
    
    sendSelectedEmails = [[NSMutableArray alloc ]init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
       
    if (self.navigationController.view.frame.size.height > 500) {
        CGRect viewFrame = self.view.frame;
        viewFrame.size.height = 499;
        self.view.frame = viewFrame;
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgBlackWood-568h@2x.png"]]];
    }else{
        CGRect viewFrame = self.view.frame;
        viewFrame.size.height = 411;
        self.view.frame = viewFrame;
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgBlackWood.jpg"]]];
        
    }

    
    [cellDescription setSelectionStyle:UITableViewCellSelectionStyleNone]; 
   //cellDescription.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"textent.png"]] autorelease];
    cellDescription.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"plainCell.png"]] autorelease];
    [dataEntryTable setSeparatorColor:[UIColor clearColor]];
    
    
    [cellTaskType setSelectionStyle:UITableViewCellSelectionStyleNone]; 
    [cellTaskType setBackgroundColor:[UIColor clearColor]];
    cellTaskType.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellbg.png"]] autorelease];
    
    
    [cellAlertTone setSelectionStyle:UITableViewCellSelectionStyleNone]; 
    [cellAlertTone setBackgroundColor:[UIColor clearColor]];
    cellAlertTone.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellbg.png"]] autorelease];
    
    
    [cellDueDate setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cellDueDate setBackgroundColor:[UIColor clearColor]];
    cellDueDate.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellbg.png"]] autorelease];
    
    
    [cellPriority setSelectionStyle:UITableViewCellSelectionStyleNone];   
    [cellPriority setBackgroundColor:[UIColor clearColor]];
    cellPriority.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellbg.png"]] autorelease];
    
    
    [cellRepeatInterval setSelectionStyle:UITableViewCellSelectionStyleNone]; 
    [cellRepeatInterval setBackgroundColor:[UIColor clearColor]];
    cellRepeatInterval.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellbg.png"]] autorelease];
    
    [cellEmail setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cellEmail setBackgroundColor:[UIColor clearColor]];
    cellEmail.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellbg.png"]] autorelease];
    
    [cellNote setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cellNote setBackgroundColor:[UIColor clearColor]];
    cellNote.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellbg.png"]] autorelease];
    
    
    
    [cellDeleteButton setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cellDeleteButton setBackgroundColor:[UIColor clearColor]];
     cellDeleteButton.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clearCell.png"]] autorelease];
    
    [cellDoneDeleteButton setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cellDoneDeleteButton setBackgroundColor:[UIColor clearColor]];
    cellDoneDeleteButton.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clearCell.png"]] autorelease];
    
    [cellAlertTone setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cellRepeatInterval setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cellDueDate setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cellEmail setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cellNote setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
}

- (void)viewDidUnload
{
    [self setLabelEmail:nil];
    [super viewDidUnload];
   
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
     return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




@end
