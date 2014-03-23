//
//  MHDHtmlFromArticle.h
//  Pulso
//
//  Created by Schwietering, Jürgen on 23.03.14.
//  Copyright (c) 2014 Schwietering, Jürgen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHDArticle.h"

@interface MHDHtmlFromArticle : NSObject

+ (NSString *)getHtmlFromArticle:(MHDArticle *)article forTemplate:(NSString *)template;

@end
