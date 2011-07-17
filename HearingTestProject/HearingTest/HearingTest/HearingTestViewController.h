//
//  HearingTestViewController.h
//  HearingTest
//
//  Created by Dan Rene Rasmussen on 7/17/11.
//

#import <UIKit/UIKit.h>
#import "HtWaveformPlayer.h"

@interface HearingTestViewController : UIViewController {
    IBOutlet UIButton *playButton;
    IBOutlet UISlider *_frequencySlider;
    IBOutlet UILabel *_frequencyLabel;
    
    HtWaveformPlayer *_wPlayer;
}

@property (nonatomic, retain) HtWaveformPlayer* wPlayer;

-(IBAction)play:(id)sender;
-(void)stop;

-(IBAction)frequencyChanged:(id)sender;

@end
