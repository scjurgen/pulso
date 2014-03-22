//
//  GLDrawLine.h
//  testnewopengl
//
//  Created by Schwietering, Jürgen on 22.03.14.
//  Copyright (c) 2014 Jürgen Schwietering. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface GLDrawLine : NSObject

- (void)setup;

- (void)setRay:(GLKVector3)eye
     direction:(GLKVector3)endPoint;

- (void)update:(GLKMatrix4)projectionMatrix
modelViewMatrix:(GLKMatrix4)modelViewMatrix;

@end
