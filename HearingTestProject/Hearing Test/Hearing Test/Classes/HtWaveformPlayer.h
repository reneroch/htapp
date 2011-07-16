//
//  HtWaveformPlayer.h
//  Hearing Test
//
//  Created by Dan Rene Rasmussen on 7/15/11.
//

#import <Foundation/Foundation.h>
#import <AudioUnit/AudioUnit.h>


@interface HtWaveformPlayer : NSObject {
    
    
    
    //
    float _amplitude;
    long _sampleRate;    // [Hz] sampling rate
    
    
    // tone generation
    bool _isPlaying;
    float *_waveform;
    long _waveIndex;
    long _waveSampleLength;
    AudioComponentInstance _toneUnit;
}

@property (nonatomic) float amplitude;
@property (nonatomic) long sampleRate;
@property (nonatomic) float* waveform;
@property (nonatomic) long waveIndex;       // the next index to be supplied to render function
@property (nonatomic) long waveSampleLength;

-(id)init;
-(void)dealloc;

-(void)setWaveform:(float*)wdata dataCount:(long)count;

-(void)play;
-(void)stop;


#pragma mark - Tone generation

- (void)createToneUnit;


@end
