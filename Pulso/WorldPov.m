//
//  WordlPov.m
//  testnewopengl
//
//  Created by Schwietering, Jürgen on 22.03.14.
//  Copyright (c) 2014 Jürgen Schwietering. All rights reserved.
//

#import "MHDCardsWorld.h"
#import "WorldPov.h"

@implementation WorldPov


+ (GLKVector3)getMouseRayProjection:(CGPoint)touch
                             window:(CGSize)window
                               view:(GLKMatrix4)view
                         projection:(GLKMatrix4)projection
{
    GLKVector4 rayClip = GLKVector4Make(2.0f * touch.x / window.width - 1.0f,
        1.0f - 2.0f*touch.y/window.height,
        -1.0f,
        1.0f);
    bool invertible;
    GLKMatrix4 inverseProjection = GLKMatrix4Invert(projection, &invertible);
    GLKVector4 rayEye = GLKMatrix4MultiplyVector4(inverseProjection, rayClip);

    rayClip.z = -1.0f;
    rayClip.w = 0.0f;

    GLKMatrix4 inverseView =  GLKMatrix4Invert(view, &invertible);
    GLKVector4 rayWorld4D = GLKMatrix4MultiplyVector4(inverseView, rayEye);
    GLKVector3 rayWorld = {rayWorld4D.x, rayWorld4D.y, rayWorld4D.z};
    GLKVector3 rayNormalized = GLKVector3Normalize(rayWorld);
    NSLog(@"\nEye:  [%.6f %.6f %.6f %.6f]\nRayworld:  [%.6f %.6f %.6f]\nRayworldN:  [%.6f %.6f %.6f]",
          rayEye.v[0],rayEye.v[1],rayEye.v[2],rayEye.v[3],
          rayWorld.v[0],rayWorld.v[1],rayWorld.v[2],
            rayNormalized.v[0],rayNormalized.v[1],rayNormalized.v[2]);
    return rayNormalized;
}
@end
