//
//  MHDRenderWebView.m
//  Pulso
//
//  Created by Schwietering, Jürgen on 23.03.14.
//  Copyright (c) 2014 Schwietering, Jürgen. All rights reserved.
//

#import "MHDRenderArticle.h"
#import "WebNewsEngine.h"
#import "MHDHtmlFromArticle.h"
#import "MHDPublicInterface.h"

@interface MHDRenderArticle()
{
}

@end

@implementation MHDRenderArticle


- (id)init
{
    self = [super init];
    if (self)
    {
        self.backdropColor = [UIColor colorWithWhite:1.0 alpha:1.0];
        self.fontName = @"HelveticaNeue";
    }
    return self;
}

- (UIImage *)drawText:(NSString *)text
           targetSize:(CGSize)size
             fontSize:(CGFloat)fontSize
            fontColor:(UIColor *)fontColor
{
    if (size.width < 4.0) return nil;
    UIFont *font = [UIFont fontWithName:self.fontName size:fontSize];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
     font, NSFontAttributeName,
     [NSNumber numberWithFloat:1.0], NSBaselineOffsetAttributeName, nil];

    CGSize textsize = [text sizeWithAttributes:attrsDictionary];
    while (textsize.width * 1.1 > size.width)
    {
        fontSize *= 0.9;
        font = [UIFont fontWithName:self.fontName size:fontSize];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                         font, NSFontAttributeName,
                                         [NSNumber numberWithFloat:1.0], NSBaselineOffsetAttributeName, nil];
        textsize = [text sizeWithAttributes:attrsDictionary];
    }

    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, self.backdropColor.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));

    CGContextSetFillColorWithColor(context, fontColor.CGColor);

    CGFloat x, y;
    x = (size.width - textsize.width) / 2; // center
    y = (size.height - textsize.height) / 2;
    [text drawAtPoint:CGPointMake(x, y) withAttributes:attrsDictionary];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

// category here

-(NSString*)trimLeadingWhitespace:(NSString*)inString {
    NSInteger i = 0;

    while ((i < [inString length])
           && [[NSCharacterSet whitespaceCharacterSet] characterIsMember:[inString characterAtIndex:i]]) {
        i++;
    }
    return [inString substringFromIndex:i];
}

- (void)renderArticle:(CGRect)frame
      withArticleId:(NSString*)articleId
           andBlock:(MHDImageBlock)block
{
    
    [MHDPublicInterface
     getArticleForId:articleId
     onSuccess:^(id resultSuccess) {
         MHDArticle *article = (MHDArticle *)resultSuccess;
         UIImage *image = [self drawText:[self trimLeadingWhitespace:article[@"title"]]
                              targetSize:frame.size
                                fontSize:36.0
                               fontColor:[UIColor colorWithWhite:0.7 alpha:1.0]];
         block(image);
     }
     onFailure:^(id resultFailure) {
         NSLog(@"%@", (MHDArticle *)resultFailure);
         block(nil);
     }];
}



@end
