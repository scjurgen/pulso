//
//  MHDMood.m
//  Helper
//
//  Created by Lichtlein, Thomas on 23.03.14.
//  Copyright (c) 2014 Lichtlein, Thomas. All rights reserved.
//

#import "MHDMood.h"

@implementation MHDMood

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.mood = [decoder decodeObjectForKey:@"mood"];
        self.ranking = [decoder decodeObjectForKey:@"ranking"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.mood forKey:@"mood"];
    [encoder encodeObject:self.ranking forKey:@"ranking"];

}

@end
