//
//  MHDRenderWebView.h
//  Pulso
//
//  Created by Schwietering, Jürgen on 23.03.14.
//  Copyright (c) 2014 Schwietering, Jürgen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MHDImageBlock)(UIImage *image);

@interface MHDRenderArticle : NSObject

@property (atomic, assign) NSInteger fattyBum;
@property (atomic, assign) CGFloat fontSize;
@property (atomic, assign) CGFloat blurRadius;
@property (atomic, assign) CGFloat downScale;
@property (strong, nonatomic) NSString *fontName;
@property (strong, nonatomic) UIColor *backdropColor;
@property (strong, nonatomic) UIColor *fontColor;
@property (strong, nonatomic) UIColor *blurFontColor;

- (void)renderArticle:(CGRect)frame
        withArticleId:(NSString*)articleId
             andBlock:(MHDImageBlock)block;


@end
