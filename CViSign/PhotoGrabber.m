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
    NSLog(@"found %u device(s)",(int)[inputDevices count]);
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
    CIImage * ciImage = [CIImage imageWithCVImageBuffer:currentImage];
    CGRect croppedRect = [ciImage extent];
    //CGRect croppedRect = CGRectMake(10.0, 10.0, 200.0, 200.0);
    ciImage = [ciImage imageByCroppingToRect:croppedRect];
    NSCIImageRep *imageRep = [NSCIImageRep imageRepWithCIImage:ciImage];
    NSImage *imageCaptured = [[NSImage alloc] initWithSize:[imageRep size]];
    [imageCaptured addRepresentation:imageRep];
    [imageView setImage: imageCaptured];

}

- (void)captureOutput:(QTCaptureOutput *)captureOutput didOutputVideoFrame:(CVImageBufferRef)videoFrame withSampleBuffer:(QTSampleBuffer *)sampleBuffer fromConnection:(QTCaptureConnection *)connection
{
    CVBufferRetain(videoFrame);
    @synchronized (self) {
        currentImage = videoFrame;
    }
    CVBufferRelease(videoFrame);
}


- (CIImage *)view:(QTCaptureView *)view willDisplayImage :(CIImage *)image {
/*
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone" 
                                  keysAndValues: kCIInputImageKey, image, 
                        @"inputIntensity", [NSNumber numberWithFloat:0.8], nil];
    CIImage *outputImage = [filter valueForKey: @"outputImage"];
    
    
    return outputImage;

  */
    return image;
}

- (void)dealloc
{
    [mCaptureSession stopRunning];
    [mCaptureSession release];
    //self.delegate = nil;
    [super dealloc];
}

@end
