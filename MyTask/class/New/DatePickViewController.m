//
//  DatePickViewController.m
//  MyTask
//
//  Created by Samir Husain on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DatePickViewController.h"
#import "MakeTaskViewController.h"

@implementation DatePickViewController

@synthesize delegate;
@synthesize datePicker,dateTime;
@synthesize showDateTable;

@synthesize pickedDateTime;

#pragma mark TableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[[UITableViewCell alloc]init ]autorelease];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMM dd, yyyy HH:mm"];
    cell.textLabel.text = [format stringFromDate:[datePicker date]] ;
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    
    [format release];
    
    return cell;
    [cell release];
    
}



#pragma mark


- (IBAction)resetDatePicker:(id)sender{
    
    [datePicker setDate:[NSDate date]] ;
    
}



-(IBAction)dateChanged:(id)sender
{
    self.dateTime = [datePicker date];
    
}

-(IBAction)setChangedDate:(id)sender{
    
    
    NSDateFormatter  *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMM dd, yyyy HH:mm"];
    
    
    if ([datePicker date] != nil) {
        [[self delegate] setPickedDateTime: [format stringFromDate:[datePicker date]]];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    [format release];
    
}


- (void) viewWillDisappear:(BOOL) animated
{
    
    
}



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
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Set" style:UIBarButtonItemStyleDone target:self action:@selector(setChangedDate:)];
    
    self.navigationItem.rightBarButtonItem = saveButton;
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

    [datePicker setMinimumDate: [NSDate date] ];
    
    if(pickedDateTime != nil){
        [datePicker setDate:pickedDateTime];
    }else{
        datePicker.date = [[[NSDate alloc]init] autorelease];
    }    
    
    showDateTable.scrollEnabled = NO;
    [saveButton release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
