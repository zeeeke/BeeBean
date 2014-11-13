//
//  ViewController.m
//  EZSMusicalSpoons
//
//  Created by Zeke Shearer on 11/12/14.
//  Copyright (c) 2014 Zeke Shearer. All rights reserved.
//

#import "ViewController.h"
#import "MSSBeanController.h"
#import "SCAudioController.h"

@interface ViewController () <MSSBeanControllerDelegate>

@property (nonatomic, strong) MSSBeanController *beanController;
@property (nonatomic, strong) SCAudioController *audioController;

@end

@implementation ViewController

#pragma mark - Lifecycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupAudioController];
    [self setupBeanController];
}

#pragma mark - Setup Methods

- (void)setupAudioController
{
    self.audioController = [[SCAudioController alloc] init];
    [self.audioController setupAudio];
    
    self.audioController.bus1IsOn = NO;
    self.audioController.bus2IsOn = YES;
}

- (void)setupBeanController
{
    self.beanController = [[MSSBeanController alloc] init];
    self.beanController.delegate = self;
}

#pragma mark - Action Methods

- (IBAction)startPressed:(id)sender
{
    [self.beanController start];
    [self startPlaying];
}

- (IBAction)stopPressed:(id)sender
{
    [self.beanController stop];
    [self stopPlaying];
}

#pragma mark - Bean Controller Delegate

- (void)beanController:(MSSBeanController *)beanController didUpdateAxes:(PTDAcceleration)acceleration
{
    
    CGFloat zAccel;
    NSInteger min;
    NSInteger max;
    
    zAccel = acceleration.z;
    //isolate the difference from gravity, maybe
    zAccel -= .98;
    
    min = -99;
    max = 99;

    zAccel = zAccel *100;
    
    if ( zAccel < min ) {
        zAccel = min;
    }
    if ( zAccel > max ) {
        zAccel = max;
    }
    
    [self pitchAdjustmentChanged:zAccel];
    
    NSLog(@"%f", zAccel);
    
}

#pragma mark - Music Controller Methods

- (void)startPlaying
{
    UInt32 noteNum;
    
    noteNum = kMidNote;

    UInt32 onVelocity = 127;
    UInt32 noteCommand = 	kMIDIMessage_NoteOn << 4 | 0;
    OSStatus result = noErr;
    result = MusicDeviceMIDIEvent(self.audioController.samplerUnit2, noteCommand, noteNum, onVelocity, 0);
    if (result != noErr) NSLog (@"Unable to start playing the note on samplerUnit2. Error code: %d\n", (int) result);
}

// Stop the note play
- (void)stopPlaying
{
    UInt32 noteNum;

    noteNum = kMidNote;

    
    UInt32 noteCommand = 	kMIDIMessage_NoteOff << 4 | 0;
    OSStatus result = noErr;
    result = MusicDeviceMIDIEvent(self.audioController.samplerUnit2, noteCommand, noteNum, 0, 0);
    if (result != noErr) NSLog (@"Unable to stop playing the note on samplerUnit2. Error code: %d\n", (int) result);
}


// give a number between -99 and 99
- (void)pitchAdjustmentChanged:(NSInteger)value
{
    NSInteger pitchAdj = value;
    if (labs(pitchAdj) <= 5 ) {
        pitchAdj = 0;
    }
    NSLog(@"Pitch adjustment value = %ld", pitchAdj);

    int result = [self.audioController pitchAdj:pitchAdj];
    
    if(result != 0) NSLog (@"Unable to set the property pitch adjustment parameter on the effects unit. Error code: %d\n", (int) result);
}

@end
