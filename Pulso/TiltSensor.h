//
//  TiltSensor.h
//  MandarinFlashierCards
//
//  Created by Jürgen Schwietering on 1/31/12.
//  Copyright (c) 2012 Jurgen Schwietering. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

@interface TiltSensor : NSObject <UIAccelerometerDelegate>

+ (id)handler;

- (void)setMotionHandler:(CGRect)referenceFrame;

@end
