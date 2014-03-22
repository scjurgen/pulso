//
//  MHDDataLoader.h
//  Helper
//
//  Created by Lichtlein, Thomas on 22.03.14.
//  Copyright (c) 2014 Lichtlein, Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>

// ReturnBlock
typedef void(^MHDResultBlock)(id result, NSError *error);

// Enums
typedef NS_ENUM(int, MHDService) {
    getArticle = 0,
    getArticlesForMood,
    setMood,
};

typedef NS_ENUM(int, HTTPMethod) {
    GET = 0,
    POST,
    DELETE
};

@interface MHDDataLoader : NSObject

@property(nonatomic, assign)CGFloat timeoutInterval;

- (void)loadObjectFromURL:(NSString *)urlString
           withHTTPMethod:(HTTPMethod)method
               forService:(MHDService)service
               usingBlock:(MHDResultBlock)returnBlock;

@end
