//
//  MHDHtmlFromArticle.m
//  Pulso
//
//  Created by Schwietering, Jürgen on 23.03.14.
//  Copyright (c) 2014 Schwietering, Jürgen. All rights reserved.
//

#import "MHDHtmlFromArticle.h"

@implementation MHDHtmlFromArticle

+ (NSString *)getHtmlFromArticle:(MHDArticle *)article forTemplate:(NSString *)template {

    NSArray *mediaArr;
    NSDictionary *medias;
    NSArray *pictureArr;
    NSDictionary *pictures;
    NSArray *captionsArr;

    if (article[@"medias"]) mediaArr = article[@"medias"];
    if (mediaArr[0]) medias = mediaArr[0];
    if (medias[@"references"]) pictureArr = medias[@"references"];
    if (pictureArr[0]) pictures = pictureArr[0];
    if (pictures[@"url"]) {
        NSString *substring = [pictures[@"url"] stringByReplacingOccurrencesOfString:@"w=550" withString:@"w=997"];
        template = [template stringByReplacingOccurrencesOfString:@"{pictureUrl}" withString:substring];
    }
    //    if (medias[@"caption"]) template = [template stringByReplacingOccurrencesOfString:@"{pictureString}" withString:medias[@"caption"]];
    if (article[@"captions"]) captionsArr = article[@"captions"];
    if (captionsArr[0]) template = [template stringByReplacingOccurrencesOfString:@"{headerTitle}" withString:captionsArr[0]];
    if (article[@"content"]) template = [template stringByReplacingOccurrencesOfString:@"{article}" withString:article[@"content"]];
    if (article[@"category"]) template = [template stringByReplacingOccurrencesOfString:@"{topicName}" withString:article[@"category"]];
    return template;
}
@end
