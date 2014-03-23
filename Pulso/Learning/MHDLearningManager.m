//
//  MHDLearningManager.m
//  Helper
//
//  Created by Lichtlein, Thomas on 23.03.14.
//  Copyright (c) 2014 Lichtlein, Thomas. All rights reserved.
//

#import "MHDLearningManager.h"
#import "MHDMood.h"

@interface MHDLearningManager ()

@property(nonatomic, strong)NSMutableArray *rankingArray;

@end


@implementation MHDLearningManager

static MHDLearningManager *sharedManager;

+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        sharedManager = [[MHDLearningManager alloc] init];
    }
}

- (id)init {
    if (self = [super init]) {
        [self setupRankingArray];
    }
    return self;
}

- (void)setupRankingArray {
    
    for (int i = 0; i < 10; i++) {
        if (![[NSUserDefaults standardUserDefaults] objectForKey:[self getNameOfMood:i]]) {
            _rankingArray = [[NSMutableArray alloc] init];
            
            for (int j = 0; j < 10; j++) {
                MHDMood *mood = [[MHDMood alloc] init];
                mood.mood = [self getNameOfMood:j];
                mood.ranking = [NSNumber numberWithInt:0];
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:mood];
                [[NSUserDefaults standardUserDefaults] setObject:data forKey:mood.mood];
                
            }
            
        }
    }
}


- (void)raiseValueforMood:(MHDMoods)mood {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSData *data = [defaults objectForKey:[self getNameOfMood:mood]];
    MHDMood *moodObj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    int rankingInt = [moodObj.ranking intValue];
    moodObj.ranking = [NSNumber numberWithInt:rankingInt + 1];
    
    NSData *savedata = [NSKeyedArchiver archivedDataWithRootObject:moodObj];
    [defaults setObject:savedata forKey:moodObj.mood];

    NSLog(@"Mood: %@ is %@", moodObj.mood, moodObj.ranking);
}

- (NSString *)getNameOfMood:(MHDMoods)mood {
    switch (mood) {
        case angry:
            return @"angry";
        case confused:
            return @"confused";
        case cool:
            return @"cool";
        case happy:
            return @"happy";
        case neutral:
            return @"neutral";
        case sad:
            return @"sad";
        case shocked:
            return @"shocked";
        case smile:
            return @"smile";
        case tongue:
            return @"tongue";
        case wondering:
            return @"wondering";
        default:
            break;
    }
}

- (NSArray *)getRankingOfMoods {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 10; i++) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:[self getNameOfMood:i]];
        MHDMood *moodObj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        [tempArray addObject:moodObj];
        
    }
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"ranking"
                                  ascending:NO];

    return [tempArray sortedArrayUsingDescriptors:@[sortDescriptor]];
}

@end
