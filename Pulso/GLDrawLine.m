//
//  GLDrawLine.m
//  testnewopengl
//
//  Created by Schwietering, Jürgen on 22.03.14.
//  Copyright (c) 2014 Jürgen Schwietering. All rights reserved.
//

#import "GLDrawLine.h"
#import "OpenGlError.h"
#import "GLKTextureInfo+setTextureImage.h"

@interface GLDrawLine()
{
    GLKTextureInfo *backGroundTexture;
    GLuint bufferObjectNameArray;
    GLuint vertexArray;
    GLKVector3 line[2];
}
@property (strong, nonatomic) GLKBaseEffect *effect;

@end


@implementation GLDrawLine


- (void)setRay:(GLKVector3)eye direction:(GLKVector3)endPoint
{
    line[0] = eye;
    line[1] = endPoint;
}

- (void)setup
{
    backGroundTexture = [GLKTextureInfo setTextureImage:[UIImage imageNamed:@"TestImages/1x4.jpg"]];

    self.effect = [[GLKBaseEffect alloc] init];
    GLfloat testline[6] =     {
        0.0f, 0.0f, 3.0f,
        0.0f, 0.0f, -10.0f,
    };
    memcpy(line,testline,sizeof(line));

    self.effect.texture2d0.enabled = NO;    // Turn off texturing
    self.effect.texture2d1.enabled = NO;
    self.effect.light0.enabled = GL_FALSE;
    self.effect.lightModelTwoSided = GL_TRUE;
    self.effect.light0.diffuseColor = GLKVector4Make(1.0f, 0.4f, 0.4f, 1.0f);

    self.effect.colorMaterialEnabled = GL_TRUE;
    self.effect.useConstantColor = GL_TRUE;
    self.effect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);// RGBA

    glEnable(GL_DEPTH_TEST);
    //glDisable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

    glGenVertexArraysOES(1, &vertexArray);
    glBindVertexArrayOES(vertexArray);

    glGenBuffers(1, &bufferObjectNameArray);
    glBindBuffer(GL_ARRAY_BUFFER, bufferObjectNameArray);
    glBufferData(GL_ARRAY_BUFFER,sizeof(line),line,GL_DYNAMIC_DRAW);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*3, 0);
    //glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*7, (const GLvoid*)(sizeof(GL_FLOAT)*3));

    glBindVertexArrayOES(0);
    [OpenGlError checkQueue];
}

- (void)update:(GLKMatrix4)projectionMatrix
modelViewMatrix:(GLKMatrix4)modelViewMatrix;
{
    self.effect.transform.modelviewMatrix = modelViewMatrix;
    self.effect.transform.projectionMatrix = projectionMatrix;
    [self.effect prepareToDraw];
    glBindVertexArrayOES(vertexArray);
    glBindBuffer(GL_ARRAY_BUFFER, bufferObjectNameArray);
    glLineWidth(5.0);
    glBufferData(GL_ARRAY_BUFFER,sizeof(line),line,GL_DYNAMIC_DRAW);
    glDrawArrays(GL_LINES, 0, 2);
    glBindVertexArrayOES(0);
    [OpenGlError checkQueue];

}
@end
