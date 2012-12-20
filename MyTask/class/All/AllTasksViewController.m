//
//  FirstViewController.m
//  MyTask
//
//  Created by Samir Husain on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AllTasksViewController.h"
#import "Commons.h"
#import "DBConnect.h"
#import "MakeTaskViewController.h"

@implementation AllTasksViewController


-(void)refreshTable{
    [tasks removeAllObjects];
    NSMutableArray *tempArray = [DBConnect getAllTasks];
    for (Task *task in tempArray) {
        [tasks addObject:task];
    } 
    [taskTable reloadData];   
    if ([tempArray count] <= 0) { 
        [self.view bringSubviewToFront:helpImage];
        helpImage.hidden = NO;
    }else {
        helpImage.hidden = YES;
        [self.view sendSubviewToBack:helpImage];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [tasks count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{ 
    Task *taskB = [tasks objectAtIndex:indexPath.row]; 
    CustomTblCell *tCell = [[[CustomTblCell alloc]initWithPriority:taskB.priority status:taskB.taskStatus repeatInterval:taskB.repeatInterval]autorelease];
    [tCell setTask:taskB]; 
    return tCell; 
}

#pragma mark - UITableViewDelegate 

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{      
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Task *taskDel = [tasks objectAtIndex:indexPath.row];
        taskDel.deleteStatus = @"1";
        taskDel.syncStatus = textSyncStatus_deleted;
        [DBConnect updateTask:taskDel];
        //[DBConnect deleteTask:taskDel];
        [taskDel removeNotification];
        [tasks removeObjectAtIndex:indexPath.row];
    }    
    [self refreshTable]; 
}

    

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
            
    if (indexPath.row == [tasks count]) {
        return  UITableViewCellEditingStyleInsert;
    }
     
    return UITableViewCellEditingStyleDelete;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{    
  
    Task *taskB = [tasks objectAtIndex:indexPath.row]; 
    taskId = [taskB taskId]; 
    MakeTaskViewController *controller = [[MakeTaskViewController alloc] init]; 
    controller.task = taskB; 
    [controller setIsPushed:YES]; 
    controller.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem:backButton];  
    [[self navigationController] pushViewController:controller animated:YES]; 
    [backButton release];
    [controller release];
    
}

#pragma mark -  
- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath{

    return 51.0;

}

#pragma mark -

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"All", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"clock.png"];
        
    }
    return self;
}
							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}

- (void)dealloc{
    [super dealloc];
    [tasks release];
    tasks = nil;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad]; 
    
    [[self navigationItem] setTitle:@"GroupTask"];
    [self.tabBarItem setTitle:@"All"];
    
    taskTable.allowsSelectionDuringEditing = YES;
    
    NSLog(@"screenSize %f",[[UIScreen mainScreen] bounds].size.height);
    NSLog(@"before viewHight %f",self.view.frame.size.height);
    if (self.navigationController.view.frame.size.height > 500) {
        CGRect viewFrame = self.view.frame;
        viewFrame.size.height = 499;
        self.view.frame = viewFrame;
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgBlackWood-568h@2x.png"]]];
    }else{
        CGRect viewFrame = self.view.frame;
        viewFrame.size.height = 411;
        self.view.frame = viewFrame;
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgBlackWood.jpg"]]];
    
    }
    NSLog(@"after viewHight %f",self.view.frame.size.height); 

    tasks =  [[NSMutableArray alloc]init];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated]; 
    self.tabBarController.tabBar.hidden = NO; 
    self.navigationController.navigationBarHidden = NO;
    [DBConnect UpdateFireDateNext:YES];
        
    [self refreshTable];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

#pragma mark -
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
     return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


@end
