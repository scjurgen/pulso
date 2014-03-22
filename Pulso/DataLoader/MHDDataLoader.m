//
//  MHDDataLoader.m
//  Helper
//
//  Created by Lichtlein, Thomas on 22.03.14.
//  Copyright (c) 2014 Lichtlein, Thomas. All rights reserved.
//

#import "MHDDataLoader.h"
#import "MHDDataMapper.h"

@implementation MHDDataLoader

- (id)init {
    if (self = [super init]) {
        _timeoutInterval = 0;
    }
    return self;
}

- (void)loadObjectFromURL:(NSString *)urlString
           withHTTPMethod:(HTTPMethod)method
               forService:(MHDService)service
               usingBlock:(MHDResultBlock)returnBlock {
    
    MHDDataMapper *mapper = [[MHDDataMapper alloc] init];
    
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = [self getHTTPMethod:method];
    _timeoutInterval != 0 ? [request setTimeoutInterval:_timeoutInterval] : [request setTimeoutInterval:30.0];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               switch (service) {
                                   case getArticlesForMood:
                                       returnBlock([mapper getResultFor_ArticleList:data error:error], error);
                                       break;
                                   case getArticle:
                                       returnBlock([mapper getResultFor_Article:data error:error], error);
                                   default:
                                       break;
                               }
                           }];
    request = nil;
}


- (NSString *)getHTTPMethod:(HTTPMethod)method {
    
    switch (method) {
        case GET:
            return @"GET";
        case POST:
            return @"POST";
        case DELETE:
            return @"DELETE";
        default:
            return nil;
    }
}

@end
