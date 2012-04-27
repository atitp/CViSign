//
//  AppDelegate.m
//  CViSign
//
//  Created by Atit Patumvan on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize captureView = _captureView;
@synthesize imageView = _imageView;

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    _grabber = [[PhotoGrabber alloc] init];
	//grabber.delegate = self;
	//[grabber grabPhoto];
    [_grabber setQTCaptionView:_captureView];
    [_grabber setNSImageView:_imageView];
    
    filter = [[IMFilter alloc] init];

    

}

- (IBAction)btnCaptureImagePress:(id)sender {
    [_grabber captureImage];
}

- (IBAction)btnApplyFilter:(id)sender {
    [_imageView setImage:[filter grayscale:[_imageView image]]];
}
@end
