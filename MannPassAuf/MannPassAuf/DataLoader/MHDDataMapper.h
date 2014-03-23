//
//  MHDDataMapper.h
//  Helper
//
//  Created by Lichtlein, Thomas on 22.03.14.
//  Copyright (c) 2014 Lichtlein, Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MHDArticle.h"
#import "MHDArticleList.h"

@interface MHDDataMapper : NSObject

- (MHDArticleList *)getResultFor_ArticleList:(NSData *)data
                                       error:(NSError *)error;

- (MHDArticle *)getResultFor_Article:(NSData *)data
                               error:(NSError *)error;

@end
