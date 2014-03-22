//
//  MHDViewController.m
//  Pulso
//
//  Created by Schwietering, Jürgen on 22.03.14.
//  Copyright (c) 2014 Schwietering, Jürgen. All rights reserved.
//

#import "MHDViewController.h"


#import <OpenGLES/EAGL.h>
#import "MHDCardsWorld.h"
#import "WebNewsEngine.h"

char *testImages[] = {
    "1x1.jpg", "1x2.jpg", "1x3.jpg", "1x4.jpg", "1x5.jpg", "2x1.jpg", "2x2.jpg", "2x3.jpg",
    "2x4.jpg", "2x5.jpg", "2x6.jpg", "2x7.jpg", "2x8.jpg", "2x9.jpg", "3x1.jpg", "3x2.jpg",
    "3x3.jpg", "3x4.jpg", "3x5.jpg", "3x6.jpg", "3x7.jpg", "3x8.jpg", "4x1.png", "5x1.jpg",
    "5x2.jpg", "5x3.jpg", "5x4.jpg", "5x5.jpg", "5x6.jpg"
};


//
@interface MHDViewController () {
    float _rotationX,_rotationY;
    float _lastRotationX, _lastRotationY;
    float _currentZoom;
    float _lastZoom;
    float _maxZoom,_minZoom;
    CGPoint relaseVelocity;
    CGFloat pinchVelocity;

    int currentModel;
    CGRect originalOpenRect;

    WebNewsEngine *webNewsEngine;
}

@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) MHDCardsWorld *cardsWorld;

@end

@implementation MHDViewController

- (void)applyPov
{
    self.cardsWorld.worldPov.rotationX = _rotationX;
    self.cardsWorld.worldPov.rotationY = _rotationY;
    self.cardsWorld.worldPov.panX = _rotationX;
    self.cardsWorld.worldPov.panY = _rotationY;
    self.cardsWorld.worldPov.zoom = _currentZoom;

}

- (void)viewDidLoad
{

    webNewsEngine = [[WebNewsEngine alloc] init];
    [webNewsEngine defineTemplate:@"NewsScreen"];

//    nr = [[NewsReaderFromGuardian alloc] init];
//    [nr downloadJSONFromURL:^(NSDictionary *dict) {
//        NSLog(@"Fully Loaded");
//    } onFailure:^(NSError *error) {
//        NSLog(@"Empty... sigh");
//    }];

    _maxZoom = 10.0;
    _minZoom = 0.1;
    _currentZoom = _lastZoom = 10.0;
    currentModel = 1;


    [super viewDidLoad];
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }

    self.cardsWorld = [[MHDCardsWorld alloc] init];

    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    [self setupGL];
    [self applyPov];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    [self.view addGestureRecognizer:tapRecognizer];
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
    [self.view addGestureRecognizer:panRecognizer];
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchFrom:)];
    [self.view addGestureRecognizer:pinchRecognizer];
    [_contentWebView loadHTMLString:[webNewsEngine createHtml] baseURL:nil];
}


// Add new method to file (anywhere)
- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer {
    static CGPoint locStart;
    switch (recognizer.state)
    {
        case UIGestureRecognizerStateBegan:
            locStart = [recognizer locationInView:recognizer.view];
            break;
        case UIGestureRecognizerStateEnded:
            _lastRotationX = _rotationX;
            _lastRotationY = _rotationY;
            relaseVelocity = [recognizer velocityInView:recognizer.view];
            [self applyPov];

            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint touchLocation = [recognizer locationInView:recognizer.view];
            _rotationX = _lastRotationX+(locStart.x-touchLocation.x)/100.0;
            _rotationY = _lastRotationY+(touchLocation.y-locStart.y)/100.0;
            [self applyPov];
        }
            break;
        default:
            break;
    }
}

- (float)clampFloat:(float)invalue minValue:(float)minValue maxValue:(float)maxValue
{
    if (invalue < minValue) return minValue;
    if (invalue > maxValue) return maxValue;
    return invalue;
}

// Add new method to file (anywhere)
- (void)handlePinchFrom:(UIPinchGestureRecognizer *)recognizer {
    switch(recognizer.state)
    {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:
            _currentZoom = [self clampFloat:_lastZoom/recognizer.scale minValue:_minZoom maxValue:_maxZoom];
            [self applyPov];
            break;
        case UIGestureRecognizerStateEnded:
            _currentZoom = [self clampFloat:_lastZoom/recognizer.scale minValue:_minZoom maxValue:_maxZoom];
            _lastZoom = _currentZoom;
            pinchVelocity = [recognizer velocity];
            NSLog(@"%f", pinchVelocity);
            [self applyPov];
            break;
        default:
            break;
    }
}


