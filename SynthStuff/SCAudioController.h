//
//  SCAudioController.h
//  Sound Scape
//
//  Created by Stephen Cussen on 11/19/13.
//  Copyright (c) 2013 Stephen Cussen. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

// some MIDI constants:
enum {
    kMIDIMessage_NoteOn    = 0x9,
    kMIDIMessage_NoteOff   = 0x8,
};

enum{lowNote, midNote, highNote};

// define some midi notes to play - middle C (60), C one octave below (48) and C one octave above (72)
#define kLowNote  48
#define kMidNote  60
#define kHighNote 72

@interface SCAudioController : NSObject <AVAudioSessionDelegate>
@property (readwrite) AudioUnit samplerUnit;
@property (readwrite) AudioUnit samplerUnit2;
@property (readwrite)  BOOL bus1IsOn;
@property (readwrite)  BOOL bus2IsOn;

- (void) setupAudio;
- (int) pitchAdj: (int) pitchValue;
@end
