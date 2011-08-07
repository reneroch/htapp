//
//  HearingTestViewController.h
//  HearingTest
//
//  Created by Dan Rene Rasmussen on 7/17/11.
//

#import <UIKit/UIKit.h>
#import "HtWaveformPlayer.h"

@interface HearingTestViewController : UIViewController {
    IBOutlet UIButton *_playButton;
    IBOutlet UIButton *_amButton;
    IBOutlet UIButton *_unmodButton;
    IBOutlet UIView *_hannahView;
    IBOutlet UILabel *_clickLabel;
    IBOutlet UILabel *_hitLabel;
    IBOutlet UILabel *_falseAlarmLabel;
    IBOutlet UILabel *_missLabel;
    IBOutlet UILabel *_correctRejectionLabel;
    
    FILE * soundData;
    int soundtype;
    int hitCount;
    int missCount;
    int falseAlarmCount;
    int correctRejectionCount;
    HtWaveformPlayer *_wPlayer;
    
    
}

@property (nonatomic, retain) HtWaveformPlayer* wPlayer;

-(IBAction)play:(id)sender;
-(void)stop;

-(IBAction)amButtonClicked:(id)sender;
-(IBAction)unmodButtonClicked:(id)sender;
-(IBAction)resetViewBackgroundColor;

-(void)closeDataFile;
-(void)openDataFile;



@end
