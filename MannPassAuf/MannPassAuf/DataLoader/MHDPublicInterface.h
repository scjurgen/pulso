//
//  MHDPublicInterface.h
//  Helper
//
//  Created by Lichtlein, Thomas on 22.03.14.
//  Copyright (c) 2014 Lichtlein, Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>

// BLOCKS
typedef void(^MHDResultSuccessBlock)(id resultSuccess);
typedef void(^MHDResultFailureBlock)(id resultFailure);

// ENUMS
typedef NS_ENUM(int, MHDMoods) {
    angry = 0,
    confused,
    cool,
    happy,
    neutral,
    sad,
    shocked,
    smile,
    tongue,
    wondering
};

@interface MHDPublicInterface : NSObject

+ (void)getArticlesForMood:(MHDMoods)mood
                 onSuccess:(MHDResultSuccessBlock)successBlock
                 onFailure:(MHDResultFailureBlock)failureBlock;

+ (void)getArticleForId:(NSString *)articleId
              onSuccess:(MHDResultSuccessBlock)successBlock
              onFailure:(MHDResultFailureBlock)failureBlock;

@end
