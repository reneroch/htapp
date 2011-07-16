//
//  Hearing_TestViewController.h
//  Hearing Test
//
//  Created by Dan Rene Rasmussen on 7/10/11.
//  Copyright 2011 Qi Analytics LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HtWaveformPlayer.h"

@interface Hearing_TestViewController : UIViewController {
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
