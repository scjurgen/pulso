//
//  GLObjectDebug.h
//  testnewopengl
//
//  Created by Schwietering, Jürgen on 22.03.14.
//  Copyright (c) 2014 Jürgen Schwietering. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface GLObjectDebug : NSObject

+ (NSString *)matrixAsString:(GLKMatrix4)m;
+ (NSString *)vector4AsString:(GLKVector4)v;
+ (NSString *)vector3AsString:(GLKVector3)v;

@end
