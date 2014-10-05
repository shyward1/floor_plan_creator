//
//  Rangefinder.h
//  floor_creator
//
//  Created by Mark Reimer on 10/1/14.
//  Copyright (c) 2014 Shy Ward. All rights reserved.
//

#ifndef floor_creator_Rangefinder_h
#define floor_creator_Rangefinder_h


#endif

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface Rangefinder : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate>
{
    dispatch_queue_t videoDataOutputQueue;
    AVCaptureVideoDataOutput *videoDataOutput;
    AVCaptureSession *session;
    
    // buffer for LiFi data while waiting for the first 1 bit
    unsigned short buffer;
    int bit_counter;
    int zero_counter;
}

@property (assign) int distance;
@property (readonly) BOOL isRunning;

@end