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
    NSDate *now = [[NSDate alloc]init] ;
    NSTimeInterval timeInt = [now timeIntervalSince1970 ];
    NSNumber *timeStamp=[NSNumber numberWithInt:timeInt];
    
    NSString *zone = [tzone name];
    NSURL *url = [NSURL URLWithString:remoteWebServerURL];
    
    NSLog(@"Task %@",task);
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[NSString stringWithFormat:@"%@", timeStamp] forKey:@"task_time_stamp"];
    [request setPostValue:zone forKey:@"task_time_zone"];
    [request setPostValue:[NSString stringWithFormat:@"%@",task.priority] forKey:@"task_priority"];
    [request setPostValue:[NSString stringWithFormat:@"%@",task.taskType] forKey:@"task_type"];
    [request setPostValue:[NSString stringWithFormat:@"%@",task.email] forKey:@"task_email"];
    [request setPostValue:[NSString stringWithFormat:@"%@",task.taskId] forKey:@"task_id"];
    [request setPostValue:[NSString stringWithFormat:@"%@",task.repeatInterval] forKey:@"repeat_interval"];
    [request setPostValue:task.taskDescription forKey:@"task_description"];
    [request setPostValue:uniqueIdentifier forKey:@"device_id"];
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
    
}
- (void)requestRedirected:(ASIHTTPRequest *)request{
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSDictionary *responseDict = [responseString JSONValue];
    
    NSLog(@"Response string %@",request.responseString);
    
    if (request.responseStatusCode == 400) {
        NSLog(@"Invalid code");
    } else if (request.responseStatusCode == 200) {
        NSLog(@"insert id %@",[responseDict objectForKey:@"insert_id"]);
    } else {
        NSLog( @"Unexpected error");
    }
    
}

@end
