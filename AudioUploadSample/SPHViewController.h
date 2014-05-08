//
//  SPHViewController.h
//  AudioUploadSample
//
//  Created by Siba Prasad Hota  on 5/7/14.
//  Copyright (c) 2014 WemakeAppz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@import AVFoundation;

@interface SPHViewController : UIViewController<AVAudioRecorderDelegate, AVAudioPlayerDelegate>
{
    
    UIButton *playButton;
    UIButton *recordButton;
    UIButton *stopButton;
    UIButton *UploadButton;
}

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *player;


@property (nonatomic, retain) IBOutlet UIButton *playButton;
@property (nonatomic, retain) IBOutlet UIButton *recordButton;
@property (nonatomic, retain) IBOutlet UIButton *stopButton;
@property (nonatomic, retain) IBOutlet UIButton *UploadButton;

- (IBAction)RecordNow:(id)sender;
- (IBAction)stopRecording:(id)sender;
- (IBAction)PlayRecordedAudio:(id)sender;
- (IBAction)UploadToserver:(id)sender;

@end



