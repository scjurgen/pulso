//
// Created by Schwietering, Jürgen on 22.03.14.
// Copyright (c) 2013 Jürgen Schwietering. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


/*
 the cards are mapped one to one to a texture atlas
 with columns x rows, padded with 4 pixels
 */


#import "Cards3D.h"
#import <GLKit/GLKit.h>
#define ATLAS 1  // set to 1 if going to use an ATLAS texture
#define DISTANCEZERO 0.0


// Sof constants
#define FACTORTOTAL 0.2f
#define BACKFACTOR 10.0f
#define NEWTIME 2.0f
#define AGINGTIME 20.0f
#define FRONTTIME 30.0f

#define CARDWIDTH 0.555
#define CARDHEIGHT 1.0

@interface Cards3D()
{
}

@property (assign,nonatomic) NSUInteger maxCards;
@property (assign,nonatomic) NSUInteger texturePadding;
@property (assign,nonatomic) NSUInteger maxRows, maxColumns;
@property (assign,nonatomic) CGFloat cardWidth, cardHeight;
@property (assign,nonatomic) BOOL timeInterpolating;
@property (assign,nonatomic) NSInteger interpolationFrame;
@property (assign,nonatomic) NSInteger maxinterpolationFrame;

@property (assign,nonatomic) CARDLIFE *cardLife;


@end

@implementation Cards3D

- (id)init
{
    self = [super init];
    if (self)
    {
        self.maxCards = 0;
    }
    return self;
}


- (NSUInteger)getIndex:(NSUInteger)x y:(NSUInteger)y
{
    return x + y * _maxColumns;
}

- (void)assignTextureCoordinates
{
#if ATLAS
    CGFloat tWidth = 1.0/self.maxColumns;
    CGFloat tHeight = 1.0/self.maxRows;
    CGFloat padding = tWidth/100.0;
#endif
    for (NSUInteger y=0; y < self.maxRows; y++)
    {
        for (NSUInteger x=0; x < self.maxColumns; x++)
        {
#if ATLAS
            [self setTextureArea:self.gRectVertexData
                          cardNr:[self getIndex:x y:y]
                               x:x*tWidth+padding
                               y:y*tHeight+padding
                              x2:(x+1)*tWidth-padding
                              y2:(y+1)*tHeight-padding];
#else
            [self setTextureArea:self.gRectVertexData cardNr:[self getIndex:x y:y]
                               x:0.0
                               y:0.0
                              x2:1.0
                              y2:1.0];
#endif
        }
    }
}


- (void)createDataSet:(NSUInteger)columns
                 rows:(NSUInteger)rows
       texturePadding:(NSUInteger)texturePadding
{
    NSAssert(rows>=1, @"rows should be at least 1");
    NSAssert(columns>=1, @"columns should be at least 1");

    self.maxRows = rows;
    self.maxColumns = columns;
    self.maxCards = columns * rows;
    self.texturePadding = texturePadding;
    [self resetWithItemsCount:self.maxCards];

    self.cardLife =  malloc(self.maxCards * sizeof(CARDLIFE));
    [self resetCardLife];

    [self assignTextureCoordinates];
    [self orderAsTable:self.gRectVertexData columns:columns rows:rows];
}


- (void)resetCardLife
{
    for (int i=0; i < self.maxCards; i++)
    {
        double f=(rand()%32767)/32767.0;
        self.cardLife[i].t = f*AGINGTIME;
        self.cardLife[i].status = CTS_FRONT;
    }
}

- (void)updateCardLife
{

    for (int i=0; i < self.maxCards; i++)
    {
        self.cardLife[i].t -= 1.0f/30.0f; // approx FPS but not really important to be precise
        if (self.cardLife[i].t < 0.0)
        {
            switch (self.cardLife[i].status)
            {
                case CTS_INACTIVE: // do nothing
                case CTS_FIXED:// do nothing
                    break;
                case CTS_NEW:
                    self.cardLife[i].status = CTS_FRONT;
                    self.cardLife[i].t = FRONTTIME;
                    break;
                case CTS_FRONT:
                    self.cardLife[i].status = CTS_AGING;
                    self.cardLife[i].t = AGINGTIME;
                    break;
                case CTS_AGING:
                    self.cardLife[i].status = CTS_NEW;
                    self.cardLife[i].t = NEWTIME;
                    break;
            }

        }
    }
}

