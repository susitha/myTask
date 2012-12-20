//
//  TonePickViewController.m
//  MyTask
//
//  Created by Susitha Janaka on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TonePickViewController.h"
#import "Commons.h"

@implementation TonePickViewController


@synthesize pickedTone;
@synthesize delegate;
#pragma mark UITableViewDataSource

- (void)playTone:(NSString *)tone{

    
    [audioPlayer stop];
    
    NSString *selTone;
    if ([tone isEqual:taskAlertToneText_Chimes]) {
        selTone = taskAlertToneText_Chimes;
    }
    else if ([tone isEqual:taskAlertToneText_Blipper]) {
        selTone = taskAlertToneText_Blipper;
    }
    else if ([tone isEqual:taskAlertToneText_Berring]) {
        selTone = taskAlertToneText_Berring;
    }
    else if ([tone isEqual:taskAlertToneText_Epsilon]) {
        selTone = taskAlertToneText_Epsilon;
    }
    else {
        selTone = taskAlertTone_Default;
    } 
    
    
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                         pathForResource:selTone
                                         ofType:@"aif"]];
    
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc]
                   initWithContentsOfURL:url
                   error:&error];
    if (error)
    {
        NSLog(@"Error in audioPlayer: %@", 
              [error localizedDescription]);
    } else {
        audioPlayer.delegate = self;
        [audioPlayer prepareToPlay];
    }
    
    
    [audioPlayer play];
    [selTone release];
    [error release];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [tones count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [[[UITableViewCell alloc]init ]autorelease];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.textLabel.text = [tones objectAtIndex:indexPath.row];
    
    if ([selectedTone isEqualToString:[tones objectAtIndex:indexPath.row]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
  
}

- (void)viewWillAppear:(BOOL)animated{
      
    selectedTone = pickedTone;
}

#pragma mark UITableViewDelegate


-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{  
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 5.0) {
        
        if(indexPath.row ==0){
            cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableCellTop.png"]] autorelease];
        }else if (indexPath.row == [tones count]-1) {
            cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableCellBottom.png"]] autorelease];
        }    
    }    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
   
    [self playTone:[tones objectAtIndex:indexPath.row]];
    
    selectedTone = [tones objectAtIndex:indexPath.row];
     
    [toneTable reloadData];
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

    
    tones = [[NSMutableArray arrayWithObjects:taskAlertToneText_Default,taskAlertToneText_Epsilon,taskAlertToneText_Chimes,taskAlertToneText_Blipper,taskAlertToneText_Berring, nil] retain];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)viewWillDisappear:(BOOL)animated{
    
     [[self delegate] setPickedTone:selectedTone];

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)dealloc{
    
    [super dealloc];
    [audioPlayer release];
} 


@end
