//
//  ViewController.h
//  MyTask
//
//  Created by Susitha on 11/26/12.
//
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import "Task.h"

@protocol PassEmail <NSObject>

@required
- (void) setEmail:(NSString *)pickedEmail;
- (void) setSelectedEmails:(NSMutableArray *)pickedSelectedEmails;
@end



@interface EmailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ABPeoplePickerNavigationControllerDelegate>
{
    NSMutableArray *emails;
    UITableView *emailTable;
    id <PassEmail> delegate;
    NSString *selectedEmail;
    UITextField *textEmail;
    IBOutlet UITableViewCell *insertEmailCell;
    NSMutableArray  *selectedEmails;
    
}

@property (copy) NSString *pickedEmail;
@property (retain) id delegate;
@property (retain, nonatomic) IBOutlet UITextField *textEmail;
@property (retain, nonatomic) IBOutlet UITableViewCell *insertEmailCell;
@property (nonatomic,retain) NSMutableArray  *selectedEmails;


@property (retain, nonatomic) IBOutlet UITableView *emailTable;


-(IBAction)showAddressBook:(id)sender;

@end