- (void)updateTimeComponent
{
    [self updateCardLife];
    for (int index=0; index < self.maxCards; index++)
    {
        NSUInteger cardNr = index * VERTEXPERCARD;
        for (int vertex=0; vertex < VERTEXPERCARD; vertex++)
        {
            for (int j=0; j < 6; j++)
            {
                switch (self.cardLife[index].status)
                {
                    case CTS_INACTIVE: // do nothing
                        break;
                    case CTS_FIXED:// do nothing
                        self.gRectVertexData[cardNr+j].pos[2] = DISTANCEZERO;
                        break;
                    case CTS_NEW:
                        self.gRectVertexData[cardNr+j].pos[2] = DISTANCEZERO-BACKFACTOR*self.cardLife[index].t/NEWTIME;
                        break;
                    case CTS_FRONT:
                        self.gRectVertexData[cardNr+j].pos[2] = DISTANCEZERO+0.0;
                        break;
                    case CTS_AGING:
                        self.gRectVertexData[cardNr+j].pos[2] = DISTANCEZERO-BACKFACTOR*(AGINGTIME-self.cardLife[index].t)/AGINGTIME;
                        break;
                }
                self.gRectVertexData[cardNr+j].pos[2] /= FACTORTOTAL;
            }
        }
    }
}

- (void)setCenterRectangle:(VERTEXPOINT_WITH_POS_TEX *)gRectVertexData
                    cardNr:(NSUInteger)cardNr
                         w:(GLfloat)w
                         h:(GLfloat)h
{
    NSAssert(gRectVertexData, @"gRectVertexData not initialized");
    NSAssert (cardNr < self.maxCards, @"Card boundary is currently: %d requested index", (int)self.maxCards, cardNr);
    cardNr *= VERTEXPERCARD;
    gRectVertexData[cardNr].pos[0] = -w/2.0f;
    gRectVertexData[cardNr].pos[1] = -h/2.0f;
    gRectVertexData[cardNr].pos[2] = 0.0f;
    cardNr++;
    gRectVertexData[cardNr].pos[0] = w/2.0f;
    gRectVertexData[cardNr].pos[1] = -h/2.0f;
    gRectVertexData[cardNr].pos[2] = 0.0f;
    cardNr++;
    gRectVertexData[cardNr].pos[0] = -w/2.0f;
    gRectVertexData[cardNr].pos[1] = h/2.0f;
    gRectVertexData[cardNr].pos[2] = 0.0f;
    cardNr++;
    gRectVertexData[cardNr].pos[0] = w/2.0f;
    gRectVertexData[cardNr].pos[1] = -h/2.0f;
    gRectVertexData[cardNr].pos[2] = 0.0f;
    cardNr++;
    gRectVertexData[cardNr].pos[0] = -w/2.0f;
    gRectVertexData[cardNr].pos[1] = h/2.0f;
    gRectVertexData[cardNr].pos[2] = 0.0f;
    cardNr++;
    gRectVertexData[cardNr].pos[0] = w/2.0f;
    gRectVertexData[cardNr].pos[1] = h/2.0f;
    gRectVertexData[cardNr].pos[2] = 0.0f;
}


- (void)setTextureArea:(VERTEXPOINT_WITH_POS_TEX *)gRectVertexData
                cardNr:(NSUInteger)cardNr
                     x:(GLfloat)x
                     y:(GLfloat)y
                    x2:(GLfloat)x2
                    y2:(GLfloat)y2
{
    cardNr *= VERTEXPERCARD;
    gRectVertexData[cardNr].tex[0] = x;
    gRectVertexData[cardNr].tex[1] = y2;
    cardNr++;
    gRectVertexData[cardNr].tex[0] = x2;
    gRectVertexData[cardNr].tex[1] = y2;
    cardNr++;
    gRectVertexData[cardNr].tex[0] = x;
    gRectVertexData[cardNr].tex[1] = y;
    cardNr++;
    gRectVertexData[cardNr].tex[0] = x2;
    gRectVertexData[cardNr].tex[1] = y2;
    cardNr++;
    gRectVertexData[cardNr].tex[0] = x;
    gRectVertexData[cardNr].tex[1] = y;
    cardNr++;
    gRectVertexData[cardNr].tex[0] = x2;
    gRectVertexData[cardNr].tex[1] = y;
}


- (void)translateRect:(VERTEXPOINT_WITH_POS_TEX *)gRectVertexData
               cardNr:(NSUInteger)cardNr
                    x:(CGFloat)x
                    y:(CGFloat)y
                    z:(CGFloat)z
{
    cardNr *= VERTEXPERCARD;
    for (int i=0; i < VERTEXPERCARD; i++)
    {
        gRectVertexData[cardNr].pos[0] += x;
        gRectVertexData[cardNr].pos[1] += y;
        gRectVertexData[cardNr].pos[2] += z;
        cardNr++;
    }
}


