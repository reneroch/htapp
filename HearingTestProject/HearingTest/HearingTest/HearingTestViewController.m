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
        
    soundData = fopen ("soundappfile.txt", "a");
    _wPlayer= [[HtWaveformPlayer alloc] init];
    _clickLabel.text= @"";
    srand ( time(NULL) );

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.wPlayer= nil;
    fclose (soundData);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)play:(id)sender
{
    _playButton.enabled= NO;     // prevent play while already playing
    
    float signalDuration= 1.0;      // [seconds]
    long ndata= signalDuration * _wPlayer.sampleRate;    // sample rate is samples per second
    float wave[ndata];
    //    float frequency= 1000;  // [Hz]
    float frequency;
    //  float frequency2= _frequencySlider.value * 1.002;
    float amplitude= 0.2;
    float t;                // time
    
    if (rand() %2 == 0){
        frequency= 1500;
        soundtype= 1;
    } else {
        frequency= 5000;
        soundtype= 2;
    }
    
    float period= 1.0 / frequency;
    //  float period2= 1.0 / frequency2;
    for (long i= 0;    i<ndata;    i++) {
        t= (float)i / _wPlayer.sampleRate;
        wave[i]= amplitude * sin(2.0 * M_PI * t/period);
    }
    
    [_wPlayer setWaveform:wave dataCount:ndata];
    
    [_wPlayer play];
    [self performSelector:@selector(stop) withObject:nil afterDelay:signalDuration + 0.1];
    _clickLabel.text= [NSString stringWithFormat:@"Choose Sound Type"];
    
    
}




-(void)stop
{
    [self.wPlayer stop];
    _playButton.enabled= YES;
}

-(IBAction)resetViewBackgroundColor
{
    _hannahView.backgroundColor= [UIColor colorWithRed:164.0/255 green:210./255 blue:255/255 alpha:1.0];
}


-(IBAction)amButtonClicked:(id)sender
{
    NSLog(@"%s\n",__FUNCTION__);
    if (soundtype == 1) {
        _hannahView.backgroundColor= [UIColor greenColor];
        [self performSelector:@selector(resetViewBackgroundColor) withObject:nil afterDelay: 1.5];
        _clickLabel.text= [NSString stringWithFormat:@"Correct"];
        fprintf (soundData, "A Hit");
    } else {
        _hannahView.backgroundColor= [UIColor redColor];
        [self performSelector:@selector(resetViewBackgroundColor) withObject:nil afterDelay: 1.5];
        _clickLabel.text= [NSString stringWithFormat:@"Incorrect"];
        fprintf (soundData, "False Alarm");

    }
}

-(IBAction)unmodButtonClicked:(id)sender
{   
    NSLog(@"%s\n",__FUNCTION__);
    if (soundtype == 2) {
        _hannahView.backgroundColor= [UIColor greenColor];
        [self performSelector:@selector(resetViewBackgroundColor) withObject:nil afterDelay: 1.5];
        _clickLabel.text= [NSString stringWithFormat:@"Correct"];
        fprintf (soundData, "Correct Rejection");
    } else {
        _hannahView.backgroundColor= [UIColor redColor];
        [self performSelector:@selector(resetViewBackgroundColor) withObject:nil afterDelay: 1.5];
        _clickLabel.text= [NSString stringWithFormat:@"Incorrect"];
        fprintf (soundData, "A Miss");

    }
    
}


@end
