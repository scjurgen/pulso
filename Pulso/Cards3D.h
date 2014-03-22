//
// Created by Schwietering, Jürgen on 22.03.14.
// Copyright (c) 2013 Jürgen Schwietering. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "CardsObject.h"
#import "CardLifeCycle.h"


@interface Cards3D : CardsObject

- (void)createDataSet:(NSUInteger)columns
                 rows:(NSUInteger)rows
       texturePadding:(NSUInteger)texturePadding;

- (void)updateTimeComponent;

#pragma mark - create cardsets

- (void)orderAsTable;

- (void)orderAsCube:(NSUInteger)columns rows:(NSUInteger)rows floors:(NSUInteger)floors;

- (void)orderAsSpiral:(CGFloat)segments;

@end