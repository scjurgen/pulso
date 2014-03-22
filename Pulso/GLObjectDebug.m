//
//  GLObjectDebug.m
//  testnewopengl
//
//  Created by Schwietering, Jürgen on 22.03.14.
//  Copyright (c) 2014 Jürgen Schwietering. All rights reserved.
//

#import "GLObjectDebug.h"
@implementation GLObjectDebug


+ (NSString *)matrixAsString:(GLKMatrix4)m
{
    NSString *result = @"";
    for (int y=0; y < 4; y++)
    {
        result = [result stringByAppendingFormat:@"\t|%+3.6f\t%+3.6f\t%+3.6f\t%+3.6f|\n", m.m[y*4+0], m.m[y*4+1], m.m[y*4+2], m.m[y*4+3] ];
    }
    return result;
}


+ (NSString *)vector4AsString:(GLKVector4)v
{
    return [NSString stringWithFormat:@"[x=%3.6f y=%3.6f z=%3.6f w=%3.6f]", v.x, v.y, v.z, v.w];
}


+ (NSString *)vector3AsString:(GLKVector3)v
{
    return [NSString stringWithFormat:@"[x=%3.6f y=%3.6f z=%3.6f]", v.x, v.y, v.z];
}


@end
