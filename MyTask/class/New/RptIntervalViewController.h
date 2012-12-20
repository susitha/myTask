//
//  RptIntervalViewController.h
//  MyTask
//
//  Created by Samir Husain on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Commons.h"

@protocol PassRptInterval <NSObject>

@required
- (void) setPickedInterval:(NSString *)pickedInterval;
@end



@interface RptIntervalViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *rptIntervalTable;
    NSMutableArray *intervalArray;
    NSString *selectedInterval;
    id <PassRptInterval> delegate;

}

@property (copy) NSString *pickedInterval;
@property (retain) id delegate;

@end
