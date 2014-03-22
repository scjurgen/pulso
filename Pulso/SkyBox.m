//
//  SkyBox.m
//  testnewopengl
//
//  Created by Schwietering, Jürgen on 22.03.14.
//  Copyright (c) 2014 Jürgen Schwietering. All rights reserved.
//




#import "SkyBox.h"
#import "GLKTextureInfo+setTextureImage.h"

#ifdef NATIVE


@interface SkyBox()
{
    @private
    GLKTextureInfo *texturemap;
}
@property (strong, nonatomic) GLKBaseEffect *backGroundEffect;

@end


@implementation SkyBox


- (id)init
{
    self = [super init];
    if (self)
    {
        self.skyBoxEffect = [[GLKSkyboxEffect alloc] init];
    }
    return self;
}

- (void)setMatrices:(GLKMatrix4)modelView projection:(GLKMatrix4)projection
{
    NSAssert(!self.skyBoxEffect, @"Missing skyBoxEffect");
    self.skyBoxEffect.transform.modelviewMatrix = modelView;
    self.skyBoxEffect.transform.projectionMatrix = projection;
}


- (void)setup
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"world_cube_net" ofType:@"png"];
    NSError *error = nil;
    texturemap = [GLKTextureLoader
                        cubeMapWithContentsOfFile:imagePath
                        options:nil
                        error:&error];
    NSAssert(!error, @"%@", error);
    self.skyBoxEffect.center = GLKVector3Make(0.0f, 0.0f, 3.0f);
    self.skyBoxEffect.xSize = 3.0;
    self.skyBoxEffect.ySize = 3.0;
    self.skyBoxEffect.zSize = 3.0;
    self.skyBoxEffect.textureCubeMap.name = texturemap.name;

}

- (void)draw
{
    [self.skyBoxEffect prepareToDraw];
    [self.skyBoxEffect draw];
}
#else

GLfloat gCubeVertexData[6*5] =
{
    1.25f, -0.5f, 1.0f,       1.0f, 1.0f,
    -1.25f, -0.5f, 1.0f,       0.0f, 1.0f,
    1.25f,  0.5f, 1.0f,       1.0f, 0.0f,
    -1.25f, -0.5f, 1.0f,       0.0f, 1.0f,
    1.25f,  0.5f, 1.0f,       1.0f, 0.0f,
    -1.25f,  0.5f, 1.0f,       0.0f, 0.0f,
};

@interface SkyBox()
{
@private
    GLKTextureInfo *texturemap;
    GLuint vertexArray;
    GLuint vertexBuffer;

}
@property (strong, nonatomic) GLKBaseEffect *backGroundEffect;

@end


@implementation SkyBox
- (id)init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}

- (void)scaleCube
{
    CGFloat scale=30.0;
    for (int i=0; i < 6; i++)
    {
        gCubeVertexData[i*5+0] *= scale;
        gCubeVertexData[i*5+1] *= scale*2.0;
        gCubeVertexData[i*5+1] -= 15.0;
        //gCubeVertexData[i*5+2] *= scale;
    }
    for (int i=0; i < 6; i++)
    {
        gCubeVertexData[i*5+2] += -10.0;
    }
}


- (void)setMatrices:(GLKMatrix4)modelView
         projection:(GLKMatrix4)projection
{
    self.backGroundEffect.transform.modelviewMatrix = modelView;
    self.backGroundEffect.transform.projectionMatrix = projection;
}

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

- (void)setup
{
    [self scaleCube];
    texturemap = [GLKTextureInfo setTextureImage:[UIImage imageNamed:@"ESO_-_Milky_Way.jpg"]];
    //texturemap = [GLKTextureInfo setTextureImage:[UIImage imageNamed:@"glitch.jpg"]];
    self.backGroundEffect = [[GLKBaseEffect alloc] init];

    self.backGroundEffect.light0.enabled = GL_FALSE;
    self.backGroundEffect.light0.diffuseColor = GLKVector4Make(1.0f, 0.4f, 0.4f, 1.0f);

    self.backGroundEffect.texture2d0.envMode = GLKTextureEnvModeReplace;
    self.backGroundEffect.texture2d0.target = GLKTextureTarget2D;
    self.backGroundEffect.texture2d0.name = texturemap.name;
    glGenVertexArraysOES(1, &vertexArray);
    glGenBuffers(1, &vertexBuffer);
    glBindVertexArrayOES(vertexArray);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(gCubeVertexData), gCubeVertexData, GL_STATIC_DRAW);

    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(VERTEXPOINT_WITH_POS_TEX), BUFFER_OFFSET(0));
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(VERTEXPOINT_WITH_POS_TEX), BUFFER_OFFSET(sizeof(GL_FLOAT)*3));

    glBindVertexArrayOES(0);

}

- (void)update
{
    self.backGroundEffect.transform.modelviewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -10.0);
}

- (void)draw
{
    //[self.skyBoxEffect prepareToDraw];
    //[self.skyBoxEffect draw];
    [self.backGroundEffect prepareToDraw];
    glBindVertexArrayOES(vertexArray);
    glDrawArrays(GL_TRIANGLES, 0, 6);

}
#endif
@end
