//
//  CardsWorld.h
//  testnewopengl
//
//  Created by Schwietering, Jürgen on 22.03.14.
//  Copyright (c) 2014 Jürgen Schwietering. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "GLObjectDebug.h"
#import "Cards3D.h"
#import "WorldPov.h"
#import "TextureAtlas.h"

@interface MHDCardsWorld : NSObject

@property (strong, nonatomic) Cards3D *cards;
@property (strong, nonatomic) WorldPov *worldPov;
@property (strong, nonatomic) TextureAtlas *textureAtlas;
@property (assign, nonatomic) GLKMatrix4 projectionMatrix;
@property (assign, nonatomic) GLKMatrix4 modelViewMatrix;


- (void)setup:(NSInteger)segmentsX
    segmentsY:(NSInteger)segmentsY;

- (void)update:(CGSize)size;
- (void)tearDown;
- (void)drawView;

#pragma mark External World Control
- (int)tapWorld:(CGSize)size x:(CGFloat)x y:(CGFloat)y p:(CGPoint*)p;
- (void)setProjectionView:(CGSize)size;

//- (void)setWorldPov;

@end
