//
//  CaptureSession.h
//  MandarinFlashierCards
//
//  Created by jay on 2/16/13.
//  Copyright (c) 2013 Jurgen Schwietering. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>

#define kImageCapturedSuccessfully @"imageCapturedSuccessfully"

@protocol CaptureSessionDelegate <NSObject>

- (void)picturePreview:(UIImage *)image;

@end

@interface CaptureSession : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (strong, nonatomic) id <CaptureSessionDelegate> delegate;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@property (strong, nonatomic) AVCaptureVideoDataOutput *continuesImageOutput;
@property (strong, nonatomic) UIImage *stillImage;
@property (assign) CFDictionaryRef exifAttachments;

- (void)addStillImageOutput;

- (void)captureStillImage;

- (void)addVideoPreviewLayer;

- (void)addVideoInput;

- (void)addContinuesAnalysis;

@end
