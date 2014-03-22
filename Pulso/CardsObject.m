//
//  CardsObject.m
//  testnewopengl
//
//  Created by Schwietering, Jürgen on 22.03.14.
//  Copyright (c) 2014 Jürgen Schwietering. All rights reserved.
//

#import "CardsObject.h"

@implementation CardsObject

- (void)resetWithItemsCount:(NSInteger)itemsCount
{
    if (self.gRectVertexData)
    {
        free(self.gRectVertexData);
        self.gRectVertexData = NULL;
    }
    self.itemsCount = itemsCount;
    self.gRectVertexData = malloc(itemsCount * sizeof(VERTEXPOINT_WITH_POS_TEX)*VERTEXPERCARD);
}

- (id)initWithItemsCount:(NSInteger)itemsCount
{
    self = [super init];
    if (self)
    {
        [self resetWithItemsCount:itemsCount];
    }
    return self;
}

- (void)dealloc
{
    if (self.gRectVertexData)
    {
        free(self.gRectVertexData);
        self.gRectVertexData = NULL;
    }
}

- (BOOL)getCardByIndex:(NSInteger)index
           coordinates:(GLKVector3 *)coordinates
{
    if (index < 0)
        return NO;
    if (index >= self.itemsCount)
        return NO;
    int indexCoordinates = VERTEXPERCARD*index;
    VERTEXPOINT_WITH_POS_TEX *vp = &self.gRectVertexData[indexCoordinates];
    coordinates[0].x = vp->pos[0];
    coordinates[0].y = vp->pos[1];
    coordinates[0].z = vp->pos[2];
    vp++;
    coordinates[1].x = vp->pos[0];
    coordinates[1].y = vp->pos[1];
    coordinates[1].z = vp->pos[2];
    vp++;
    coordinates[2].x = vp->pos[0];
    coordinates[2].y = vp->pos[1];
    coordinates[2].z = vp->pos[2];
    vp++;
    vp++;
    vp++;
    coordinates[3].x = vp->pos[0];
    coordinates[3].y = vp->pos[1];
    coordinates[3].z = vp->pos[2];
    return YES;
}

- (NSInteger)vertexDataSize
{
    return self.itemsCount * sizeof(VERTEXPOINT_WITH_POS_TEX)*VERTEXPERCARD;
}

@end
