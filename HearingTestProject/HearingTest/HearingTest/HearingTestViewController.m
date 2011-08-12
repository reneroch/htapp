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
    _clickLabel.text= @"";
    srand ( time(NULL) );
    
    NSLog(@"%f\n", [self randomNumber]);
    NSLog(@"%f\n", [self randomNumber]);
    NSLog(@"%f\n", [self randomNumber]);
    NSLog(@"%f\n", [self randomNumber]);
    NSLog(@"%f\n", [self randomNumber]);
    NSLog(@"%f\n", [self randomNumber]);
    NSLog(@"%f\n", [self randomNumber]);
    NSLog(@"%f\n", [self randomNumber]);
    NSLog(@"%f\n", [self randomNumber]);
    NSLog(@"%f\n", [self randomNumber]);
    NSLog(@"%f\n", [self randomNumber]);
    NSLog(@"%f\n", [self randomNumber]);
    NSLog(@"%f\n", [self randomNumber]);
    NSLog(@"%f\n", [self randomNumber]);
    NSLog(@"%f\n", [self randomNumber]);
    NSLog(@"%f\n", [self randomNumber]);
    NSLog(@"%f\n", [self randomNumber]);
    NSLog(@"%f\n", [self randomNumber]);
    NSLog(@"%f\n", [self randomNumber]);
    NSLog(@"%f\n", [self randomNumber]);
    
}

-(void)openDataFile
{
    // some iOS specific code to create file path:
    NSArray *paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path= [paths objectAtIndex:0];
    NSString *fullFilePath= [path stringByAppendingPathComponent:@"soundappfile.txt"];
    
    soundData = fopen ([fullFilePath UTF8String], "a");
    assert(soundData != NULL);              // fail right here if file was not opened as expected.
    NSLog(@"Data file path: %@", fullFilePath);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.wPlayer= nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// return random number in range [-1, +1]
-(float)randomNumber
{
    float x;
    rand();
    x= ((rand() - (RAND_MAX/2.0))/(RAND_MAX/2.0));
    return x;
}

-(IBAction)play:(id)sender
{
    _playButton.enabled= NO;     // prevent play while already playing
    
    float signalDuration= 1.0;      // [seconds]
    long ndata= signalDuration * _wPlayer.sampleRate;    // sample rate is samples per second
    float wave[ndata];
    //    float frequency= 1000;  // [Hz]
    float frequency;
    float sineAmplitude= 0.04;
    float noiseAmplitude= 0.3;
    float t;                // time
    
    frequency= 2000;
    float period= 1.0 / frequency;
    
    sineAmplitude += 0.7 * sineAmplitude*[self randomNumber];   // +- 70% variation of sine amplitude
    frequency += 0.3 * frequency * [self randomNumber];         // +- 30% variation of sine frequency

    if (rand() %2 == 0){
        for (long i= 0;    i<ndata;    i++) {
            t= (float)i / _wPlayer.sampleRate;
            wave[i]= sineAmplitude * sin(2.0 * M_PI * t/period) + noiseAmplitude * [self randomNumber];
            // wave[i]= amplitude * sin(2.0 * M_PI * t/period);
            soundtype= 1;
        }
    } else {
        for (long i= 0;    i<ndata;    i++) {
            t= (float)i / _wPlayer.sampleRate;
            wave[i]= noiseAmplitude * [self randomNumber];
            soundtype= 2;
        }
    }
    
    
    
    
    [_wPlayer setWaveform:wave dataCount:ndata];
    
    [_wPlayer play];
    [self performSelector:@selector(stop) withObject:nil afterDelay:signalDuration + 0.1];
    _clickLabel.text= [NSString stringWithFormat:@"Choose Sound Type"];
    _amButton.enabled= YES;
    _unmodButton.enabled= YES;
    
    
}

-(void)stop
{
    [self.wPlayer stop];
}

-(IBAction)resetViewBackgroundColor
{
    _hannahView.backgroundColor= [UIColor colorWithRed:164.0/255 green:210./255 blue:255/255 alpha:1.0];
}


-(IBAction)amButtonClicked:(id)sender
{
    NSLog(@"%s\n",__FUNCTION__);
    _playButton.enabled= YES;
    _amButton.enabled= NO;
    _unmodButton.enabled= NO;
    if (soundtype == 1) {
        _hannahView.backgroundColor= [UIColor greenColor];
        [self performSelector:@selector(resetViewBackgroundColor) withObject:nil afterDelay: 1.5];
        _clickLabel.text= [NSString stringWithFormat:@"Correct\n"];
        fprintf (soundData, "A Hit\n");
        hitCount++;
        _hitLabel.text= [NSString stringWithFormat:@"Hits: %d", hitCount];
    } else {
        _hannahView.backgroundColor= [UIColor redColor];
        [self performSelector:@selector(resetViewBackgroundColor) withObject:nil afterDelay: 1.5];
        _clickLabel.text= [NSString stringWithFormat:@"Incorrect\n"];
        fprintf (soundData, "False Alarm\n");
        falseAlarmCount++;
        _falseAlarmLabel.text= [NSString stringWithFormat:@"FAs: %d", falseAlarmCount];
        
    }
}

-(IBAction)unmodButtonClicked:(id)sender
{   
    NSLog(@"%s\n",__FUNCTION__);
    _playButton.enabled= YES;
    _amButton.enabled= NO;
    _unmodButton.enabled= NO;
    if (soundtype == 2) {
        _hannahView.backgroundColor= [UIColor greenColor];
        [self performSelector:@selector(resetViewBackgroundColor) withObject:nil afterDelay: 1.5];
        _clickLabel.text= [NSString stringWithFormat:@"Correct\n"];
        fprintf (soundData, "Correct Rejection\n");
        correctRejectionCount++;
        _correctRejectionLabel.text= [NSString stringWithFormat:@"CRs: %d", correctRejectionCount];
    } else {
        _hannahView.backgroundColor= [UIColor redColor];
        [self performSelector:@selector(resetViewBackgroundColor) withObject:nil afterDelay: 1.5];
        _clickLabel.text= [NSString stringWithFormat:@"Incorrect\n"];
        fprintf (soundData, "A Miss\n");
        missCount++;
        _missLabel.text= [NSString stringWithFormat:@"Misses: %d", missCount];
    }
}

-(void)closeDataFile
{
    fclose (soundData);    
}





@end
