//
//  TextureAtlas.m
//  testnewopengl
//
//  Created by Schwietering, Jürgen on 22.03.14.
//  Copyright (c) 2014 Jürgen Schwietering. All rights reserved.
//

#import "TextureAtlas.h"
#import "GLKTextureInfo+setTextureImage.h"

@implementation TextureAtlas

- (id)initWithGeometry:(NSInteger)segmentsX segmentsY:(NSInteger)segmentsY
{
    self = [super init];
    if (self)
    {
        self.segments = CGPointMake(segmentsX, segmentsY);
    }
    return self;
}


- (CGContextRef) newBitmapRGBA8ContextFromImage:(CGImageRef)image
{
	CGContextRef context = NULL;
	CGColorSpaceRef colorSpace;
	uint32_t *bitmapData;

	size_t bitsPerPixel = 32;
	size_t bitsPerComponent = 8;
	size_t bytesPerPixel = bitsPerPixel / bitsPerComponent;

	size_t width = CGImageGetWidth(image);
	size_t height = CGImageGetHeight(image);

	size_t bytesPerRow = width * bytesPerPixel;
	size_t bufferLength = bytesPerRow * height;

	colorSpace = CGColorSpaceCreateDeviceRGB();

	if(!colorSpace) {
		NSLog(@"Error allocating color space RGB\n");
		return NULL;
	}
	bitmapData = (uint32_t *)malloc(bufferLength);

	if(!bitmapData) {
		NSLog(@"Error allocating memory for bitmap\n");
		CGColorSpaceRelease(colorSpace);
		return NULL;
	}

	context = CGBitmapContextCreate(bitmapData,
                                    width,
                                    height,
                                    bitsPerComponent,
                                    bytesPerRow,
                                    colorSpace,
                                    kCGBitmapByteOrderDefault|kCGImageAlphaPremultipliedLast);
	if(!context) {
		free(bitmapData);
		NSLog(@"Bitmap context not created");
	}
	CGColorSpaceRelease(colorSpace);
	return context;
}



/** user is responsible to free memory allocated here
 */
- (unsigned char *) convertUIImageToBitmapRGBA8:(UIImage *) image {

	CGImageRef imageRef = image.CGImage;

	// Create a bitmap context to draw the uiimage into
	CGContextRef context = [self newBitmapRGBA8ContextFromImage:imageRef];

	if(!context) {
		return NULL;
	}

	size_t width = CGImageGetWidth(imageRef);
	size_t height = CGImageGetHeight(imageRef);

	CGRect rect = CGRectMake(0, 0, width, height);

	CGContextDrawImage(context, rect, imageRef);

	unsigned char *bitmapData = (unsigned char *)CGBitmapContextGetData(context);

	size_t bytesPerRow = CGBitmapContextGetBytesPerRow(context);
	size_t bufferLength = bytesPerRow * height;

	unsigned char *newBitmap = NULL;

	if(bitmapData) {
		newBitmap = (unsigned char *)malloc(sizeof(unsigned char) * bytesPerRow * height);

		if(newBitmap)
        {
            memcpy(newBitmap,bitmapData,bufferLength);
		}
		free(bitmapData);
	} else
    {
		NSLog(@"Error getting bitmap pixel data\n");
	}

	CGContextRelease(context);

	return newBitmap;
}



- (void)setupTextures
{
    CGSize size = {TEXTUREMAPSIZE,TEXTUREMAPSIZE};
    UIGraphicsBeginImageContextWithOptions(size, NO, 1.0);

    CGRect rc = CGRectMake(0, 0, size.width, size.height);
    UIColor *col = [UIColor colorWithHue:0 saturation:0.0 brightness:1.0 alpha:0.9];
    [col setFill];
    UIRectFill(rc);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.texture = [GLKTextureInfo setTextureImage:image];
    image = nil;
}


- (void)updateTexture:(NSInteger)column
                  row:(NSInteger)row
                image:(UIImage *)image
{
    CGSize size = {TEXTUREMAPSIZE,TEXTUREMAPSIZE};
    GLint x,y;
    GLsizei w,h;

    if (column >=self.segments.x)
    {
        NSLog(@"Column exceeded");
        return;
    }
    if (column <0)
    {
        NSLog(@"Column negative!!!");
        return;
    }
    if (row >=self.segments.y)
    {
        NSLog(@"Row nr exceeded");
        return;
    }

    if (row < 0)
    {
        NSLog(@"Row negative");
        return;
    }
    x = (GLint)(column*TEXTUREMAPSIZE/self.segments.x);
    y = (GLint)(row*TEXTUREMAPSIZE/self.segments.y);
    w = size.width/self.segments.x;
    h = size.height/self.segments.y;

    CGSize targetSize = {w,h};
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, 1.0);

    [image drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)
            blendMode:kCGBlendModeNormal alpha:1.0];
    UIImage *finaleimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    unsigned char *data = [self convertUIImageToBitmapRGBA8:finaleimage];

    unsigned char *p = data;
    for (int i=0; i < w*h; i++)
    {
        unsigned char tmp=p[0];
        p[0] = p[2];
        p[2] = tmp;
        p += 4;
    }

    glBindTexture(GL_TEXTURE_2D, self.texture.name);
    glTexSubImage2D(GL_TEXTURE_2D, 0, x, y, finaleimage.size.width, finaleimage.size.height, GL_BGRA, GL_UNSIGNED_BYTE, data);
    free(data);
}


@end
