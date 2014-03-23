//
//  MHDViewController.h
//  MannPassAuf
//
//  Created by Schwietering, Jürgen on 22.03.14.
//  Copyright (c) 2014 Schwietering, Jürgen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaptureSession.h"

@interface MHDViewController : UIViewController <CaptureSessionDelegate>

@property (strong, nonatomic) CaptureSession *captureSession;
@property (weak, nonatomic) IBOutlet UIImageView *sampledImage;

@end
