//
//  PhotoGrabber.m
//  Cocoa32
//
//  Created by Atit Patumvan on 25/1/2555.
//  Copyright (c) 2555 __MyCompanyName__. All rights reserved.
//

#import "PhotoGrabber.h"

@implementation PhotoGrabber
/*
 http://erikrothoff.com/2011/07/capturing-a-photo-programmatically-with-objective-c-using-qtkit/
 
 CVImageBufferRef currentImage;
 
 QTCaptureDevice *video;
 QTCaptureDecompressedVideoOutput *output;
 QTCaptureDeviceInput *input
 QTCaptureSession *session;
 
 id<PhotoGrabber> delegate;
 
 */
-(id) init
{
    
    QTCaptureDevice * inputDevice;
    NSString * defaultDeviceMenuTitle;
    QTCaptureDevice * mCaptureDevice;
    QTCaptureDeviceInput * mCaptureDeviceInput;
    BOOL success;
    NSError *error = nil;
    
    NSArray *inputDevices= [QTCaptureDevice inputDevicesWithMediaType:QTMediaTypeVideo];
    NSLog(@"found %lu device(s)",[inputDevices count]);
    if([inputDevices count] > 0){
        for(inputDevice in inputDevices){
            defaultDeviceMenuTitle = [NSString stringWithFormat: @"Default (%@)", [inputDevice localizedDisplayName]];
            NSLog (@"got device %@", defaultDeviceMenuTitle);
        }
        mCaptureSession = [[QTCaptureSession alloc] init];
        mCaptureDevice = [[QTCaptureDevice inputDevicesWithMediaType:QTMediaTypeVideo] objectAtIndex:0];
        [mCaptureDevice open:nil];
        mCaptureDeviceInput = [QTCaptureDeviceInput deviceInputWithDevice:mCaptureDevice];                
        [mCaptureSession addInput:mCaptureDeviceInput error:nil];
        
        output = [[QTCaptureDecompressedVideoOutput alloc] init];
        
        // This is the delegate. Note the
        // captureOutput:didOutputVideoFrame...-method of this
        // object. That is the method which will be called when 
        // a photo has been taken.
        [output setDelegate:self];
        
        // Add the output-object for the session
        success = [mCaptureSession addOutput:output error:&error];
        
        if ( ! mCaptureSession || error )
        {
            NSLog(@"Did succeed in connecting output to session: %d", success);
            NSLog(@"Error: %@", [error localizedDescription]);
            return nil;
        }
        
        currentImage = nil;
        [mCaptureSession startRunning];
    } else {
        NSLog( @"No video input device" );
        exit( 1 );
    }          
    return self;
}

- (void)setQTCaptionView:(QTCaptureView *) outputView{
    [outputView setCaptureSession:mCaptureSession];
    [outputView setDelegate:self];
}

- (void)setNSImageView:(NSImageView *) _imageView{
    imageView = _imageView; 
}

- (void)captureImage{
    NSLog(@"Captured");
    if ([mCaptureSession isRunning]){
        [mCaptureSession stopRunning];
    }
    
    // Convert the image to a NSImage with JPEG representation
    // This is a bit tricky and involves taking the raw data
    // and turning it into an NSImage containing the image
    // as JPEG
    NSCIImageRep *imageRep = [NSCIImageRep imageRepWithCIImage:[CIImage imageWithCVImageBuffer:currentImage]];
    
    NSImage *imageCaptured = [[NSImage alloc] initWithSize:[imageRep size]];
    [imageCaptured addRepresentation:imageRep];
    [imageView setImage: imageCaptured];
    CVBufferRelease(currentImage);
    currentImage = nil;
    [mCaptureSession startRunning];
}

- (void)captureOutput:(QTCaptureOutput *)captureOutput didOutputVideoFrame:(CVImageBufferRef)videoFrame withSampleBuffer:(QTSampleBuffer *)sampleBuffer fromConnection:(QTCaptureConnection *)connection
{
    
    NSLog(@"video");
    // If we already have an image we should use that instead
    if ( currentImage ) return;
    
    // Retain the videoFrame so it won't disappear
    // don't forget to release!
    CVBufferRetain(videoFrame);
    
    // The Apple docs state that this action must be synchronized
    // as this method will be run on another thread
    @synchronized (self) {
        currentImage = videoFrame;
    }
    
    // As stated above, this method will be called on another thread, so
    // we perform the selector that handles the image on the main thread
    [self performSelectorOnMainThread:@selector(saveImage) withObject:nil waitUntilDone:NO];
    
}

- (CIImage *)view:(QTCaptureView *)view willDisplayImage :(CIImage *)image {

    return nil;
}

- (void)dealloc
{
    [mCaptureSession stopRunning];
    [mCaptureSession release];
    //self.delegate = nil;
    [super dealloc];
}

@end
