//
//  RequestDelegate.h
//  MyTask
//
//  Created by Samir on 11/3/12.
//
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "Task.h"


@interface RequestDelegate : NSObject<ASIHTTPRequestDelegate>

@property (nonatomic,retain) Task *task;  
+ (RequestDelegate *)sharedInstance ;
-(void)insertEmailNotificationWithTask:(Task*)task;

@end
