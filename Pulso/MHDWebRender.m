//
//  MHDWebRender.m
//  Pulso
//
//  Created by Schwietering, Jürgen on 23.03.14.
//  Copyright (c) 2014 Schwietering, Jürgen. All rights reserved.
//

#import "MHDWebRender.h"
#import "WebNewsEngine.h"
#import "MHDHtmlFromArticle.h"


@interface MHDWebRender()
{
    WebNewsEngine *webNewsEngine;
    MHDImageBlock successBlock;
}

@end

@implementation MHDWebRender

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}


- (void)render:(NSString *)articleId
      andBlock:(MHDImageBlock)block
{
    successBlock = block;
    self.delegate = self;
    webNewsEngine = [[WebNewsEngine alloc] init];
    [webNewsEngine createHtmlUsingBlock:^(MHDArticle *article, NSString *htmlstring)
     {
         NSString *str = [NSString stringWithFormat:@"http://www.nerdware.net/hackathon/article.php?id=%@",article[@"identifier"]];
         NSURL *url = [NSURL URLWithString:str];
         NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
         [self loadRequest:request];

     }];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGSize thumbsize = webView.frame.size;

    UIGraphicsBeginImageContext(thumbsize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat scalingFactor = thumbsize.width/webView.frame.size.width;
    CGContextScaleCTM(context, scalingFactor,scalingFactor);

    [webView.layer renderInContext: UIGraphicsGetCurrentContext()];
    UIImage *thumbImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (successBlock)
    {
        successBlock(thumbImage);
    }
}

@end
