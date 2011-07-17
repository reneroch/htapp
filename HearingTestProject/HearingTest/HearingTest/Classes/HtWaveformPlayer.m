//
//  HtWaveformPlayer.m
//  Hearing Test
//
//  Created by Dan Rene Rasmussen on 7/15/11.
//

#import <AudioToolbox/AudioToolbox.h>

#import "HtWaveformPlayer.h"

void ToneInterruptionListener(void *inClientData, UInt32 inInterruptionState)
{
    HtWaveformPlayer *wplayer= (HtWaveformPlayer*)inClientData;
	[wplayer stop];
}

OSStatus RenderTone(
                    void *inRefCon, 
                    AudioUnitRenderActionFlags 	*ioActionFlags, 
                    const AudioTimeStamp 		*inTimeStamp, 
                    UInt32 						inBusNumber, 
                    UInt32 						inNumberFrames, 
                    AudioBufferList 			*ioData)
{
    HtWaveformPlayer *wplayer= (HtWaveformPlayer*)inRefCon;
    
	// This is a mono tone generator so we only need the first buffer
	const int channel = 0;
	Float32 *buffer = (Float32 *)ioData->mBuffers[channel].mData;
	for (UInt32 frame= 0; frame < inNumberFrames; frame++) {
        long windex= wplayer.waveIndex + frame;
        if (windex < wplayer.waveSampleLength) {
            buffer[frame] = wplayer.amplitude * wplayer.waveform[windex];
        } else {
            buffer[frame]= 0.0;
        }
	}
    // update the wave index so next call to this function starts where we left off:
	wplayer.waveIndex= wplayer.waveIndex + inNumberFrames;
    
	return noErr;
}




@implementation HtWaveformPlayer

@synthesize amplitude= _amplitude;
@synthesize sampleRate= _sampleRate;
@synthesize waveform= _waveform;
@synthesize waveIndex= _waveIndex;
@synthesize waveSampleLength= _waveSampleLength;


-(id)init {
    NSLog(@"%s", __FUNCTION__);
    self= [super init];
    if (self) {
        
        _amplitude= 1.0;
        _sampleRate= 44100; // [Hz]
        
        //
        _isPlaying= false;
        _waveform= nil;
        _waveSampleLength= 0;
        
        //
        OSStatus result= AudioSessionInitialize(NULL, NULL, ToneInterruptionListener, self);
        if (result == kAudioSessionNoError) {
            UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
            AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
        }
        AudioSessionSetActive(true);
    }
    
    return self;
}

-(void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
    [super dealloc];
    AudioSessionSetActive(false);
}


-(void)setWaveform:(float*)wdata dataCount:(long)count
{
    if (_isPlaying) return;
    
    if (_waveform) {
        free(_waveform);
        _waveform= nil;
    }
    _waveform= (float*)malloc(count * sizeof(*_waveform));
    // copy data:
    for (long idx=0;idx<count;idx++) {
        _waveform[idx]= wdata[idx];
    }
    _waveSampleLength= count;
    self.waveIndex= 0;
}


-(void) play
{
    NSLog(@"%s", __FUNCTION__);
    if (_isPlaying) return;
    
    [self createToneUnit];
    
    NSLog(@"%s: unit initialize", __FUNCTION__);
    OSErr err = AudioUnitInitialize(_toneUnit);
    NSAssert1(err == noErr, @"Error initializing unit: %ld", err);
    
    // Start playback
    NSLog(@"%s: unit start", __FUNCTION__);
    err = AudioOutputUnitStart(_toneUnit);
    NSAssert1(err == noErr, @"Error starting unit: %ld", err);
    NSLog(@"%s end", __FUNCTION__);
}

-(void) stop
{
    NSLog(@"%s", __FUNCTION__);
    AudioOutputUnitStop(_toneUnit);
    AudioUnitUninitialize(_toneUnit);
    AudioComponentInstanceDispose(_toneUnit);
    _toneUnit= nil;
    _isPlaying= false;
}


#pragma mark - Tone generation

- (void)createToneUnit
{
    NSLog(@"%s", __FUNCTION__);
	// Configure the search parameters to find the default playback output unit
	// (called the kAudioUnitSubType_RemoteIO on iOS but
	// kAudioUnitSubType_DefaultOutput on Mac OS X)
	AudioComponentDescription defaultOutputDescription;
	defaultOutputDescription.componentType = kAudioUnitType_Output;
	defaultOutputDescription.componentSubType = kAudioUnitSubType_RemoteIO;
	defaultOutputDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
	defaultOutputDescription.componentFlags = 0;
	defaultOutputDescription.componentFlagsMask = 0;
	
	// Get the default playback output unit
	AudioComponent defaultOutput = AudioComponentFindNext(NULL, &defaultOutputDescription);
	NSAssert(defaultOutput, @"Can't find default output");
	
	// Create a new unit based on this that we'll use for output
	OSErr err = AudioComponentInstanceNew(defaultOutput, &_toneUnit);
	NSAssert1(_toneUnit, @"Error creating unit: %ld", err);
	
	// Set our tone rendering function on the unit
	AURenderCallbackStruct input;
	input.inputProc = RenderTone;
	input.inputProcRefCon = self;
	err = AudioUnitSetProperty(_toneUnit, 
                               kAudioUnitProperty_SetRenderCallback, 
                               kAudioUnitScope_Input,
                               0, 
                               &input, 
                               sizeof(input));
	NSAssert1(err == noErr, @"Error setting callback: %ld", err);
	
	// Set the format to 32 bit, single channel, floating point, linear PCM
	const int four_bytes_per_float = 4;
	const int eight_bits_per_byte = 8;
	AudioStreamBasicDescription streamFormat;
	streamFormat.mSampleRate = self.sampleRate;
	streamFormat.mFormatID = kAudioFormatLinearPCM;
	streamFormat.mFormatFlags =
    kAudioFormatFlagsNativeFloatPacked | kAudioFormatFlagIsNonInterleaved;
	streamFormat.mBytesPerPacket = four_bytes_per_float;
	streamFormat.mFramesPerPacket = 1;	
	streamFormat.mBytesPerFrame = four_bytes_per_float;		
	streamFormat.mChannelsPerFrame = 1;	
	streamFormat.mBitsPerChannel = four_bytes_per_float * eight_bits_per_byte;
	err = AudioUnitSetProperty (_toneUnit,
                                kAudioUnitProperty_StreamFormat,
                                kAudioUnitScope_Input,
                                0,
                                &streamFormat,
                                sizeof(AudioStreamBasicDescription));
	NSAssert1(err == noErr, @"Error setting stream format: %ld", err);
    NSLog(@"%s - end", __FUNCTION__);
}


@end
