//
//  ThirdViewController.m
//  MyTask
//
//  Created by Samir Husain on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddTaskViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "Commons.h"

@implementation AddTaskViewController

@synthesize priorityButton;
@synthesize taskDescription;
@synthesize dateTimePicker;
@synthesize prioritySegmentedControl;
@synthesize task;

NSString *priority;

- (void)scheduleNotification {
	
	//[reminderText resignFirstResponder];
	//[[UIApplication sharedApplication] cancelAllLocalNotifications];
    
	Class cls = NSClassFromString(@"UILocalNotification");
	if (cls != nil) {
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MMM dd, yyyy HH:mm"];
        
		UILocalNotification *notif = [[cls alloc] init];
        
        NSString *dateString = [dateFormat stringFromDate:dateTimePicker.date];
        
		notif.fireDate = [dateFormat dateFromString:dateString];
        //notif.fireDate = dateTimePicker.date;
        notif.timeZone = [NSTimeZone defaultTimeZone];
		notif.alertBody = @"You have some pending tasks?";
		notif.alertAction = @"Show me";
		notif.soundName = UILocalNotificationDefaultSoundName;
		notif.applicationIconBadgeNumber = notif.applicationIconBadgeNumber +1 ;
		[notif setRepeatInterval:NSWeekCalendarUnit]; 
		///NSDictionary *userDict = [NSDictionary dictionaryWithObject:textTitle.text forKey:kRemindMeNotificationDataKey];
		
        notif.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",lastTaskId], @"taskID", nil] ;
        //notif.userInfo = userDict;
		
		[[UIApplication sharedApplication] scheduleLocalNotification:notif];
        NSLog(@"%@",notif);
        
  //      sendDateTime = nil; 
        
        
        self.tabBarController.selectedIndex = 2;
        //  [dateFormat release];
		[notif release];
        [dateFormat release];
	}
}


- (IBAction) saveData
{
    
    sqlite3 *database;
    sqlite3_stmt    *statement; 
    
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	databasePath = [documentsDir stringByAppendingPathComponent:dbName];
    
    NSLog(@"DB%@",databasePath);
    
    const char *dbpath = [databasePath UTF8String];
    NSLog(@"Path:%s",dbpath);       
    
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {   
            
                    
            int timeStamp = [dateTimePicker.date timeIntervalSince1970];
            
            
            NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO tasks ( task_description,priority, task_dateTime ) VALUES (\"%@\",\"%@\",\"%d\")", taskDescription.text,priority,timeStamp];
            
            
            NSLog(@"%@",insertSQL);      
            const char *insert_stmt = [insertSQL UTF8String];
            
            [self scheduleNotification];
            
            sqlite3_prepare_v2(database, insert_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {            
                
                int lastInsertId =  sqlite3_last_insert_rowid(database);
                
                lastTaskId = (NSNumber *) lastInsertId;

                         
                NSDateFormatter *format = [[NSDateFormatter alloc] init];
                [format setDateFormat:@"MMM dd, yyyy HH:mm"];
                NSDate *now = [[NSDate alloc] init];
                taskDescription.text = @"";
                priority=@"High";
                
                [priorityButton setTitle: @"High" forState: UIControlStateNormal]; 
                [priorityButton    setBackgroundImage:[UIImage imageNamed:@"btnHigh"] forState:UIControlStateNormal];
                
                [dateTimePicker setDate:[[[NSDate alloc]init]autorelease]] ;
                
                UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"Task Saved" message:@"Task Saved" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                
                
                [alt show];
                [alt release];
                [format release]; 
                [now release];
            } else {
                
                NSLog(@"Failed");
                
            }
            
            
            sqlite3_finalize(statement);
            
            
            sqlite3_close(database);
            
            
            
        }
    
    
   // [self dismissKeyboard];
    
}



-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{   
    
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark change priority

-(IBAction)changePriority:(id)sender{

       
    switch (prioritySegmentedControl.selectedSegmentIndex) {
        case 0:
            priority = @"Low";
            break;
        case 1:
            priority = @"Medium";
            break; 
        case 2:
            priority = @"High";
            break;     
        default:
            break;
    }
    
    NSLog(@"Priority:%@",priority);
    
}
#pragma mark change button color 
-(IBAction)changeButtonColor:(id)sender{
    if (priority == @"Low" ) {
        priority = @"Medium";             
       
        [priorityButton setTitle: @"Medium" forState: UIControlStateNormal];
        [priorityButton    setBackgroundImage:[UIImage imageNamed:@"btnMedium"] forState:UIControlStateNormal];
    }
   else if(priority == @"Medium"){
        priority = @"High"; 
        
        [priorityButton setTitle: @"High" forState: UIControlStateNormal]; 
        [priorityButton    setBackgroundImage:[UIImage imageNamed:@"btnHigh"] forState:UIControlStateNormal];
    
    }
    else if(priority == @"High"){
        priority = @"Low";
       
        [priorityButton setTitle: @"Low" forState: UIControlStateNormal];
        [priorityButton    setBackgroundImage:[UIImage imageNamed:@"btnLow"] forState:UIControlStateNormal];
    }    
}

#pragma mark 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"New", @"Third");
        self.tabBarItem.image = [UIImage imageNamed:@"pen30px"];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{   
    //databaseName = @"MyTaskManagerDB.sql";
    
   [super viewDidLoad];
    //[self.view setBackgroundColor:];
   
       
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgMain.png"]]];
 
    
    priority = @"Low"; 
    
	// Get the path to the documents directory and append the databaseName
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	databasePath = [documentsDir stringByAppendingPathComponent:dbName];
      
   [prioritySegmentedControl setFrame:CGRectMake(20, 102, 280.0, 38.0)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
