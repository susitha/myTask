//
//  DatePickViewController.h
//  MyTask
//
//  Created by Samir Husain on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PassDateTime <NSObject>
@required
- (void) setPickedDateTime:(NSString *)pickedDateTime;
@end

@interface DatePickViewController : UIViewController
{
    UIDatePicker *datePicker;
    NSDate *dateTime;   
    id <PassDateTime> delegate;
    UITableView *showDateTable;
    
}

@property (nonatomic,retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic,retain) NSDate *dateTime;
@property (nonatomic,retain) IBOutlet UITableView *showDateTable;


@property (copy) NSDate	*pickedDateTime;
@property (retain) id delegate;


- (IBAction)resetDatePicker:(id)sender;
- (IBAction)setChangedDate:(id)sender;

@end





