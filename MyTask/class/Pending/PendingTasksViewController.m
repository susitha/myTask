//
//  SecondViewController.m
//  MyTask
//
//  Created by Samir Husain on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PendingTasksViewController.h"
#import "Commons.h"
#import "DBConnect.h"
#import "Task.h"
#import "Sync.h"


@implementation PendingTasksViewController

-(void)refreshTable{

    [tasks removeAllObjects];
    NSMutableArray *tempArray = [DBConnect getAllpendingTasks];
    for (Task *task in tempArray) {
        [tasks addObject:task];
    }
    [taskTable reloadData];  
    
        
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Pending", @"Second");
        self.tabBarItem.image = [UIImage imageNamed:@"bell.png"];
    }
    return self;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Task *taskDel = [tasks objectAtIndex:indexPath.row];
        taskDel.deleteStatus = @"1";
        taskDel.syncStatus = textSyncStatus_deleted;
        //[DBConnect deleteTask:taskDel];
        [DBConnect updateTask:taskDel];
        [taskDel removeNotification];
        [tasks removeObjectAtIndex:indexPath.row];
    }    
    [taskTable reloadData];
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{    
       
    Task *taskB = [tasks objectAtIndex:indexPath.row];  
    MakeTaskViewController *controller = [[MakeTaskViewController alloc] init];
    controller.task = taskB;
    taskB.toBeCheked = @"0";
    [DBConnect updateTask:taskB];
    [controller setIsPushed:YES];
    controller.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem:backButton]; 
    [[self navigationController] pushViewController:controller animated:YES];
    
    [backButton release];
    [controller release];
   
    
    
     
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tasks count];
}

- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath{
    
    return 51.0;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{ 
    Task *taskB = [tasks objectAtIndex:indexPath.row]; 
    CustomTblCell *tCell = [[[CustomTblCell alloc]initWithPriority:taskB.priority status:taskB.taskStatus repeatInterval:taskB.repeatInterval]autorelease];
    [tCell setTask:taskB];    
    [tCell setPtaskVeiwControler:self];
    [tCell setRow:indexPath.row];
    return tCell; 
     
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
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

    
    tasks =  [[NSMutableArray alloc]init]; 
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (void)viewWillAppear:(BOOL)animated
{        
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
     return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)deleteTableViewCell:(NSIndexPath *)IPath{
    NSMutableArray *array = [NSMutableArray arrayWithObjects:IPath, nil];
    [tasks removeObjectAtIndex:IPath.row];
    [taskTable beginUpdates];
    [taskTable deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationLeft];
    [taskTable endUpdates];
}

- (void)dealloc{
    [super dealloc];
    [tasks release];
    tasks = nil;
}

@end
