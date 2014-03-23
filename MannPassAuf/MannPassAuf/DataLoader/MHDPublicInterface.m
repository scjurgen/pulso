//
//  MHDPublicInterface.m
//  Helper
//
//  Created by Lichtlein, Thomas on 22.03.14.
//  Copyright (c) 2014 Lichtlein, Thomas. All rights reserved.
//

#import "MHDPublicInterface.h"
#import "MHDDataLoader.h"
#import "MHDArticleList.h"
#import "MHDArticle.h"

@implementation MHDPublicInterface

+ (void)getArticlesForMood:(MHDMoods)mood
                           onSuccess:(MHDResultSuccessBlock)successBlock
                           onFailure:(MHDResultFailureBlock)failureBlock {
    
    MHDDataLoader *loader = [[MHDDataLoader alloc] init];
    
    NSString *url = @"";
    
    [loader loadObjectFromURL:url
               withHTTPMethod:GET
                   forService:getArticlesForMood
                   usingBlock:^(id result, NSError *error) {
                       
                       if (result && [result isKindOfClass:[MHDArticleList class]]) {
                           
                           successBlock((MHDArticleList *)result);
                           
                       }
                       else {
                           failureBlock(error);
                       }

                   }];
}

+ (void)getArticleForId:(NSString *)articleId
              onSuccess:(MHDResultSuccessBlock)successBlock
              onFailure:(MHDResultFailureBlock)failureBlock {
    
    MHDDataLoader *loader = [[MHDDataLoader alloc] init];
    
    NSString *url = [NSString stringWithFormat:@"http://ipool-extern.s.asideas.de:9090/api/v2/search/%@?format=json", articleId];
    
    [loader loadObjectFromURL:url
               withHTTPMethod:GET
                   forService:getArticle
                   usingBlock:^(id result, NSError *error) {
                       
                       if (result && [result isKindOfClass:[NSDictionary class]]) {
                           
                           successBlock((MHDArticleList *)result);
                           
                       }
                       else {
                           failureBlock(error);
                       }
                       
                   }];
    
}

@end
