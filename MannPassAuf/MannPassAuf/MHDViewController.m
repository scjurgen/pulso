//
//  MHDViewController.m
//  MannPassAuf
//
//  Created by Schwietering, Jürgen on 22.03.14.
//  Copyright (c) 2014 Schwietering, Jürgen. All rights reserved.
//

#import "MHDViewController.h"
#import <ImageIO/ImageIO.h>
#import "DataLoader/MHDPublicInterface.h"
#import "DataLoader/DataTypes/MHDArticleList.h"
#import "DataLoader/DataTypes/MHDArticle.h"

NSString *kCellID = @"SetDetailsViewCellID";


@interface MHDViewController ()
@property(nonatomic, retain)UIView *sideMenu;
@property(nonatomic, retain)NSMutableArray *articlesArray;
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

    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 30, 100, 40)];
    [menuButton addTarget:self action:@selector(menuButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    [menuButton setTitle:@"💉" forState:UIControlStateNormal];
    menuButton.enabled = YES;
    [self.view addSubview:menuButton];
    
    [self setupSideMenu];
}

- (void)setupSideMenu {
    CGFloat advanceY = 44.0;
    CGFloat buttonHeight=44.0;
    _sideMenu = [[UIView alloc] initWithFrame:CGRectMake(-50, 0, 50, self.view.frame.size.height)];
    _sideMenu.backgroundColor = [UIColor darkGrayColor];
    _sideMenu.alpha = 0.9;
    [self.view addSubview:_sideMenu];
    CGFloat y=0.0;
    
    UIButton *angry = [[UIButton alloc] initWithFrame:CGRectMake(0, y+=advanceY, 50, buttonHeight)];
    [angry addTarget:self action:@selector(moodButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    angry.tag = 1;
    [angry setTitle:@"😠" forState:UIControlStateNormal];
    [_sideMenu addSubview:angry];
    
    UIButton *confused = [[UIButton alloc] initWithFrame:CGRectMake(0, y+=advanceY, 50, buttonHeight)];
    [confused addTarget:self action:@selector(moodButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    confused.tag = 2;
    [confused setTitle:@"😵" forState:UIControlStateNormal];
    [_sideMenu addSubview:confused];
    
    UIButton *cool = [[UIButton alloc] initWithFrame:CGRectMake(0, y+=advanceY, 50, buttonHeight)];
    [cool addTarget:self action:@selector(moodButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    cool.tag = 3;
    [cool setTitle:@"😎" forState:UIControlStateNormal];
    [_sideMenu addSubview:cool];
    
    UIButton *happy = [[UIButton alloc] initWithFrame:CGRectMake(0, y+=advanceY, 50, buttonHeight)];
    [happy addTarget:self action:@selector(moodButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    happy.tag = 4;
    [happy setTitle:@"😃" forState:UIControlStateNormal];
    [_sideMenu addSubview:happy];
    
    UIButton *neutral = [[UIButton alloc] initWithFrame:CGRectMake(0, y+=advanceY, 50, buttonHeight)];
    [neutral addTarget:self action:@selector(moodButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    neutral.tag = 5;
    [neutral setTitle:@"😑" forState:UIControlStateNormal];
    [_sideMenu addSubview:neutral];
    
    UIButton *sad = [[UIButton alloc] initWithFrame:CGRectMake(0, y+=advanceY, 50, buttonHeight)];
    [sad addTarget:self action:@selector(moodButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    sad.tag = 6;
    [sad setTitle:@"😢" forState:UIControlStateNormal];
    [_sideMenu addSubview:sad];
    
    UIButton *shocked = [[UIButton alloc] initWithFrame:CGRectMake(0, y+=advanceY, 50, buttonHeight)];
    [shocked addTarget:self action:@selector(moodButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    shocked.tag = 7;
    [shocked setTitle:@"😱" forState:UIControlStateNormal];
    [_sideMenu addSubview:shocked];
    
    UIButton *smile = [[UIButton alloc] initWithFrame:CGRectMake(0, y+=advanceY, 50, buttonHeight)];
    [smile addTarget:self action:@selector(moodButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    smile.tag = 8;
    [smile setTitle:@"😄" forState:UIControlStateNormal];
    [_sideMenu addSubview:smile];
    
    UIButton *tongue = [[UIButton alloc] initWithFrame:CGRectMake(0, y+=advanceY, 50, buttonHeight)];
    [tongue addTarget:self action:@selector(moodButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    tongue.tag = 9;
    [tongue setTitle:@"😛" forState:UIControlStateNormal];
    [_sideMenu addSubview:tongue];
    
    UIButton *wondering = [[UIButton alloc] initWithFrame:CGRectMake(0, y+=advanceY, 50, buttonHeight)];
    [wondering addTarget:self action:@selector(moodButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    wondering.tag = 10;
    [wondering setTitle:@"😳" forState:UIControlStateNormal];
    [_sideMenu addSubview:wondering];
}

- (void)moodButtonAction:(id)sender {
    UIButton *btn = sender;
    
    MHDMoods moods;
    switch (btn.tag) {
        case 1:
            moods = 0;
            break;
        case 2:
            moods = 1;
            break;
        case 3:
            moods = 2;
            break;
        case 4:
            moods = 3;
            break;
        case 5:
            moods = 4;
            break;
        case 6:
            moods = 5;
            break;
        case 7:
            moods = 6;
            break;
        case 8:
            moods = 7;
            break;
        case 9:
            moods = 8;
            break;
        case 10:
            moods = 9;
            break;
        default:
            break;
    }
    
    
    
    [MHDPublicInterface getArticlesForMood:moods
                                 onSuccess:^(id resultSuccess) {
                                     [self processResultForList:(MHDArticleList *)resultSuccess];
                                 }
                                 onFailure:^(id resultFailure) {
                                     
                                 }];
    
    
    

}

- (void)processResultForList:(MHDArticleList *)list {
    _articlesArray = [[NSMutableArray alloc] init];
    for (NSString *articleId in list.articlesList) {
        
        [MHDPublicInterface getArticleForId:articleId
                                  onSuccess:^(id resultSuccess) {
                                      MHDArticle *article = (MHDArticle *)resultSuccess;
                                      
                                      [_articlesArray addObject:article];
                                      [self.newsCollectionView reloadData];
                                  }
                                  onFailure:^(id resultFailure) {
                                      
                                  }];
        
    }
    
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
     return [_articlesArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    SetDetailsViewCell *cell = [_newsCollectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];

    MHDArticle *article = [_articlesArray objectAtIndex:indexPath.row];
    
    
    
    
    NSArray *mediaArr;
    NSDictionary *medias;
    NSArray *pictureArr;
    NSDictionary *pictures;
    
    if (article[@"medias"]) mediaArr = article[@"medias"];
    if (mediaArr[0]) medias = mediaArr[0];
    if (medias[@"references"]) pictureArr = medias[@"references"];
    if (pictureArr[0]) pictures = pictureArr[0];
    if (pictures[@"url"]) {
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:pictures[@"url"]]];
            if ( data == nil )
                return;
            dispatch_async(dispatch_get_main_queue(), ^{
                // WARNING: is the cell still using the same data by this point??
                cell.newsImageView.image = [UIImage imageWithData: data];
                
                cell.titleLabel.text = article[@"title"];
                cell.articleView.text = article[@"content"];
                
            });
        });
    }
    
    return cell;

    
}

- (void)getImage:(NSString *)url {
    
    
}

@end
