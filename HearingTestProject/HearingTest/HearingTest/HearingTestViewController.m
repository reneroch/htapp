//
//  HearingTestViewController.m
//  HearingTest
//
//  Created by Dan Rene Rasmussen on 7/17/11.
//

#import "HearingTestViewController.h"

@implementation HearingTestViewController

@synthesize wPlayer= _wPlayer;

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _wPlayer= [[HtWaveformPlayer alloc] init];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.wPlayer= nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)play:(id)sender
{
    playButton.enabled= NO;     // prevent play while already playing
    
    float signalDuration= 5.0;      // [seconds]
    long ndata= signalDuration * _wPlayer.sampleRate;    // sample rate is samples per second
    float wave[ndata];
    //    float frequency= 1000;  // [Hz]
    float frequency= _frequencySlider.value;
    float amplitude= 0.25;
    float t;                // time
    
    float period= 1.0 / frequency;
    for (long i= 0;i<ndata;i++) {
        t= (float)i / _wPlayer.sampleRate;
        wave[i]= amplitude * sin(2.0 * M_PI * t/period);
    }
    
    [_wPlayer setWaveform:wave dataCount:ndata];
    
    [_wPlayer play];
    [self performSelector:@selector(stop) withObject:nil afterDelay:signalDuration + 0.1];
    
}

-(void)stop
{
    [self.wPlayer stop];
    playButton.enabled= YES;
}

-(IBAction)frequencyChanged:(id)sender
{
    UISlider *slider= (UISlider*)sender;
    _frequencyLabel.text= [NSString stringWithFormat:@"%.0f Hz", slider.value];
}

@end
