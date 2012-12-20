//
//  SecondViewController.h
//  MyTask
//
//  Created by Susitha Janaka on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "Task.h"
#import "CustomTblCell.h"
#import "MakeTaskViewController.h"

@interface PendingTasksViewController : UIViewController{
    NSString *databasePath; 
    NSMutableArray *tasks;
    NSMutableArray *tt;
    IBOutlet UITableView *taskTable;
    IBOutlet UIImageView *helpImage;
}


- (void)refreshTable;
- (void)deleteTableViewCell:(NSIndexPath *)IPath;
@end
