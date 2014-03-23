//
//  MHDArticleList.m
//  Helper
//
//  Created by Lichtlein, Thomas on 22.03.14.
//  Copyright (c) 2014 Lichtlein, Thomas. All rights reserved.
//

#import "MHDArticleList.h"

@implementation MHDArticleList

- (id)init {
    if (self = [super init]) {
        _articlesList = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
