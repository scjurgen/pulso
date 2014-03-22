//
//  WordlPov.h
//  testnewopengl
//
//  Created by Schwietering, Jürgen on 22.03.14.
//  Copyright (c) 2014 Jürgen Schwietering. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorldPov : NSObject
// must be atomic, they could be changed realtime

@property (assign,atomic) float rotationX, rotationY;
@property (assign,atomic) float panX, panY;
@property (assign,atomic) float zoom;


+ (GLKVector3)getMouseRayProjection:(CGPoint)touch
                             window:(CGSize)window
                               view:(GLKMatrix4)view
                         projection:(GLKMatrix4)projection;
@end
