//
//  CaptureSession.m
//  MandarinFlashierCards
//
//  Created by jay on 2/16/13.
//  Copyright (c) 2013 Jurgen Schwietering. All rights reserved.
//

#import "CaptureSession.h"
#import <ImageIO/ImageIO.h>

@implementation CaptureSession

- (id)init
{
    if ((self = [super init]))
    {
        [self setCaptureSession:[[AVCaptureSession alloc] init]];
        if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset352x288])
        {
            _captureSession.sessionPreset = AVCaptureSessionPreset352x288;
        }
        else
        {
            // Handle the failure.
        }

        [self addStillImageOutput];
        [self addContinuesAnalysis];
    }
    return self;
}

- (void)addVideoPreviewLayer
{
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:[self captureSession]];

    [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
}

- (void)focusAtPoint:(AVCaptureDevice *)device point:(CGPoint)point
{
    NSError *error;

    if ([device isFocusModeSupported:AVCaptureFocusModeAutoFocus] &&
            [device isFocusPointOfInterestSupported])
    {
        if ([device lockForConfiguration:&error])
        {
            [device setFocusPointOfInterest:point];
            [device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
            [device unlockForConfiguration];
        } else
        {
            NSLog(@"Error: %@", error);
        }
    }
}

/*
- (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates
{
    
    CGPoint pointOfInterest = CGPointMake(.5f, .5f);
    CGSize frameSize = [[self videoPreviewView] frame].size;
    
    AVCaptureVideoPreviewLayer *videoPreviewLayer = [self prevLayer];
    
    if ([[self prevLayer] isMirrored]) {
        viewCoordinates.x = frameSize.width - viewCoordinates.x;
    }
    
    if ( [[videoPreviewLayer videoGravity] isEqualToString:AVLayerVideoGravityResize] ) {
        pointOfInterest = CGPointMake(viewCoordinates.y / frameSize.height, 1.f - (viewCoordinates.x / frameSize.width));
    } else {
        CGRect cleanAperture;
        for (AVCaptureInputPort *port in [[[[self captureSession] inputs] lastObject] ports]) {
            if ([port mediaType] == AVMediaTypeVideo) {
                cleanAperture = CMVideoFormatDescriptionGetCleanAperture([port formatDescription], YES);
                CGSize apertureSize = cleanAperture.size;
                CGPoint point = viewCoordinates;
                
                CGFloat apertureRatio = apertureSize.height / apertureSize.width;
                CGFloat viewRatio = frameSize.width / frameSize.height;
                CGFloat xc = .5f;
                CGFloat yc = .5f;
                
                if ( [[videoPreviewLayer videoGravity] isEqualToString:AVLayerVideoGravityResizeAspect] ) {
                    if (viewRatio > apertureRatio) {
                        CGFloat y2 = frameSize.height;
                        CGFloat x2 = frameSize.height * apertureRatio;
                        CGFloat x1 = frameSize.width;
                        CGFloat blackBar = (x1 - x2) / 2;
                        if (point.x >= blackBar && point.x <= blackBar + x2) {
                            xc = point.y / y2;
                            yc = 1.f - ((point.x - blackBar) / x2);
                        }
                    } else {
                        CGFloat y2 = frameSize.width / apertureRatio;
                        CGFloat y1 = frameSize.height;
                        CGFloat x2 = frameSize.width;
                        CGFloat blackBar = (y1 - y2) / 2;
                        if (point.y >= blackBar && point.y <= blackBar + y2) {
                            xc = ((point.y - blackBar) / y2);
                            yc = 1.f - (point.x / x2);
                        }
                    }
                } else if ([[videoPreviewLayer videoGravity] isEqualToString:AVLayerVideoGravityResizeAspectFill]) {
                    if (viewRatio > apertureRatio) {
                        CGFloat y2 = apertureSize.width * (frameSize.width / apertureSize.height);
                        xc = (point.y + ((y2 - frameSize.height) / 2.f)) / y2;
                        yc = (frameSize.width - point.x) / frameSize.width;
                    } else {
                        CGFloat x2 = apertureSize.height * (frameSize.height / apertureSize.width);
                        yc = 1.f - ((point.x + ((x2 - frameSize.width) / 2)) / x2);
                        xc = point.y / frameSize.height;
                    }
                    
                }
                
                pointOfInterest = CGPointMake(xc, yc);
                break;
            }
        }
    }
    
    return pointOfInterest;
}
*/
- (void)addVideoInput
{
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (videoDevice)
    {
        NSError *error;
        AVCaptureDeviceInput *videoIn = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
        if (!error)
        {
            if ([_captureSession canAddInput:videoIn])
            {
                CGPoint focusPoint = CGPointMake(0.1, 0.5);
                [self focusAtPoint:videoDevice point:focusPoint];
                [_captureSession addInput:videoIn];
            }
            else
                NSLog(@"Couldn't add video input");
        }
        else
            NSLog(@"Couldn't create video input");
    }
    else
        NSLog(@"Couldn't create video capture device");
}

- (void)dealloc
{

    [[self captureSession] stopRunning];
}

- (void)addStillImageOutput
{
    [self setStillImageOutput:[[AVCaptureStillImageOutput alloc] init]];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [[self stillImageOutput] setOutputSettings:outputSettings];
    /*
     AVCaptureConnection *videoConnection = nil;
     for (AVCaptureConnection *connection in [[self stillImageOutput] connections]) {
     for (AVCaptureInputPort *port in [connection inputPorts]) {
     if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
     videoConnection = connection;
     break;
     }
     }
     if (videoConnection) {
     break;
     }
     }
     */
    [[self captureSession] addOutput:[self stillImageOutput]];
}

- (void)captureStillImage
{
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in [[self stillImageOutput] connections])
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo])
            {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection)
        {
            break;
        }
    }

    NSLog(@"about to request a capture from: %@", [self stillImageOutput]);
    [[self stillImageOutput] captureStillImageAsynchronouslyFromConnection:videoConnection
                                                         completionHandler:^(CMSampleBufferRef imageSampleBuffer, NSError *error)
                                                         {
                                                             _exifAttachments = CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
                                                             if (_exifAttachments)
                                                             {
                                                                 NSLog(@"attachments: %@", _exifAttachments);
                                                             } else
                                                             {
                                                                 NSLog(@"no attachments");
                                                             }
                                                             NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
                                                             UIImage *image = [[UIImage alloc] initWithData:imageData];
                                                             [self setStillImage:image];
                                                             [[NSNotificationCenter defaultCenter] postNotificationName:kImageCapturedSuccessfully object:nil];
                                                         }];
}

