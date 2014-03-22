//
//  OpenGlError.m
//  testnewopengl
//
//  Created by Schwietering, Jürgen on 22.03.14.
//  Copyright (c) 2014 Jürgen Schwietering. All rights reserved.
//

#import "OpenGlError.h"
#import <GLKit/GLKit.h>

@implementation OpenGlError

+(BOOL)checkSingle
{

    NSString *errorString = NULL;

    switch( glGetError() )
    {
		case GL_NO_ERROR:
            return NO;
		case GL_INVALID_ENUM:
			errorString = @"GL_INVALID_ENUM";
			break;
		case GL_INVALID_VALUE:
			errorString = @"GL_INVALID_VALUE";
			break;
		case GL_INVALID_OPERATION:
			errorString = @"GL_INVALID_OPERATION";
			break;
		case GL_INVALID_FRAMEBUFFER_OPERATION:
			errorString = @"GL_INVALID_FRAMEBUFFER_OPERATION";
			break;
		case GL_STACK_OVERFLOW:
			errorString = @"GL_STACK_OVERFLOW";
			break;
		case GL_STACK_UNDERFLOW:
			errorString = @"GL_STACK_UNDERFLOW";
			break;
		case GL_OUT_OF_MEMORY:
			errorString = @"GL_OUT_OF_MEMORY";
			break;
		default:
			errorString = @"UNKNOWN";
			break;
    }
    NSLog(@"Error: %@",errorString);
    return YES;
}

+ (void)checkQueue
{
    while ([OpenGlError checkSingle])
        ;
}

@end
