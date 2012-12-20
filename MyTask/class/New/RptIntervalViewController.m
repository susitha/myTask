//
//  RptIntervalViewController.m
//  MyTask
//
//  Created by Samir Husain on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RptIntervalViewController.h"

@implementation RptIntervalViewController

@synthesize delegate;
@synthesize pickedInterval;

#pragma mark UITableViewDataSource 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}


-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{  
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 5.0) {
        
        if(indexPath.row ==0){
            cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableCellTop.png"]] autorelease];
        }else if (indexPath.row == [intervalArray count]-1) {
            cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableCellBottom.png"]] autorelease];
        }    
    }    
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        }
    
    cell.textLabel.text = [intervalArray objectAtIndex:indexPath.row];
    
    if ([selectedInterval isEqualToString:[intervalArray objectAtIndex:indexPath.row]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

#pragma  mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    selectedInterval = [intervalArray objectAtIndex:indexPath.row]; 
    [rptIntervalTable reloadData];
    
}

#pragma mark 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
     [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
     
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

     
    intervalArray  = [[NSMutableArray arrayWithObjects:taskRptIntv_none,taskRptIntv_hourly,taskRptIntv_daily,taskRptIntv_weekly,taskRptIntv_monthly,taskRptIntv_yearly, nil]retain ]; 
    
           
}

- (void)viewWillAppear:(BOOL)animated{
    selectedInterval = pickedInterval;
    [rptIntervalTable reloadData];
}

- (void)viewWillDisappear:(BOOL)animated{

    [[self delegate] setPickedInterval:selectedInterval];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
   
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
      return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{    
  
    [super dealloc];
}


@end
