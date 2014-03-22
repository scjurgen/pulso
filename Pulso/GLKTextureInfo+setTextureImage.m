//
//  GLKTextureInfo+setTextureImage.m
//  testnewopengl
//
//  Created by Schwietering, Jürgen on 22.03.14.
//  Copyright (c) 2014 Jürgen Schwietering. All rights reserved.
//

#import "GLKTextureInfo+setTextureImage.h"

@implementation GLKTextureInfo (setTextureImage)

+ (GLKTextureInfo *)setTextureImage:(UIImage *)image
{
    NSError *error;
    GLKTextureInfo *texInfo = [GLKTextureLoader textureWithCGImage:image.CGImage options:nil error:&error];
    if (error) {
        NSLog(@"Error loading texture from image: %@",error);
    }
    return texInfo;
}


@end