- (void)rotateForPosition:(VERTEXPOINT_WITH_POS_TEX *)gRectVertexData
                   cardNr:(NSUInteger)cardNr
                        x:(CGFloat)x
                        y:(CGFloat)y
{
    cardNr *= VERTEXPERCARD;
    GLKVector3 vec;
    GLKMatrix4 m = GLKMatrix4MakeXRotation(x);
    m = GLKMatrix4RotateY(m,y);
    for (int i=0; i < VERTEXPERCARD; i++)
    {
        vec.x = gRectVertexData[cardNr].pos[0];
        vec.y = gRectVertexData[cardNr].pos[1];
        vec.z = gRectVertexData[cardNr].pos[2];
        vec = GLKMatrix4MultiplyVector3(m,  vec);
        gRectVertexData[cardNr].pos[0] = vec.x;
        gRectVertexData[cardNr].pos[1] = vec.y;
        gRectVertexData[cardNr].pos[2] = vec.z;
        cardNr++;
    }
}



#pragma mark - generate sets

- (void)orderAsTable:(VERTEXPOINT_WITH_POS_TEX *)gRectVertexData
             columns:(NSUInteger)columns
                rows:(NSUInteger)rows
{
    CGFloat width = CARDWIDTH, height = CARDHEIGHT;
    CGFloat paddingX = width/5.0, paddingY = height/5.0;
    for (NSInteger y=0; y < rows; y++)
    {
        for (NSInteger x=0; x < columns; x++)
        {
            CGFloat xp = (x-(int)columns/2)*(paddingX+width);
            CGFloat yp = (y-(int)rows/2)*(paddingY+height);
            NSUInteger index = [self getIndex:x y:y];
            CGFloat h = height;
            if (rand()%2==0)
            {
                h/=2;
            }

            [self setCenterRectangle:gRectVertexData cardNr:index w:width h:h];
            [self translateRect:gRectVertexData cardNr:index x:xp y:yp z:(rand()%100)/30.0];
        }
    }
}


- (void)orderAs8th:(VERTEXPOINT_WITH_POS_TEX *)gRectVertexData
           columns:(NSUInteger)columns
              rows:(NSUInteger)rows
{
    CGFloat width = CARDWIDTH, height = CARDHEIGHT;
    CGFloat paddingX = width/5.0, paddingY = height/5.0;
    float n=0;
    for (NSInteger y=0; y < rows; y++)
    {
        for (NSInteger x=0; x < columns; x++)
        {
            CGFloat xp = (x-(int)columns/2)*(paddingX+width);
            CGFloat yp = (y-(int)rows/2)*(paddingY+height);

            NSUInteger index = [self getIndex:x y:y];
            [self setCenterRectangle:gRectVertexData cardNr:index w:width h:height];
            [self translateRect:gRectVertexData cardNr:index x:xp y:yp z:0.0];
            [self rotateForPosition:gRectVertexData cardNr:index x:0 y:0.1*n];
            n+=1.0;
        }
    }

}


/**
 rotate around y axis and translate on spiral
 put in center, translate in z, rotate around y-axis, translate in y
 */
- (void)orderAsSpiral:(VERTEXPOINT_WITH_POS_TEX *)gRectVertexData
             segments:(CGFloat)segments
{
    CGFloat width = CARDWIDTH, height = CARDHEIGHT;
    float n = 0;
    float drift = 0.04;

    for (NSInteger index=0; index < self.maxCards; index++)
    {
        [self setCenterRectangle:gRectVertexData cardNr:index w:width h:height];
        [self translateRect:gRectVertexData cardNr:index x:0 y:index*drift-self.maxCards*drift/2.0 z:2.0];
        [self rotateForPosition:gRectVertexData cardNr:index x:0 y:0.1*n];
        n+=1.0;
    }
}


#pragma mark - access data

- (void)orderAsTable
{
    [self orderAsTable:self.gRectVertexData columns:12 rows:7];
}

- (void)orderAsCube:(NSUInteger)columns rows:(NSUInteger)rows floors:(NSUInteger)floors
{
    [self orderAsTable:self.gRectVertexData columns:columns rows:rows];
}

- (void)orderAsSpiral:(CGFloat)segments
{
    [self orderAsSpiral:self.gRectVertexData segments:segments];
}


@end

