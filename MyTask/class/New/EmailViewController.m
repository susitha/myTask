//
//  ViewController.m
//  MyTask
//
//  Created by Susitha on 11/26/12.
//
//

#import "EmailViewController.h"
#import "StoredEmail.h"
#import "DBConnect.h"



@implementation EmailViewController
@synthesize emailTable;
@synthesize delegate;
@synthesize pickedEmail;
@synthesize textEmail;
@synthesize insertEmailCell;
@synthesize selectedEmails;

ABPeoplePickerNavigationController *newPeoplePicker;

-(void)refreshTable{
    
    [emails removeAllObjects];
    NSMutableArray *tempArray = [DBConnect getAllEmails];
    for (StoredEmail *email in tempArray) {
        [emails addObject:email];
    }
    
    [emailTable reloadData];
}

-(BOOL)isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


-(BOOL)isEmailSelected:(NSString *)email{

  
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF = %@", email];
    NSArray *results = [selectedEmails filteredArrayUsingPredicate:predicate];
        
    if ([results count] > 0) {
        return YES;
    }
    return NO;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];

    [emailTable setEditing:editing animated:YES];
    
    if (editing) {
       // addButton.enabled = NO;
    } else {
       // addButton.enabled = YES;
    }
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
           }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    
    [self refreshTable];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    selectedEmail = pickedEmail;
    if (selectedEmails == nil) {
        selectedEmails = [[NSMutableArray alloc]init];
    }
    
       
}


-(void)viewWillDisappear:(BOOL)animated{
    
    NSLog(@"dsd %@",selectedEmails);
    [[self delegate] setEmail:selectedEmail];
    
    [[self delegate] setSelectedEmails:selectedEmails];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
        
    emails = [[NSMutableArray alloc]init];
    
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
  
}

- (void)shiftUpLayout{
    if ([textEmail isFirstResponder]  && [emails count] > 3 )
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        
        int y;
        if (self.navigationController.view.frame.size.height >480) {
            y = -30;
        }else{
            y = -200;
        }
        [self.emailTable setFrame:CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height)];
    }
    
}

- (void)shiftDownLayout{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.2f];
    [self.emailTable setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [UIView commitAnimations];
    
}


- (void)keyboardWillShow:(NSNotification *)note
{
   // [self shiftUpLayout];
}

- (void)keyboardWillHide:(NSNotification *)note
{
  //  [self shiftDownLayout];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [emails count]+1;
  
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if(  indexPath.row > 0 ){
        
        StoredEmail *email = [emails objectAtIndex:[emails count]-indexPath.row  ];
        cell.textLabel.text = email.storedEmail;
        
      
                if ([self isEmailSelected:email.storedEmail]) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                } else {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
        
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }else {
        
        [insertEmailCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return insertEmailCell;
        
    }
    
    
}


#pragma mark UITableViewDelegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return  UITableViewCellEditingStyleInsert;
    }
    
    return UITableViewCellEditingStyleDelete;
    
}


    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{    

    
    if(indexPath.row > 0 ){
         
        StoredEmail *tEmail = [emails objectAtIndex:[emails count]-indexPath.row ];
        selectedEmail = tEmail.storedEmail;
     
        if (![self isEmailSelected:selectedEmail]) {
            [selectedEmails addObject:selectedEmail ];
        }else{
            [selectedEmails removeObject:selectedEmail];
        }
       
        
    [emailTable reloadData];
    
    }
}




- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleInsert){
        
        if ([self isValidEmail:textEmail.text]){
            StoredEmail *email = [[StoredEmail alloc]init];
            email.storedEmail = self.textEmail.text;
            
        if (![DBConnect isEmailExists:email.storedEmail]) {
            
            [DBConnect insertNewEmail:email];
            self.textEmail.text = @"";
                        
            [emailTable setEditing:NO];
        }else{
            
            UIAlertView *altTitle = [[UIAlertView alloc]initWithTitle:nil message:@"Email already exists" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [altTitle show];
            [emailTable setEditing:YES];
            [altTitle release];
            
        }
        
            
            [email release];
        }else{
            UIAlertView *altTitle = [[UIAlertView alloc]initWithTitle:nil message:@"Enter valid email" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [altTitle show];
             [emailTable setEditing:YES];
            [altTitle release];
        }
        
    }else if(editingStyle == UITableViewCellEditingStyleDelete){
        
        StoredEmail *emailDel = [emails objectAtIndex:[emails count]-indexPath.row ];
        [DBConnect deleteEmail:emailDel];
        [emails removeObjectAtIndex:[emails count]-indexPath.row ];
       // [emailDel release];
        [emailTable setEditing:NO];
    }
    
   // [emailTable setEditing:NO];
    
    [self refreshTable];
 
   }


#pragma mark text field delegate


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if ([self isValidEmail:textEmail.text]) {
        StoredEmail *email = [[[StoredEmail alloc]init]autorelease];
        email.storedEmail = self.textEmail.text;
        
        if(![DBConnect isEmailExists:email.storedEmail]){
            
            [DBConnect insertNewEmail:email];
            [textEmail resignFirstResponder];
           // [emailTable setEditing:NO animated:YES];

            [self refreshTable];
            textEmail.text = @"";
            return YES;
            
        }else{
            
            UIAlertView *altTitle = [[UIAlertView alloc]initWithTitle:nil message:@"Email already exists" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [altTitle show];
            [altTitle release];
            return NO;
           
        }
        
        [email release];
      
        
        
    }else if(![textEmail.text isEqualToString:@""]){
        
        UIAlertView *altTitle = [[UIAlertView alloc]initWithTitle:nil message:@"Enter valid email" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [altTitle show];
        [altTitle release];
        return NO;
        
        
    }else{
        
        [textEmail resignFirstResponder];
        return NO;
    }
   
}


-(IBAction)showAddressBook:(id)sender{
    
    newPeoplePicker = [[ABPeoplePickerNavigationController alloc]init];
    [[newPeoplePicker navigationBar] setTintColor:[UIColor blackColor]];
    newPeoplePicker.peoplePickerDelegate = self;
    [self presentModalViewController:newPeoplePicker animated:YES];
}


#pragma mark ABPeoplePickerNavigationControllerDelegate

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
  [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    
    
    ABMultiValueRef personEmails = ABRecordCopyValue(person, kABPersonEmailProperty);
    
    NSUInteger j = 0;
    for (j = 0; j < ABMultiValueGetCount(personEmails); j++)
    {
        NSString *email = ( NSString *)ABMultiValueCopyValueAtIndex(personEmails, j);
        
        StoredEmail *email2 = [[StoredEmail alloc]init];
        email2.storedEmail = email;
       
        
        if (![DBConnect isEmailExists:email]) {
             [DBConnect insertNewEmail:email2];
        }else{
                
        }
             
        [email2 release];
        
        [email release];

    }
     [self dismissModalViewControllerAnimated:YES];
     
    
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
  
}




- (void)dealloc {
   // [emailTable release];
    
    [selectedEmails release];
    [textEmail release];
    [insertEmailCell release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setEmailTable:nil];
    [self setTextEmail:nil];
    [self setInsertEmailCell:nil];
    [super viewDidUnload];
}
@end
