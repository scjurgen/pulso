//
//  TextureAtlas.h
//  testnewopengl
//
//  Created by Schwietering, Jürgen on 22.03.14.
//  Copyright (c) 2014 Jürgen Schwietering. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>


#define TEXTUREMAPSIZE 4096

@interface TextureAtlas : NSObject

@property (assign, atomic) CGPoint segments;
@property (assign, atomic) CGSize mapSize;
@property (strong, nonatomic) GLKTextureInfo *texture;

- (id)initWithGeometry:(NSInteger)segmentsX segmentsY:(NSInteger)segmentsY;

- (void)setupTextures;


- (void)updateTexture:(NSInteger)column
                  row:(NSInteger)row
                image:(UIImage *)image;

@end
