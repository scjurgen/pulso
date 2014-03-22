//
//  CardsObject.h
//  testnewopengl
//
//  Created by Schwietering, Jürgen on 22.03.14.
//  Copyright (c) 2014 Jürgen Schwietering. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

typedef struct __attribute__((packed))
{
    GLfloat pos[3];
    GLfloat tex[2];
}VERTEXPOINT_WITH_POS_TEX;

#define VERTEXPERCARD 6
#define ITEMSPERVERTEX (sizeof(VERTEXPOINT_WITH_POS_TEX)/sizeof(GLfloat))

@interface CardsObject : NSObject

@property (assign,nonatomic) VERTEXPOINT_WITH_POS_TEX *gRectVertexData;
@property (assign,nonatomic) NSInteger itemsCount;

- (NSInteger)vertexDataSize;
- (id)initWithItemsCount:(NSInteger)itemsCount;
- (void)resetWithItemsCount:(NSInteger)itemsCount;

- (BOOL)getCardByIndex:(NSInteger)index
           coordinates:(GLKVector3 *)coordinates;

@end
