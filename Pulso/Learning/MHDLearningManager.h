//
//  MHDLearningManager.h
//  Helper
//
//  Created by Lichtlein, Thomas on 23.03.14.
//  Copyright (c) 2014 Lichtlein, Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>

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

@interface MHDLearningManager : NSObject

- (void)raiseValueforMood:(MHDMoods)mood;

- (NSArray *)getRankingOfMoods;

@end
