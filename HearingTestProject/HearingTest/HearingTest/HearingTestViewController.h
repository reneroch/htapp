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
    IBOutlet UISlider *_frequencySlider;
    IBOutlet UILabel *_frequencyLabel;
    IBOutlet UIButton *_amButton;
    IBOutlet UIButton *_unmodButton;
    IBOutlet UIView *_hannahView;
    IBOutlet UILabel *_clickLabel;
    
    HtWaveformPlayer *_wPlayer;
}

@property (nonatomic, retain) HtWaveformPlayer* wPlayer;

-(IBAction)play:(id)sender;
-(void)stop;

-(IBAction)amButtonClicked:(id)sender;
-(IBAction)unmodButtonClicked:(id)sender;
-(IBAction)resetViewBackgroundColor;
-(IBAction)frequencyChanged:(id)sender;
-(IBAction)clickLabelChanged:(id)sender;

@end
