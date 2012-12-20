//
//  TaskEmail.m
//  MyTask
//
//  Created by Susitha on 12/10/12.
//
//

#import "TaskEmail.h"

@implementation TaskEmail

@synthesize taskId,email,emailId;

- (id)init{
    self = [super init];
    if (self) {
        emailId = @"";
        email = @"";
        taskId = @"";
    }
    return self;
}


- (void)dealloc{
    
    email = nil;
    emailId = nil;
    taskId = nil;
    [super dealloc];
}



@end
