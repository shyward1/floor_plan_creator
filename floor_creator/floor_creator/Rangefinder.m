//
//  Rangefinder.m
//  floor_creator
//
//  Created by Mark Reimer on 10/1/14.
//  Copyright (c) 2014 Shy Ward. All rights reserved.
//

#import "Rangefinder.h"
#import <CoreImage/CoreImage.h>
#import <ImageIO/ImageIO.h>
#import <AssertMacros.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface Rangefinder (InternalMethods)
- (void)setupAVCapture;
- (void)teardownAVCapture;
@end

@implementation Rangefinder

- (id)init {
    self = [super init];
    if (self) {
        [self setupAVCapture];
    }
    return self;
}

- (void)setupAVCapture
{
    // holds the LiFi values as they stream in (16 bits wide)
    buffer = 0;
    zero_counter = 0;
    bit_counter = 0;
    
    NSError *error = nil;
    
    session = [AVCaptureSession new];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        [session setSessionPreset:AVCaptureSessionPreset640x480];
    else
        [session setSessionPreset:AVCaptureSessionPresetPhoto];
    
    // Select a video device, make an input
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if (error == nil) {
        // lock autofocus, brightness
        [device lockForConfiguration:&error];
        if ([device isFocusModeSupported:AVCaptureFocusModeLocked]) {
            [device setFocusMode:AVCaptureFocusModeLocked];
        }
        if ([device isExposureModeSupported:AVCaptureExposureModeLocked]) {
            [device setExposureMode:AVCaptureExposureModeLocked];
        }
        if ([device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeLocked]) {
            [device setWhiteBalanceMode:AVCaptureWhiteBalanceModeLocked];
        }
        [device unlockForConfiguration];
        
        if ( [session canAddInput:deviceInput] )
            [session addInput:deviceInput];
        
        // Make a video data output
        videoDataOutput = [AVCaptureVideoDataOutput new];
        
        // we want BGRA, both CoreGraphics and OpenGL work well with 'BGRA'
        NSDictionary *rgbOutputSettings = [NSDictionary dictionaryWithObject:
                                           [NSNumber numberWithInt:kCMPixelFormat_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
        [videoDataOutput setVideoSettings:rgbOutputSettings];
        [videoDataOutput setAlwaysDiscardsLateVideoFrames:YES]; // discard if the data output queue is blocked (as we process the still image)
        
        // create a serial dispatch queue used for the sample buffer delegate as well as when a still image is captured
        // a serial dispatch queue must be used to guarantee that video frames will be delivered in order
        // see the header doc for setSampleBufferDelegate:queue: for more information
        videoDataOutputQueue = dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL);
        [videoDataOutput setSampleBufferDelegate:self queue:videoDataOutputQueue];
        
        if ( [session canAddOutput:videoDataOutput] ) {
            [session addOutput:videoDataOutput];
            //[videoDataOutput connectionWithMediaType:AVMediaTypeVideo];
        }
        
        AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
        [previewLayer setBackgroundColor:[[UIColor blackColor] CGColor]];
        [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
        UIView *previewView;
        CALayer *rootLayer = [previewView layer];
        [rootLayer setMasksToBounds:YES];
        [previewLayer setFrame:[rootLayer bounds]];
        //[rootLayer addSublayer:previewLayer];
        
        // start the AVCapture session
        [session startRunning];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Failed with error %d", (int)[error code]]
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

// clean up capture setup
- (void)teardownAVCapture
{
    videoDataOutput = nil;
    videoDataOutputQueue = nil;
}


- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    if (CVPixelBufferLockBaseAddress(imageBuffer, 0) == kCVReturnSuccess){
        UInt8 *base = (UInt8 *)CVPixelBufferGetBaseAddress(imageBuffer);
        
        size_t width            = CVPixelBufferGetWidth(imageBuffer);
        size_t height           = CVPixelBufferGetHeight(imageBuffer);
        UInt32 totalBrightness  = 0;
        UInt32 thisBrightness   = 0;
        UInt8 *pos              = base;
        UInt8 red               = 0;
        UInt8 green             = 0;
        UInt8 blue              = 0;
        
        // take 8 samples
        pos += (width/4)*1 + (height/4)*1;
        red = pos[0];
        blue = pos[1];
        green = pos[2];
        thisBrightness = (.299*red + .587*green + .114*blue);
        totalBrightness += thisBrightness;
        
        pos += (width/4)*1 + (height/4)*2;
        red = pos[0];
        blue = pos[1];
        green = pos[2];
        thisBrightness = (.299*red + .587*green + .114*blue);
        totalBrightness += thisBrightness;
        
        pos += (width/4)*2 + (height/4)*1;
        red = pos[0];
        blue = pos[1];
        green = pos[2];
        thisBrightness = (.299*red + .587*green + .114*blue);
        totalBrightness += thisBrightness;
        
        pos += (width/4)*2 + (height/4)*2;
        red = pos[0];
        blue = pos[1];
        green = pos[2];
        thisBrightness = (.299*red + .587*green + .114*blue);
        totalBrightness += thisBrightness;
        
        pos += (width/4)*3 + (height/4)*1;
        red = pos[0];
        blue = pos[1];
        green = pos[2];
        thisBrightness = (.299*red + .587*green + .114*blue);
        totalBrightness += thisBrightness;
        
        pos += (width/4)*3 + (height/4)*2;
        red = pos[0];
        blue = pos[1];
        green = pos[2];
        thisBrightness = (.299*red + .587*green + .114*blue);
        totalBrightness += thisBrightness;
        
        pos += (width/4)*2 + (height/4)*3;
        red = pos[0];
        blue = pos[1];
        green = pos[2];
        thisBrightness = (.299*red + .587*green + .114*blue);
        totalBrightness += thisBrightness;
        
        pos += (width/4)*3 + (height/4)*3;
        red = pos[0];
        blue = pos[1];
        green = pos[2];
        thisBrightness = (.299*red + .587*green + .114*blue);
        totalBrightness += thisBrightness;
        
        unsigned int b = (unsigned int)totalBrightness/100;
        
        
        // push to buffer
        if (b <= 4) {
            // represents a delimeter between bits
            ++zero_counter;
        }
        // represents the value 1
        else if (b == 20) {
            
            // is this the first value after a long list of 0's?
            if (zero_counter > 10) {
                // clear buffer
                buffer = 0;
                bit_counter = 0;
            }
            
            // make sure the value preceding this one was a zero
            if (zero_counter > 0) {
                buffer = buffer << 1;
                buffer = buffer | 0x1;
                ++bit_counter;
            }
            
            // reset the counter
            zero_counter = 0;
        }
        // represents the value 0
        else if (b > 4 && b < 20) {
            // is this the first value after a long list of 0's?
            if (zero_counter > 10) {
                // clear buffer
                buffer = 0;
                bit_counter = 0;
            }
            
            // make sure the value preceding this one was a zero
            if (zero_counter > 0) {
                buffer = buffer << 1;
                //buffer = buffer & 0x0;
                ++bit_counter;
            }
            
            // reset the counter
            zero_counter = 0;
        }
        
        NSLog(@"total brightness: %u", b);
        NSLog(@"zero counter: %u", zero_counter);
        
        if (bit_counter == 16) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 _distanceLabel.text = [NSString stringWithFormat:@"%d", buffer];
            });

        }
    }
}


@end