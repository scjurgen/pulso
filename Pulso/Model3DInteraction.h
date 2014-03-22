//
//  Model3DInteraction.h
//  testnewopengl
//
//  Created by Schwietering, Jürgen on 23.02.14.
//  Copyright (c) 2014 Jürgen Schwietering. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM (NSInteger, Model3dInteractionType) {
    Model3dInteractionTypePan = 0,
    Model3dInteractionTypeCylinder = 1,
    Model3dInteractionTypeSphere = 2,
};

@interface Model3DInteraction : NSObject

@property (assign,nonatomic) Model3dInteractionType interactionType;

@end
