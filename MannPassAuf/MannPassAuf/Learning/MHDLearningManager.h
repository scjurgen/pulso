//
//  MHDLearningManager.h
//  Helper
//
//  Created by Lichtlein, Thomas on 23.03.14.
//  Copyright (c) 2014 Lichtlein, Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHDPublicInterface.h"


@interface MHDLearningManager : NSObject

- (void)raiseValueforMood:(MHDMoods)mood;

- (NSArray *)getRankingOfMoods;

- (MHDMoods)getMoodForName:(NSString *)mood;
@end
