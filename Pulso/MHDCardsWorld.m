//
//  CardsWorld.m
//  testnewopengl
//
//  Created by Schwietering, Jürgen on 22.03.14.
//  Copyright (c) 2014 Jürgen Schwietering. All rights reserved.
//

#import "MHDCardsWorld.h"

#import <OpenGLES/EAGL.h>

#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>
#import "OpenGlError.h"
#import "GLDrawLine.h"
#import "GLKTextureInfo+setTextureImage.h"

#import "SkyBox.h"
#import "TextureAtlas.h"
#import "TiltSensor.h"

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

@interface MHDCardsWorld()
{
    GLDrawLine *showPointingVector;
    SkyBox *skyBox;

    GLuint _vertexArray[2];
    GLuint _vertexBuffer[2];
    GLKVector4 mainColor;

    NSInteger segmentsInX, segmentsInY;
}


@property (strong, nonatomic) GLKBaseEffect *effect;
@end


@implementation MHDCardsWorld

- (id)init
{
    self = [super init];
    if (self)
    {
        CGRect rc = CGRectMake(0,0,100.0,100.0);
        [[TiltSensor handler] setMotionHandler:rc];
    }
    return self;
}

- (void)initCardsWithGeometry:(NSInteger)segmentsX
                    segmentsY:(NSInteger)segmentsY
{
    _cards = [[Cards3D alloc] init];
    segmentsInX = segmentsX;
    segmentsInY = segmentsY;
    [_cards createDataSet:segmentsX rows:segmentsY texturePadding:4];
}



- (void)setup:(NSInteger)segmentsX
    segmentsY:(NSInteger)segmentsY;
{
    float bwComponent = 0.1f;
    mainColor = GLKVector4Make(bwComponent, bwComponent, bwComponent, 1.0f);

    skyBox = [[SkyBox alloc] init];
    [skyBox setup];
    showPointingVector = [[GLDrawLine alloc] init];
    self.worldPov = [[WorldPov alloc] init];
    _textureAtlas = [[TextureAtlas alloc] initWithGeometry:segmentsX segmentsY:segmentsY];
    [_textureAtlas setupTextures];
    [self initCardsWithGeometry:segmentsX segmentsY:segmentsY];

    self.effect = [[GLKBaseEffect alloc] init];

    self.effect.light0.enabled = GL_FALSE;
    self.effect.light0.diffuseColor = GLKVector4Make(1.0f, 0.4f, 0.4f, 1.0f);

    self.effect.fog.enabled = YES;
    self.effect.fog.mode = GLKFogModeLinear;
    self.effect.fog.color = mainColor;
    self.effect.fog.start = -1.0;
    self.effect.fog.end =  30.0;

    self.effect.texture2d0.envMode = GLKTextureEnvModeReplace;
    self.effect.texture2d0.target = GLKTextureTarget2D;
    self.effect.texture2d0.name = self.textureAtlas.texture.name;


    glEnable(GL_DEPTH_TEST);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

    glGenVertexArraysOES(2, _vertexArray);
    glBindVertexArrayOES(_vertexArray[0]);

    glGenBuffers(2, _vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer[0]);
    glBufferData(GL_ARRAY_BUFFER, (GLsizeiptr)[_cards vertexDataSize], _cards.gRectVertexData, GL_DYNAMIC_DRAW);

    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(VERTEXPOINT_WITH_POS_TEX), BUFFER_OFFSET(0));
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(VERTEXPOINT_WITH_POS_TEX), BUFFER_OFFSET(sizeof(GL_FLOAT)*3));

    [showPointingVector setup];
    [OpenGlError checkQueue];
    NSLog(@"setup gl done");
}

- (void)tearDown
{
    glDeleteBuffers(1, _vertexBuffer);
    glDeleteVertexArraysOES(1, _vertexArray);

    self.effect = nil;
    skyBox =  nil;
}

- (void)setProjectionView:(CGSize)size
{

    float aspect = fabsf(size.width / size.height);

    self.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.2f, 1.0E5f);

    self.effect.transform.projectionMatrix = self.projectionMatrix;

    GLKMatrix4 baseModelViewMatrix;

    baseModelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, - self.worldPov.zoom);
    baseModelViewMatrix = GLKMatrix4MakeTranslation(- self.worldPov.panX, - self.worldPov.panY,  - self.worldPov.zoom);
    baseModelViewMatrix = GLKMatrix4Rotate(baseModelViewMatrix, self.worldPov.rotationX, 0.0f, 1.0f, 0.0f);
    self.modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -1.5f);
    self.modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -1.5f);
    self.modelViewMatrix = GLKMatrix4Rotate(self.modelViewMatrix, - self.worldPov.rotationY, 1.0f, 0.0f, 0.0f);
    self.modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, self.modelViewMatrix);

}

