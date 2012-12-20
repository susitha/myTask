//
//  NoteViewController.m
//  MyTask
//
//  Created by Susitha on 11/29/12.
//
//

#import "NoteViewController.h"



@implementation NoteViewController


@synthesize textViewNote,delegate,selectedNoteText,pickedNoteText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Add note";
    }
    return self;
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if (textViewNote.textColor == [UIColor whiteColor]) {
        textViewNote.text = @"";
        textViewNote.textColor = [UIColor blackColor];
    }
    
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    if(textViewNote.text.length == 0){
        textViewNote.textColor = [UIColor whiteColor];
        textViewNote.text = @"Enter text here";
        [textViewNote resignFirstResponder];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        //[textView resignFirstResponder];
        if(textViewNote.text.length == 0){
            textViewNote.textColor = [UIColor whiteColor];
            textViewNote.text = @"Enter text here";
            [textViewNote resignFirstResponder];
        }
        if( [textViewNote.text isEqualToString:@"Enter text here"]){
            textViewNote.text= @"";
        }
        [self setNote];
        return NO;
        
    }
   
    return YES;
}


//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    
//   //task.taskDescription = textView.text;
//    
//    if([text isEqualToString:@"\n"])
//    {
//        [textView resignFirstResponder];
//        return NO;
//        
//    }
//    
//    return YES;
//}


- (void)viewWillDisappear:(BOOL)animated{
    if (selectedNoteText != nil) {
      // [[self delegate] setNote:[NSString stringWithFormat:@"%@",selectedNoteText ]];
    }
     

}

- (void)viewDidLoad
{
    [super viewDidLoad];
      
    [textViewNote setReturnKeyType:UIReturnKeyDone];
    [textViewNote setText:@"Enter text here"];
    [textViewNote setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    [textViewNote setTextColor:[UIColor whiteColor]];
    [textViewNote becomeFirstResponder];
    
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(setNoteTextView:)];
    
    [self.navigationItem setRightBarButtonItem:saveButton];
    
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

    
    textViewNote.text = pickedNoteText;
    
    [saveButton release];
}

-(void)setNote{
    
    selectedNoteText = textViewNote.text;
    
    [[self delegate] setNote:[NSString stringWithFormat:@"%@",selectedNoteText ]];
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)setNoteTextView:(id)sender{
   
    [self setNote];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc {
   // [textViewNote release];
   // [selectedNoteText release];
    [super dealloc];
}
- (void)viewDidUnload {
   // [self setTextViewNote:nil];
    [super viewDidUnload];
}
@end
