//
//  OpenGlError.h
//  testnewopengl
//
//  Created by Schwietering, Jürgen on 22.03.14.
//  Copyright (c) 2014 Jürgen Schwietering. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OpenGlError : NSObject

+ (BOOL)checkSingle;
+ (void)checkQueue;
@end
