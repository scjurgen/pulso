//
//  WebNewsEngine.m
//  testnewopengl
//
//  Created by Schwietering, Jürgen on 22.03.14.
//  Copyright (c) 2014 Jürgen Schwietering. All rights reserved.
//

#import "WebNewsEngine.h"


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

- (NSString *)createHtml
{
    if (_htmlTemplate==nil)
        return @"N/A";
    NSString * htmlComplete = _htmlTemplate;

    htmlComplete = [htmlComplete stringByReplacingOccurrencesOfString:@"{photo}"
                                                           withString:[self mapResourcePath:@"jurgenschwietering" ofType:@"jpg"]];
    return htmlComplete;
}

@end
