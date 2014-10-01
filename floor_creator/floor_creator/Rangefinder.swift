//
//  Rangefinder.swift
//  floor_creator
//
//  Created by Mark Reimer on 10/1/14.
//  Copyright (c) 2014 Shy Ward. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class Rangefinder: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    
    
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
        let imageBuffer: CVImageBufferRef = CMSampleBufferGetImageBuffer(sampleBuffer);
        
        /*
        if (CVPixelBufferLockBaseAddress(imageBuffer, 0) == CVReturnSuccess) {
            
        }
    */
    
    
    }
    
    
    
    /*
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
NSLog(@"buffer: %@", [self shortToBinary:buffer]);

if (bit_counter == 16) {
NSLog(@"buffer: %@, %@", [self shortToBinary:buffer], [self cmToFeetInches:buffer]);
dispatch_async(dispatch_get_main_queue(), ^{
label.text = [self cmToFeetInches:buffer];
});
}

//NSLog(@"zero counter: %d", zero_counter);
}
}

*/
}




