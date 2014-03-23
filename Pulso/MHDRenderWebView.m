//
//  MHDRenderWebView.m
//  Pulso
//
//  Created by Schwietering, Jürgen on 23.03.14.
//  Copyright (c) 2014 Schwietering, Jürgen. All rights reserved.
//

#import "MHDRenderWebView.h"
#import "WebNewsEngine.h"

@interface MHDRenderWebView()
{
    WebNewsEngine *webNewsEngine;
    MHDImageBlock successBlock;
}

@end

@implementation MHDRenderWebView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}



- (void)render:(NSString *)url
  withTemplate:(NSString *)templateName
     andBlock:(MHDImageBlock)block
{
    successBlock = block;
    webNewsEngine = [[WebNewsEngine alloc] init];
    [webNewsEngine defineTemplate:templateName];

    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: [NSURL URLWithString:url]
                                                  cachePolicy: NSURLRequestUseProtocolCachePolicy
                                              timeoutInterval: 5.0];
    self.delegate = self;
    [self loadRequest:request];
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