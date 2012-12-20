//
//  TonePickViewController.h
//  MyTask
//
//  Created by Susitha Janaka on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@protocol PassTone <NSObject>

@required
- (void) setPickedTone:(NSString *)pickedTone;
@end




@interface TonePickViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,AVAudioPlayerDelegate>
{
    IBOutlet UITableView *toneTable; 
    NSMutableArray *tones;
    NSString *selectedTone;
    id <PassTone> delegate;
    AVAudioPlayer *audioPlayer;
}


@property (copy) NSString *pickedTone;
@property (retain) id delegate;

@end
