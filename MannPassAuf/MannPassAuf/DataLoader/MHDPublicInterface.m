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
    
    NSString *url = [NSString stringWithFormat:@"http://www.nerdware.net/hackathon/mood.php?mood=%@", [self getNameForEnum:mood]];
    
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


+ (NSString *)getNameForEnum:(MHDMoods)mood {
    
    switch (mood) {
        case 0:
            return @"angry";
        case 1:
            return @"confused";
        case 2:
            return @"cool";
        case 3:
            return @"happy";
        case 4:
            return @"neutral";
        case 5:
            return @"sad";
        case 6:
            return @"shocked";
        case 7:
            return @"smiley";
        case 8:
            return @"tongue";
        case 9:
            return @"wondering";
        default:
            break;
    }
    
}

@end
