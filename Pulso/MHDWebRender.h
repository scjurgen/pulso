//
//  MHDWebRender.h
//  Pulso
//
//  Created by Schwietering, Jürgen on 23.03.14.
//  Copyright (c) 2014 Schwietering, Jürgen. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^MHDImageBlock)(UIImage *image);

@interface MHDWebRender : UIWebView <UIWebViewDelegate>

- (id)initWithFrame:(CGRect)frame;

- (void)render:(NSString *)url
  withTemplate:(NSString *)templateName
      andBlock:(MHDImageBlock)block;

@end
