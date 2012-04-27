//
//  PhotoGrabber.h
//  Cocoa32
//
//  Created by Atit Patumvan on 25/1/2555.
//  Copyright (c) 2555 Atit Patumvan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QTKit/QTKit.h>

@protocol PhotoGrabber <NSObject>

@end

@interface PhotoGrabber : NSObject{
    
    
    QTCaptureSession * mCaptureSession;
    
    CVImageBufferRef currentImage;
    
    
    QTCaptureDecompressedVideoOutput *output;
    
    int cnt;
    //CIImage * ciImage;
    //NSImage* nsImage;
    NSImageView * imageView;
    NSSize nsSize;
    
    
}


- (void)setQTCaptionView:(QTCaptureView *) outputView; 
- (void)setNSImageView:(NSImageView *) _imageView;
- (void)captureImage;

@end
