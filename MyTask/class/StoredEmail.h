//
//  TaskEmail.h
//  MyTask
//
//  Created by Susitha on 11/26/12.
//
//

#import <Foundation/Foundation.h>

@interface StoredEmail : NSObject{
    NSString *emailId;
    NSString *storedEmail;
    
}


@property (nonatomic,retain) NSString *emailId;
@property (nonatomic,retain) NSString *storedEmail;

@end
