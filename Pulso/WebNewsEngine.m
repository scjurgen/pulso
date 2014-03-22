//
//  WebNewsEngine.m
//  testnewopengl
//
//  Created by Schwietering, Jürgen on 22.03.14.
//  Copyright (c) 2014 Jürgen Schwietering. All rights reserved.
//

#import "WebNewsEngine.h"
#import "DataLoader/MHDPublicInterface.h"
#import "DataLoader/DataTypes/MHDArticle.h"

@interface WebNewsEngine ()

@property(nonatomic, retain)NSString *contentString;

@end
@implementation WebNewsEngine

- (id)init
{
    self = [super init];
    if (self)
    {
        _htmlTemplate = nil;

    }
    return self;
}


- (void)defineTemplate:(NSString*)templateName
{
    NSString *bundleHtml = [[NSBundle mainBundle] pathForResource:templateName ofType:@"html"];
    if (bundleHtml==nil)
        return;
    NSURL *path = [NSURL fileURLWithPath:bundleHtml];
    _htmlTemplate =  [NSString  stringWithContentsOfURL:path encoding:NSUTF8StringEncoding error:nil];
}

- (NSString *)mapResourcePath:(NSString*)resource ofType:(NSString*)resourceType
{
    NSString *resourcePath = [[[[NSBundle mainBundle]
                                pathForResource:resource ofType:@"jpg"]
                               stringByReplacingOccurrencesOfString:@"/" withString:@"//"]
                              stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

    return [NSString stringWithFormat:@"file:/%@", resourcePath];
}

-(void)createHtmlUsingBlock:(MHDHTMLContentBlock)result {
    if (_htmlTemplate==nil) result(@"N/A");
    
    NSString *__htmlComplete = _htmlTemplate;
    
    [self loadContentUsingBlock:^(NSString *htmlContent) {
        
        result([__htmlComplete stringByReplacingOccurrencesOfString:@"{article}"
                                                         withString:htmlContent]);
        
    }];
}

- (void)loadContentUsingBlock:(MHDHTMLContentBlock)result {
    
    [MHDPublicInterface getArticleForId:@"da17228caa78f321e802f3641d69bed8"
                              onSuccess:^(id resultSuccess) {
                                  MHDArticle *article = (MHDArticle *)resultSuccess;
                                  _contentString = article[@"content"];
                                  
                                  NSLog(@"%@", (MHDArticle *)resultSuccess);
                                  
                                  result(_contentString);
                              }
                              onFailure:^(id resultFailure) {
                                  NSLog(@"%@", (MHDArticle *)resultFailure);
                                  
                                  result(@"Not able to load Data...");
                              }];
    
}


@end
