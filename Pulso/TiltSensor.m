//
//  TiltSensor.m
//  MandarinFlashierCards
//
//  Created by Jürgen Schwietering on 1/31/12.
//  Copyright (c) 2012 Jurgen Schwietering. All rights reserved.
//

// WARNING: WE WILL NEED TO REPLACE IN THE FUTURE WITH CORE MOTION
// get data from acceleration sensor
// filter data with a simple lowpass (it is noisy usually)
// this will drain a bit faster the battery

#import "TiltSensor.h"
#import <CoreMotion/CoreMotion.h>


@interface TiltSensor ()
{
    NSTimer *moveAround;
    CGRect orgFrame;
    CMMotionManager *motionManager;
    CMAttitude *orgAttitude;
    BOOL resetAttitude;
}
@end

@implementation TiltSensor


+ (id)handler
{
    static TiltSensor *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
         sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


- (id)init
{
    self=[super init];
    if (self)
    {
    }
    return self;
}



- (void)setMotionHandler:(CGRect)referenceFrame
{
    resetAttitude = YES;
    orgFrame = referenceFrame;
    
    motionManager = [[CMMotionManager alloc] init];
    motionManager.showsDeviceMovementDisplay = YES;
    motionManager.deviceMotionUpdateInterval = 1.0/60.0;
    
    CMDeviceMotionHandler  motionHandler = ^ (CMDeviceMotion *motion, NSError *error)
    {
        CMAttitude *attitude = motionManager.deviceMotion.attitude;
        
        if (resetAttitude)
        {
            resetAttitude=NO;
            orgAttitude=attitude;
        }
        CGRect hisFrame=orgFrame;
        hisFrame.origin.x-=(orgAttitude.pitch-attitude.pitch)*500;
        hisFrame.origin.y+=(orgAttitude.roll-attitude.roll)*350;
        //_moveMeLabel.frame=hisFrame;
    };
    [motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXTrueNorthZVertical toQueue:[NSOperationQueue currentQueue] withHandler:motionHandler];
}


@end
