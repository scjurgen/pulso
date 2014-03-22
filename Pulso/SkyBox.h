//
//  SkyBox.h
//  testnewopengl
//
//  Created by Schwietering, Jürgen on 22.03.14.
//  Copyright (c) 2014 Jürgen Schwietering. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardsObject.h"

@interface SkyBox : NSObject
@property (strong, nonatomic) GLKSkyboxEffect *skyBoxEffect;

- (void)setMatrices:(GLKMatrix4)modelView
         projection:(GLKMatrix4)projection;
- (void)setup;
- (void)update;
- (void)draw;

@end
