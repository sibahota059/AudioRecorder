//
//  SPHViewController.m
//  AudioUploadSample
//
//  Created by Siba Prasad Hota  on 5/7/14.
//  Copyright (c) 2014 WemakeAppz. All rights reserved.
//

#import "SPHViewController.h"





@interface SPHViewController ()

@end

@implementation SPHViewController

@synthesize playButton;
@synthesize recordButton;
@synthesize UploadButton;
@synthesize stopButton;



- (void)viewDidLoad
{
    [super viewDidLoad];
     isplaying=NO;
    isrecording=NO;
    playButton.enabled = NO;
    stopButton.enabled = NO;
    UploadButton.enabled=NO;
	// Do any additional setup after loading the view, typically from a nib.
}




-(void)UploadToDotNetserver
{
    
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    documentsURL = [documentsURL URLByAppendingPathComponent:@"audiofile.mp4"];
    NSData *webData = [NSData dataWithContentsOfURL:documentsURL];
    NSString *myUrlString=@"ENTER YOUR URL";
    NSURL *myURL = [NSURL URLWithString:myUrlString];
    
    NSLog(@"Send messageurl = %@ ",myURL);
    
    if ([myUrlString isEqualToString:@"ENTER YOUR URL"]) {
        
        UIAlertView *alertnow=[[UIAlertView alloc]initWithTitle:@"oops!!!" message:@"Please Enter your Url" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertnow show];
        
        stopButton.enabled = YES;
        playButton.enabled = YES;
        recordButton.enabled = YES;
    }
    else
    {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:myURL];
        [request setHTTPMethod:@"POST"];
        
        NSMutableData *body = [NSMutableData data];
        
        [body appendData:[NSData dataWithData:webData]];
        
        [request setHTTPBody:body];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
         {
             if([(NSHTTPURLResponse *)response statusCode]==200)
             {
                 
                 id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                 NSLog(@"Upload status=%@",jsonObject);
                 
                 stopButton.enabled = YES;
                 playButton.enabled = YES;
                 recordButton.enabled = YES;
             }
         }];

        
    }
    
   }





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)RecordNow:(id)sender {
    
    isrecording=YES;
    isplaying=NO;
    
    playButton.enabled = NO;
    UploadButton.enabled=NO;
    stopButton.enabled = YES;
    
    // create a URL to an audio asset
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    documentsURL = [documentsURL URLByAppendingPathComponent:@"audiofile.mp4"];
    
    // create an audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    if (session.inputAvailable) {
        
        NSLog(@"We can start recording!");
        [session setActive:YES error:nil];
        
    } else {
        NSLog(@"We don't have a mic to record with :-(");
    }
    
    // settings for our recorder
    NSDictionary *audioSettings = @{AVFormatIDKey: [NSNumber numberWithInt:kAudioFormatMPEG4AAC],
                                    AVSampleRateKey: [NSNumber numberWithFloat:22050],
                                    AVNumberOfChannelsKey: [NSNumber numberWithInt:1]
                                    };
    
    // create an audio recorder with the above URL
    self.recorder = [[AVAudioRecorder alloc]initWithURL:documentsURL settings:audioSettings error:nil];
    self.recorder.delegate = self;
    [self.recorder prepareToRecord];
    [self.recorder record];

}

- (IBAction)stopRecording:(id)sender {
    
    if (isrecording) {
      
         [self.recorder stop];
        isrecording=NO;
        stopButton.enabled = NO;
        playButton.enabled = YES;
        UploadButton.enabled=YES;
    }
   else if(isplaying)
   {
       [self.player stop];
       isplaying=NO;
       stopButton.enabled = NO;
       playButton.enabled = YES;
       UploadButton.enabled=YES;
       
   }
    
}

- (IBAction)PlayRecordedAudio:(id)sender {
    
    isrecording=NO;
    isplaying=YES;
    stopButton.enabled = YES;
    recordButton.enabled = NO;
    playButton.enabled=NO;
    UploadButton.enabled=NO;
    // grab a URL to an audio asset
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    documentsURL = [documentsURL URLByAppendingPathComponent:@"audiofile.mp4"];
    
    // create a session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    // create player
    self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:documentsURL error:nil];
    self.player.delegate = self;
    [self.player prepareToPlay];
    [self.player play];

}


#pragma mark - Delegate Methods

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    
    isrecording=NO;
    stopButton.enabled = NO;
    playButton.enabled = YES;
    UploadButton.enabled=YES;
    // we're done recording
   }

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error {
    
    // something went wrong
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    // done playing
     isplaying=NO;
    stopButton.enabled = NO;
    playButton.enabled = YES;
    UploadButton.enabled=YES;
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    
    // something didn't play so well
}


- (IBAction)UploadToserver:(id)sender {
    
    stopButton.enabled = NO;
    playButton.enabled = NO;
    recordButton.enabled = NO;
    [self UploadToDotNetserver];
    
    // After upload complete, Enable All
    
    /*
     stopButton.enabled = YES;
     playButton.enabled = YES;
     recordButton.enabled = YES;
     */
}
@end
