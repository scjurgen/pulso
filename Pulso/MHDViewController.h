//
//  MHDViewController.h
//  Pulso
//
//  Created by Schwietering, Jürgen on 22.03.14.
//  Copyright (c) 2014 Schwietering, Jürgen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "CaptureSession.h"


@interface MHDViewController : GLKViewController <CaptureSessionDelegate>

@property (strong, nonatomic) CaptureSession *captureSession;


@property (weak, nonatomic) IBOutlet UIWebView *contentWebView;


- (IBAction)modelAction:(id)sender;
- (IBAction)closeWebView:(id)sender;
- (IBAction)moodAction:(id)sender;


@end
