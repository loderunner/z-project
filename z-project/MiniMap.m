//
//  MiniMap.m
//  z-project
//
//  Created by Aurélien Noce on 09/02/13.
//
//

#import <GLKit/GLKit.h>
#import "MiniMap.h"

@implementation MiniMap

- (void)draw
{
    glEnable(GL_LINE_SMOOTH);
    glColor4ub(255, 255, 255, 255);
    glLineWidth(2);
    CGPoint vertices2[] = { ccp(79,299), ccp(134,299), ccp(134,229), ccp(79,229) };
    ccDrawPoly(vertices2, 4, YES);
}

@end
