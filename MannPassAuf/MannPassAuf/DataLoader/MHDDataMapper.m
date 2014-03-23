//
//  MHDDataMapper.m
//  Helper
//
//  Created by Lichtlein, Thomas on 22.03.14.
//  Copyright (c) 2014 Lichtlein, Thomas. All rights reserved.
//

#import "MHDDataMapper.h"

@implementation MHDDataMapper

- (NSDictionary *)data2Dict:(NSData *)jsonData {
    NSDictionary *jsonDict = nil;
    NSError *error = nil;
    
    if ([jsonData length] > 0) {
        
        jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                   options:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers
                                                     error:&error];
    }
    NSDictionary *tempDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              jsonDict, @"jsondict",
                              error, @"error", nil];
    
    
    return tempDict;
}


- (MHDArticleList *)getResultFor_ArticleList:(NSData *)data
                                       error:(NSError *)error {
    
    if ([data length] == 0) {
        return nil;
    }
    
    NSDictionary *tempDict = [self data2Dict:data];
    if (tempDict[@"error"] || !tempDict[@"jsonDict"]) {
        return nil;
    }
    
    NSDictionary *jsonDict = tempDict[@"jsonDict"];
    
    MHDArticleList *articleList = [[MHDArticleList alloc] init];
    
#warning decide which properties are filled here
    for (NSString *articleId in jsonDict[@"articleIds"]) {
        
        [articleList.articlesList addObject:articleId];
    }
    
    return articleList;
}


- (MHDArticle *)getResultFor_Article:(NSData *)data
                               error:(NSError *)error {
    
    if ([data length] == 0) {
        return nil;
    }
    
    NSDictionary *tempDict = [self data2Dict:data];
    if (tempDict[@"error"] || !tempDict[@"jsondict"]) {
        return nil;
    }
    
    NSDictionary *jsonDict = tempDict[@"jsondict"];
    
    MHDArticle *article = (MHDArticle *)[[NSDictionary alloc] init];
    
    // Since there is all neccessary data in it we
    // fill the whole json into the article object
    
    article = (MHDArticle *)jsonDict;
    return article;
}

@end
