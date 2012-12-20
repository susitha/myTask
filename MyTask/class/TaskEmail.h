//
//  TaskEmail.h
//  MyTask
//
//  Created by Susitha on 12/10/12.
//
//

#import <Foundation/Foundation.h>

@interface TaskEmail : NSObject{
    NSString *emailId;
    NSString *email;
    NSString *taskId;
}

@property (nonatomic,retain) NSString *emailId;
@property (nonatomic,retain) NSString *email;
@property (nonatomic,retain) NSString *taskId;

@end
