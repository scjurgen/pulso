//
//  CardLifeCycle.m
//  testnewopengl
//
//  Created by Schwietering, Jürgen on 22.03.14.
//  Copyright (c) 2014 Jürgen Schwietering. All rights reserved.
//

#import "CardLifeCycle.h"

#define NEWTIME 2.0f
#define AGINGTIME 10.0f
#define FRONTTIME 20.0f

@implementation CardLifeCycle
//
//- (void)resetCardLife
//{
//    for (int i=0; i < self.maxCards; i++)
//    {
//        double f=(rand()%32767)/32767.0;
//        self.cardLife[i].t = f*AGINGTIME;
//        self.cardLife[i].status = CTS_AGING;
//    }
//}
//
//- (void)updateCardLife
//{
//
//    for (int i=0; i < self.maxCards; i++)
//    {
//        self.cardLife[i].t -= 1.0f/30.0f; // approx FPS but not really important to be precise
//        if (self.cardLife[i].t < 0.0)
//        {
//            switch (self.cardLife[i].status)
//            {
//                case CTS_INACTIVE: // do nothing
//                case CTS_FIXED:// do nothing
//                    break;
//                case CTS_NEW:
//                    self.cardLife[i].status = CTS_FRONT;
//                    self.cardLife[i].t = FRONTTIME;
//                    break;
//                case CTS_FRONT:
//                    self.cardLife[i].status = CTS_AGING;
//                    self.cardLife[i].t = AGINGTIME;
//                    break;
//                case CTS_AGING:
//                    self.cardLife[i].status = CTS_NEW;
//                    self.cardLife[i].t = NEWTIME;
//                    break;
//            }
//
//        }
//    }
//}
//
//- (void)updateTimeComponent
//{
//    [self updateCardLife];
//    for (int index=0; index < self.maxCards; index++)
//    {
//        NSUInteger cardNr = index * VERTEXPERCARD;
//        for (int vertex=0; vertex < VERTEXPERCARD; vertex++)
//        {
//            for (int j=0; j < 6; j++)
//            {
//                switch (self.cardLife[index].status)
//                {
//                    case CTS_INACTIVE: // do nothing
//                        break;
//                    case CTS_FIXED:// do nothing
//                        self.gRectVertexData[cardNr+j].pos[2] = DISTANCEZERO;
//                        break;
//                    case CTS_NEW:
//                        self.gRectVertexData[cardNr+j].pos[2] = DISTANCEZERO-BACKFACTOR*self.cardLife[index].t/NEWTIME;
//                        break;
//                    case CTS_FRONT:
//                        self.gRectVertexData[cardNr+j].pos[2] = DISTANCEZERO+0.0;
//                        break;
//                    case CTS_AGING:
//                        self.gRectVertexData[cardNr+j].pos[2] = DISTANCEZERO-BACKFACTOR*(AGINGTIME-self.cardLife[index].t)/AGINGTIME;
//                        break;
//                }
//            }
//        }
//    }
//}

@end
