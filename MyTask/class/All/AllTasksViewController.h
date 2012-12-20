//
//  FirstViewController.h
//  MyTask
//
//  Created by Samir Husain on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "Task.h"
#import "CustomTblCell.h"

@interface AllTasksViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *tasks;
    IBOutlet UITableView *taskTable;
    NSString *taskId;
    IBOutlet UIImageView *helpImage;
}
-(void)refreshTable;

@end