// Add new method to file (anywhere)
- (void)handleTapFrom:(UITapGestureRecognizer *)recognizer {
    CGPoint locStart = [recognizer locationInView:recognizer.view];
    switch(recognizer.state)
    {
        case UIGestureRecognizerStateRecognized:
        {
            CGPoint p[4];
            int ret = [self.cardsWorld tapWorld:self.view.bounds.size
                                              x:locStart.x
                                              y:locStart.y
                                              p:p];
            if (ret != -1)
            {

                CGPoint pt1 = CGPointMake((p[0].x/2.0+0.5)*self.view.frame.size.width,
                                          (p[0].y/2.0+0.5)*self.view.frame.size.height);
                CGPoint pt2 = CGPointMake((p[3].x/2.0+0.5)*self.view.frame.size.width,
                                          (p[3].y/2.0+0.5)*self.view.frame.size.height);
                originalOpenRect.origin.x = pt1.x;
                originalOpenRect.origin.y = (self.view.frame.size.height-pt2.y);
                originalOpenRect.size.width = pt2.x-pt1.x;
                originalOpenRect.size.height = pt2.y-pt1.y;
                //                    NSLog(@"[%f %f]->[%f %f] [%@]", locStart.x, locStart.y,
                //                          originalOpenRect.origin.x, originalOpenRect.origin.y,
                //                          NSStringFromCGRect(self.view.bounds));
                self.contentWebView.frame = originalOpenRect;
                self.contentWebView.alpha = 0.0;
                CGRect targetRect = CGRectInset(self.view.frame,-20,-20);
                [UIView animateWithDuration:0.5 animations:^{
                    self.contentWebView.frame = targetRect;
                    self.contentWebView.alpha = 0.9;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.2 animations:^{
                        self.contentWebView.frame = CGRectInset(self.view.frame, 5,5);
                        self.contentWebView.alpha = 0.9;

                    }];
                }];
            }
            else
            {
                self.contentWebView.alpha = 0.0;
            }
        }
        default:
            break;
    }
}


- (void)dealloc
{
    [self tearDownGL];

    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;

        [self tearDownGL];

        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }
}
#pragma mark - GLKView and GLKViewController delegate methods

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    [self.cardsWorld setup:10 segmentsY:5];
}

- (void)update
{
    [self.cardsWorld update:self.view.bounds.size];
    [self applyDamping];

    static int i=0;
    i++;
    if (i==15)
    {

        NSString *name = [NSString stringWithFormat:@"TestImages/%s",testImages[rand()%(sizeof(testImages)/sizeof(char*))]];
        UIImage *image =  [UIImage imageNamed:name];
        [self.cardsWorld.textureAtlas updateTexture:rand()%12 row:rand()%7  image:image ];
        i = 0;
    }
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    [self.cardsWorld tearDown];
}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [self.cardsWorld drawView];
}


#pragma mark Point Of View transformation

- (void)applyDamping
{
    if (relaseVelocity.x!=0.0)
    {
        _lastRotationX -= relaseVelocity.x/2000.0;
        _lastRotationY += relaseVelocity.y/2000.0;
        _rotationX = _lastRotationX;
        _rotationY = _lastRotationY;
        relaseVelocity.x/=1.2;
        relaseVelocity.y/=1.2;
        if ((fabs(relaseVelocity.x)<2.0) && (fabs(relaseVelocity.y)<2.0))
        {
            relaseVelocity.x = 0.0;
            relaseVelocity.y = 0.0;
        }

        [self applyPov];

    }
}


- (IBAction)modelAction:(id)sender {
    currentModel++;
    currentModel = currentModel %2;
    switch(currentModel)
    {
        case 0:
            [self.cardsWorld.cards orderAsTable];
            break;
        case 1:
            [self.cardsWorld.cards orderAsSpiral:10.0];
            break;
    }
}

- (IBAction)closeWebView:(id)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        self.contentWebView.frame = originalOpenRect;
        self.contentWebView.alpha = 0.0;
    } completion:^(BOOL finished) {
    }];
}

@end
