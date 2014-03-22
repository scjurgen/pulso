//
//  CardLifeCycle.h
//  testnewopengl
//
//  Created by Schwietering, Jürgen on 22.03.14.
//  Copyright (c) 2014 Jürgen Schwietering. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    CTS_INACTIVE,
    CTS_NEW,
    CTS_FRONT,
    CTS_AGING,
    CTS_FIXED
}CARD_TIMESTATUS;

typedef struct __attribute__((packed))
{
    float t; // t for making card older
    CARD_TIMESTATUS status;
}CARDLIFE;

@interface CardLifeCycle : NSObject

@property (assign,nonatomic) CARDLIFE *cardLife;

@end