- (void)update:(CGSize)size
{
    [self setProjectionView:size];
    self.effect.transform.modelviewMatrix = self.modelViewMatrix;
    [skyBox setMatrices:self.modelViewMatrix projection:self.projectionMatrix];

}

- (BOOL)pointInTriangle:(CGPoint)p
                     p0:(CGPoint)p0
                     p1:(CGPoint)p1
                     p2:(CGPoint)p2
{
    CGFloat s = p0.y * p2.x - p0.x * p2.y + (p2.y - p0.y) * p.x + (p0.x - p2.x) * p.y;
    CGFloat t = p0.x * p1.y - p0.y * p1.x + (p0.y - p1.y) * p.x + (p1.x - p0.x) * p.y;

    if ((s < 0) != (t < 0))
        return false;

    CGFloat a = -p1.y * p2.x + p0.y * (p2.x - p1.x) + p0.x * (p1.y - p2.y) + p1.x * p2.y;
    if (a < 0.0)
    {
        s = -s;
        t = -t;
        a = -a;
    }
    return s > 0 && t > 0 && (s + t) < a;
}


- (int)cardUnderTap:(CGSize)size
                  x:(CGFloat)x
                  y:(CGFloat)y
                  p:(CGPoint*)p
{
    GLKVector3 card[4];
    CGPoint touch = CGPointMake((x/size.width - 0.5)*2.0,((size.height-y)/size.height - 0.5)*2.0);
    CGFloat bestZ = 0.0;
    int idx = -1;
    CGPoint pBest[4];
    for (int i=0; i < self.cards.itemsCount; i++)
    {
        [self.cards getCardByIndex:i coordinates:card];
        CGFloat z = 0.0f;
        for (int i=0; i < 4; i++)
        {
            GLKVector4 pos = GLKVector4Make(card[i].x, card[i].y, card[i].z, 1.0f);
            GLKVector4 step1 = GLKMatrix4MultiplyVector4(self.modelViewMatrix, pos);
            GLKVector4 step2 = GLKMatrix4MultiplyVector4(self.projectionMatrix, step1);
            step2 = GLKVector4MultiplyScalar(step2, 1/step2.w);
            //NSLog(@"Final (%d): %f %f (%f)", i, step2.x, step2.y, step2.z);
            pBest[i].x = step2.x;
            pBest[i].y = step2.y;
            z += step2.z;
        }
        if ([self pointInTriangle:touch p0:pBest[0] p1:pBest[1] p2:pBest[2]] ||
            [self pointInTriangle:touch p0:pBest[3] p1:pBest[1] p2:pBest[2]])
        {
            if (idx == -1)
            {
                memcpy(p,pBest,sizeof(pBest));
                bestZ = z;
                idx = i;
            }
            if (z < bestZ)
            {
                memcpy(p,pBest,sizeof(pBest));
                z = bestZ;
                idx = i;
            }
        }
    }
    if (idx != -1)
    {
        NSLog(@"A: %d [%f]", idx, bestZ);
        return idx;
    }
    return -1;
}



- (int)tapWorld:(CGSize)size x:(CGFloat)x y:(CGFloat)y p:(CGPoint*)p;

{
    int val = [self cardUnderTap:size x:x y:y p:p];
    return val;
}


#pragma mark - OpenGL stuff


- (void)clearWorld
{
    glClearColor(mainColor.r,mainColor.g,mainColor.b,mainColor.a);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

}

- (void)drawView
{
    [self clearWorld];
    [OpenGlError checkQueue];

#ifdef DEBUGEYEPOINTER
    [showPointingVector update:self.projectionMatrix modelViewMatrix:self.modelViewMatrix];
#endif

    [skyBox draw];
    [OpenGlError checkQueue];



    [self.effect prepareToDraw];

    glBindVertexArrayOES(_vertexArray[0]);
    [_cards updateTimeComponent];
    [OpenGlError checkQueue];

    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer[0]);
    glBufferData(GL_ARRAY_BUFFER, (GLsizeiptr)[_cards vertexDataSize], _cards.gRectVertexData, GL_DYNAMIC_DRAW);

    glDrawArrays(GL_TRIANGLES, 0, segmentsInX*segmentsInY*6);
    glBindVertexArrayOES(0);
    [OpenGlError checkQueue];
    
}

@end
