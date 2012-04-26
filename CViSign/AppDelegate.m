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
@synthesize outputView = _outputView;

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    PhotoGrabber *grabber = [[PhotoGrabber alloc] init];
	//grabber.delegate = self;
	//[grabber grabPhoto];
    [grabber setQTCaptionView:_outputView];
}

@end
