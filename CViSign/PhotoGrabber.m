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
    session = [[QTCaptureSession alloc] init];
    
    video = [QTCaptureDevice defaultInputDeviceWithMediaType:QTMediaTypeVideo];
    [video open:nil];
    input = [QTCaptureDeviceInput deviceInputWithDevice:video];                
    [session addInput:input error:nil];
    [session startRunning];
    return self;
}

- (void)setQTCaptionView:(QTCaptureView *) outputView{
    [outputView setCaptureSession:session];
    [outputView setDelegate:self];
}

- (void)setNSImageView:(NSImageView *) _imageView{
    imageView = _imageView; 
}




- (CIImage *)view:(QTCaptureView *)view willDisplayImage :(CIImage *)image {
    
    NSImage *capturedImage = [[NSImage alloc] init];
    [capturedImage addRepresentation:[NSCIImageRep
                                      imageRepWithCIImage:image]];
    
    [capturedImage lockFocus];

    [capturedImage unlockFocus];
    
    // create CIImage from data
    CIImage * ciImage = [[CIImage alloc] initWithData:[capturedImage
                                                       TIFFRepresentation]];
    
    [capturedImage release];
    
    return [ciImage autorelease];
    
    //return nil;
}

- (void)dealloc
{
    //self.delegate = nil;
    [super dealloc];
}

@end
