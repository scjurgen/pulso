//
//  WebNewsEngine.h
//  testnewopengl
//
//  Created by Schwietering, Jürgen on 22.03.14.
//  Copyright (c) 2014 Jürgen Schwietering. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebNewsEngine : NSObject

@property (nonatomic, strong) NSString *htmlTemplate;

-(void)defineTemplate:(NSString*)templateName;

-(NSString*)createHtml;

@end
