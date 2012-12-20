//
//  NoteViewController.h
//  MyTask
//
//  Created by Susitha on 11/29/12.
//
//

#import <UIKit/UIKit.h>

@protocol PassNoteText <NSObject>

@required
- (void)setNote:(NSString *)pickedNoteText;
@end



@interface NoteViewController : UIViewController<UITextViewDelegate>
{
    IBOutlet UITextView *textViewNote;
    id <PassNoteText> delegate;
    NSString *selectedNoteText;
}

@property (copy) NSString *pickedNoteText;
@property (retain) id delegate;
@property (retain, nonatomic) IBOutlet UITextView *textViewNote;
@property (retain,nonatomic) NSString *selectedNoteText;

-(void)setNote;

@end
