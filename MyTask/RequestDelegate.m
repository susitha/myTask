//
//  RequestDelegate.m
//  MyTask
//
//  Created by Samir on 11/3/12.
//
//

#import "RequestDelegate.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "DBConnect.h"
#import "TaskEmail.h"

@implementation RequestDelegate 

static RequestDelegate *sharedInstance = nil;

// Get the shared instance and create it if necessary.
+ (RequestDelegate *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[RequestDelegate alloc] init];
    } 
    return sharedInstance;
}

-(void)insertEmailNotificationWithTask:(Task*)task{
    
    UIDevice *device = [UIDevice currentDevice];
    NSString *uniqueIdentifier = [device uniqueIdentifier];
    
    NSTimeZone *tzone  = [NSTimeZone defaultTimeZone];
    //NSDate *now = [[NSDate alloc]init] ;
    NSTimeInterval timeInt = [task.taskDateTime timeIntervalSince1970 ];
    NSNumber *timeStamp=[NSNumber numberWithInt:timeInt];
    
    NSString *zone = [tzone name];
    NSURL *url = [NSURL URLWithString:remoteWebServerURL];
    
    NSMutableArray *emails = [DBConnect getAllTaskEmails:task];
    NSString *emailString = @"";
    TaskEmail *tem = [[[TaskEmail alloc]init]autorelease] ;
    if([emails count]>0){
        tem = emails[0];
        emailString = tem.email;
    
        for (int i = 1; i < [emails count]; i++) {
            tem = emails[i];
            NSString *str = tem.email;
            emailString = [emailString stringByAppendingFormat:@" , %@",str];
        }
    }
    
    
   //NSLog(@" email string %@", emailString);
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
  
    if(task.syncId > 0){
       
        NSLog(@"sync id %@", task.syncId);
        [request setPostValue:task.syncId forKey:@"task_syncId"];
    }
    
    
    [request setPostValue:[NSString stringWithFormat:@"%@",timeStamp] forKey:@"task_time_stamp"];
    [request setPostValue:[NSString stringWithFormat:@"%@",zone] forKey:@"task_time_zone"];
    [request setPostValue:[NSString stringWithFormat:@"%@",task.priority] forKey:@"task_priority"];
    [request setPostValue:[NSString stringWithFormat:@"%@",task.taskType] forKey:@"task_type"];
    [request setPostValue:[NSString stringWithFormat:@"%@",task.email] forKey:@"task_email"];
    [request setPostValue:[NSString stringWithFormat:@"%@",task.note] forKey:@"task_note"];
    [request setPostValue:[NSString stringWithFormat:@"%@",task.taskId] forKey:@"task_id"];
    [request setPostValue:[NSString stringWithFormat:@"%@",task.repeatInterval] forKey:@"repeat_interval"];
    [request setPostValue:[NSString stringWithFormat:@"%@",task.taskDescription] forKey:@"task_description"];
    [request setPostValue:[NSString stringWithFormat:@"%@",task.taskStatus] forKey:@"task_status"];
    [request setPostValue:[NSString stringWithFormat:@"%@",uniqueIdentifier] forKey:@"device_id"];
    [request setPostValue:[NSString stringWithFormat:@"%@",task.deleteStatus] forKey:@"task_delete_status"];
    if([emails count]>0){
        [request setPostValue:[NSString stringWithFormat:@"%@",emailString] forKey:@"task_emails"];
    }
    [request setDelegate:self];
    [request startAsynchronous];
    
  
   
    
}


- (id)init
{
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}


-(void)dealloc
{
    
    [super dealloc];
}

- (void)requestStarted:(ASIHTTPRequest *)request{
    
}
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders{
    

    
}
- (void)request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL{
    
}
 
- (void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"===================DidFail==================");
    
}
- (void)requestRedirected:(ASIHTTPRequest *)request{
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSDictionary *responseDict = [responseString JSONValue];
    
    NSLog(@"Response string %@",request.responseString);
    NSLog(@"Response dict %@",responseDict);

    if (request.responseStatusCode == 200) { 
        Task *task =  [DBConnect getTask:[[responseDict objectForKey:@"task_id"] integerValue]] ; 
        if([[responseDict objectForKey:@"db"] isEqualToString:@"INSERT"]){
            task.syncStatus =textSyncStatus_synced;
            task.syncId = [NSString stringWithFormat:@"%@",[responseDict objectForKey:@"insert_id"]]; 
        }else {
            task.syncStatus = textSyncStatus_synced;
            NSLog(@"Task exist");
        } 
        [DBConnect updateTask:task]; 
    } else {
        NSLog( @"Unexpected error");
    }

     NSLog(@"===================DidFinish==================");
}

@end
