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
@property(nonatomic, retain)UIView *sideMenu;
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


    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 30, 100, 20)];
    [menuButton addTarget:self action:@selector(menuButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    [menuButton setTitle:@"I feel..." forState:UIControlStateNormal];
    menuButton.enabled = YES;
    [self.view addSubview:menuButton];
    
    [self setupSideMenu];
}

- (void)setupSideMenu {
    
    _sideMenu = [[UIView alloc] initWithFrame:CGRectMake(-50, 0, 50, self.view.frame.size.height)];
    _sideMenu.backgroundColor = [UIColor darkGrayColor];
    _sideMenu.alpha = 0.5;
    [self.view addSubview:_sideMenu];
    
    UIButton *angry = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    [angry addTarget:self action:@selector(moodButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    angry.tag = 1;
    [angry setTitle:@"angry" forState:UIControlStateNormal];
    [_sideMenu addSubview:angry];
    
    UIButton *confused = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 50, 20)];
    [confused addTarget:self action:@selector(moodButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    confused.tag = 2;
    [confused setTitle:@"confused" forState:UIControlStateNormal];
    [_sideMenu addSubview:confused];
    
    UIButton *cool = [[UIButton alloc] initWithFrame:CGRectMake(0, 40, 50, 20)];
    [cool addTarget:self action:@selector(moodButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    cool.tag = 3;
    [cool setTitle:@"cool" forState:UIControlStateNormal];
    [_sideMenu addSubview:cool];
    
    UIButton *happy = [[UIButton alloc] initWithFrame:CGRectMake(0, 60, 50, 20)];
    [happy addTarget:self action:@selector(moodButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    happy.tag = 4;
    [happy setTitle:@"happy" forState:UIControlStateNormal];
    [_sideMenu addSubview:happy];
    
    UIButton *neutral = [[UIButton alloc] initWithFrame:CGRectMake(0, 80, 50, 20)];
    [neutral addTarget:self action:@selector(moodButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    neutral.tag = 5;
    [neutral setTitle:@"neutral" forState:UIControlStateNormal];
    [_sideMenu addSubview:neutral];
    
    UIButton *sad = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 50, 20)];
    [sad addTarget:self action:@selector(moodButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    sad.tag = 6;
    [sad setTitle:@"sad" forState:UIControlStateNormal];
    [_sideMenu addSubview:sad];
    
    UIButton *shocked = [[UIButton alloc] initWithFrame:CGRectMake(0, 120, 50, 20)];
    [shocked addTarget:self action:@selector(moodButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    shocked.tag = 7;
    [shocked setTitle:@"shocked" forState:UIControlStateNormal];
    [_sideMenu addSubview:shocked];
    
    UIButton *smile = [[UIButton alloc] initWithFrame:CGRectMake(0, 140, 50, 20)];
    [smile addTarget:self action:@selector(moodButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    smile.tag = 8;
    [smile setTitle:@"smile" forState:UIControlStateNormal];
    [_sideMenu addSubview:smile];
    
    UIButton *tongue = [[UIButton alloc] initWithFrame:CGRectMake(0, 160, 50, 20)];
    [tongue addTarget:self action:@selector(moodButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    tongue.tag = 9;
    [tongue setTitle:@"tongue" forState:UIControlStateNormal];
    [_sideMenu addSubview:tongue];
    
    UIButton *wondering = [[UIButton alloc] initWithFrame:CGRectMake(0, 180, 50, 20)];
    [wondering addTarget:self action:@selector(moodButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    wondering.tag = 10;
    [wondering setTitle:@"wondering" forState:UIControlStateNormal];
    [_sideMenu addSubview:wondering];
}

- (void)moodButtonAction:(id)sender {
    
}

- (void)menuButtonPushed:(id)sender {
    [(UIButton*)sender setEnabled:NO];
    [(UIButton*)sender setAlpha:0];
    [UIView animateWithDuration:0.3
                     animations:^{
                         if (_sideMenu.frame.origin.x != 0) {
                             _sideMenu.frame = CGRectMake(0, 0, _sideMenu.frame.size.width, _sideMenu.frame.size.height);
                         }
                         else {
                             _sideMenu.frame = CGRectMake(-50, 0, _sideMenu.frame.size.width, _sideMenu.frame.size.height);
                         }
                         
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [(UIButton*)sender setEnabled:YES];
                             [(UIButton*)sender setAlpha:1];
                         }
                     }];
    
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