- (CGImageRef)imageRefFromSampleBuffer:(CMSampleBufferRef)sampleBuffer
{

    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    uint8_t *baseAddress = (uint8_t *) CVPixelBufferGetBaseAddress(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef newImage = CGBitmapContextCreateImage(context);
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return newImage;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    static int dropCounter = 0;
    dropCounter++;
    if (dropCounter >= 5)
    {
        dropCounter = 0;

        // need to optimize this for the small window we use
        CGImageRef tempThumbnail = [self imageRefFromSampleBuffer:sampleBuffer];

        dispatch_async(dispatch_get_main_queue(), ^
        {
            UIImage *image = [[UIImage alloc] initWithCGImage:tempThumbnail scale:1.0 orientation:UIImageOrientationRight];
            CFRelease(tempThumbnail);
            [_delegate picturePreview:image];
        });
    }
}

- (void)addContinuesAnalysis
{
    _continuesImageOutput = [[AVCaptureVideoDataOutput alloc] init];
    [_continuesImageOutput setAlwaysDiscardsLateVideoFrames:YES];
    _continuesImageOutput.videoSettings =
            @{(NSString *) kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA)};
    /*
     AVCaptureConnection *conn = [_continuesImageOutput connectionWithMediaType:AVMediaTypeVideo];
    
     if (conn.supportsVideoMinFrameDuration)
     conn.videoMinFrameDuration = CMTimeMake(1,2);
     else
     _continuesImageOutput.minFrameDuration = CMTimeMake(1,2);
     
     if (conn.supportsVideoMaxFrameDuration)
     conn.videoMaxFrameDuration = CMTimeMake(1,2);
     */
    [_captureSession addOutput:_continuesImageOutput];
    dispatch_queue_t queue = dispatch_queue_create("VideoQueue", NULL);
    [_continuesImageOutput setSampleBufferDelegate:self queue:queue];
    //dispatch_release(queue);
}

@end
