//
//  TaskEmail.m
//  MyTask
//
//  Created by Susitha on 11/26/12.
//
//

#import "StoredEmail.h"

@implementation StoredEmail


@synthesize emailId,storedEmail;

- (id)init{
    self = [super init];
    if (self) {
        emailId = @"";
        storedEmail= @"";
    }
    return self;
}
    
- (void)dealloc{
 
    storedEmail = nil;
    emailId = nil;
    [super dealloc];
}



@end
