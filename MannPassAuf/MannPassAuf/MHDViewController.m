//
//  MHDViewController.m
//  MannPassAuf
//
//  Created by Schwietering, Jürgen on 22.03.14.
//  Copyright (c) 2014 Schwietering, Jürgen. All rights reserved.
//

#import "MHDViewController.h"
#import <ImageIO/ImageIO.h>

NSString *kCellID = @"SetDetailsViewCellID";


@interface MHDViewController ()

@end

@implementation MHDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UINib *cellNib = [UINib nibWithNibName:@"SetDetailsViewCell_iPhone" bundle:nil];
    [_newsCollectionView registerNib:cellNib forCellWithReuseIdentifier:kCellID];

	// Do any additional setup after loading the view, typically from a nib.
    UIView *v = [self view];
    _captureSession = [[CaptureSession alloc] init];
    _captureSession.delegate = self;

    [_captureSession addVideoInput];
    [_captureSession addVideoPreviewLayer];

    CGRect layerRect = v.layer.bounds;
    [_captureSession.previewLayer setBounds:layerRect];
    [_captureSession.previewLayer setPosition:CGPointMake(CGRectGetMidX(layerRect),
                                                          CGRectGetMidY(layerRect))];
    [v.layer insertSublayer:_captureSession.previewLayer atIndex:0];
//    overlayImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlaymask"]];
//    [overlayImageView setFrame:CGRectMake(0, 0, v.bounds.size.width, v.bounds.size.height)];


}

- (void)viewWillAppear:(BOOL)animated
{
    [[_captureSession captureSession] startRunning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[_captureSession captureSession] stopRunning];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveImage:(UIImage *)image pad:(NSString *)pad
{
    NSData *imgData = UIImagePNGRepresentation(image);
    NSString *fname = [NSString stringWithFormat:@"Documents/IMG_%ld_%@.png", time(0L), pad];
    NSString *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:fname];
    BOOL result = [imgData writeToFile:pngPath atomically:YES];
    NSLog(@"Png written to: %@ (%d)", pngPath, result);
}


- (void)picturePreview:(UIImage *)image
{
    //self.sampledImage.image = image;
//    if (!squareBox)
//    {
//        squareBox = [[CVSquareTextBoxes alloc] init];
//    }
//    if ([squareBox analyseImage:[self preCrop:image]])
//    {
//        sampledImage.image = [squareBox resultBoxImage];
//    }
}

- (void)analyseAction
{
    [_captureSession captureStillImage];
}

#pragma mark - Collection View

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
     return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    SetDetailsViewCell *cell = [_newsCollectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];

    cell.titleLabel.text = @"Titel ist hier";
    cell.newsImageView.image = [UIImage imageNamed:@"test1.png"];
    cell.articleView.text = @"hallo world";
    return cell;
}


@end
