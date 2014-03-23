//
//  MHDMood.h
//  Helper
//
//  Created by Lichtlein, Thomas on 23.03.14.
//  Copyright (c) 2014 Lichtlein, Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHDMood : NSObject <NSCoding>

@property(nonatomic, strong)NSNumber *ranking;
@property(nonatomic, strong)NSString *mood;

@end
