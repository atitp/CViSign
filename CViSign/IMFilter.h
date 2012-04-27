//
//  IMFilter.h
//  CViSign
//
//  Created by Atit Patumvan on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMFilter : NSObject
-(NSImage *) grayscale :(NSImage  *) uiImage;
-(NSImage *) imageFromCGImageRef:(CGImageRef)image;
@end

