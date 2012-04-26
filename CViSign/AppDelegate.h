//
//  AppDelegate.h
//  CViSign
//
//  Created by Atit Patumvan on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PhotoGrabber.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet QTCaptureView *outputView;

@end
