//
//  IMFilter.m
//  CViSign
//
//  Created by Atit Patumvan on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IMFilter.h"

@implementation IMFilter
-(NSImage  *) grayscale :(NSImage  *) nsImage{
	CGContextRef ctx;
    CGImageSourceRef source;
    source = CGImageSourceCreateWithData((CFDataRef)[nsImage TIFFRepresentation], NULL);
    
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, 0, NULL);
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = malloc(height * width * 4);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
												 bitsPerComponent, bytesPerRow, colorSpace,
												 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
	
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
	
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    int byteIndex = (bytesPerRow * 0) + 0 * bytesPerPixel;
    for (int ii = 0 ; ii < width * height ; ++ii)
    {
        // Get color values to construct a UIColor
        //		  CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
        //        CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
        //        CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
        //        CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
		
		//int outputColor = (rawData[byteIndex] + rawData[byteIndex+1] + rawData[byteIndex+2]) / 3;
		int outputColor = (rawData[byteIndex]);
		rawData[byteIndex] = (char) (outputColor);
		rawData[byteIndex+1] = (char) (outputColor);
		rawData[byteIndex+2] = (char) (outputColor);
		
        byteIndex += 4;
    }
	
	ctx = CGBitmapContextCreate(rawData,  
								CGImageGetWidth( imageRef ),  
								CGImageGetHeight( imageRef ),  
								8,  
								CGImageGetBytesPerRow( imageRef ),  
								CGImageGetColorSpace( imageRef ),  
								kCGImageAlphaPremultipliedLast ); 
	
	imageRef = CGBitmapContextCreateImage (ctx);
    NSImage * newImage = [self imageFromCGImageRef: imageRef];
	
	CGContextRelease(ctx);  
	
	free(rawData);
	return newImage;
}

- (NSImage*) imageFromCGImageRef:(CGImageRef)image
{ 
    NSRect imageRect = NSMakeRect(0.0, 0.0, 0.0, 0.0); 
    CGContextRef imageContext = nil; 
    NSImage* newImage = nil; // Get the image dimensions. 
    imageRect.size.height = CGImageGetHeight(image); 
    imageRect.size.width = CGImageGetWidth(image); 
    
    // Create a new image to receive the Quartz image data. 
    newImage = [[NSImage alloc] initWithSize:imageRect.size]; 
    [newImage lockFocus]; 
    
    // Get the Quartz context and draw. 
    imageContext = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];    
    CGContextDrawImage(imageContext, *(CGRect*)&imageRect, image); [newImage unlockFocus]; 
    return newImage;
}
@end

