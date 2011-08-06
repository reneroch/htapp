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
    
    FILE * soundData;
    int soundtype;
    HtWaveformPlayer *_wPlayer;
    
    
}

@property (nonatomic, retain) HtWaveformPlayer* wPlayer;

-(IBAction)play:(id)sender;
-(void)stop;

-(IBAction)amButtonClicked:(id)sender;
-(IBAction)unmodButtonClicked:(id)sender;
-(IBAction)resetViewBackgroundColor;

@end
