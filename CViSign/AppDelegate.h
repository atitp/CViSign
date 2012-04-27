//
//  AppDelegate.h
//  CViSign
//
//  Created by Atit Patumvan on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PhotoGrabber.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>{
    NSWindow * _window;
    QTCaptureView * _captureView;
    PhotoGrabber * _grabber;
    NSImageView * _imageView;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet QTCaptureView *captureView;
@property (assign) IBOutlet NSImageView *imageView;
- (IBAction)btnCaptureImagePress:(id)sender;

@end
