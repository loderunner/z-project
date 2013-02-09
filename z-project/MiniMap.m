//
//  MiniMap.m
//  z-project
//
//  Created by Aurélien Noce on 09/02/13.
//
//

#import <GLKit/GLKit.h>
#import "cocos2d.h"
#import "MiniMap.h"
#import "Civilian.h"

@interface MiniMap()

@property (nonatomic,assign) CGPoint point;
@property (nonatomic,assign) CGSize  size;
@property (nonatomic,assign) float   ratio;

@end

@implementation MiniMap

-(MiniMap*)initWithPosition:(CGPoint)point size:(CGSize)size andRatio:(float)ratio {
    if (self = [self init]) {
        self.point = point;
        self.size  = size;
        self.ratio = ratio;
    }
    return self;
}

- (void)draw
{
    glEnable(GL_LINE_SMOOTH);
    glColor4ub(255, 255, 255, 255);
    glLineWidth(2);
    CGPoint vertices2[] = { self.point, ccp(self.point.x+self.size.width,self.point.y), ccp(self.point.x+self.size.width,self.point.y+self.size.height), ccp(self.point.x,self.point.y+self.size.height) };
    ccDrawPoly(vertices2, 4, YES);
}

-(void)updateMiniMap:(NSArray*)civilians {
    [self removeAllChildrenWithCleanup:YES];
    for (Civilian* c in civilians) {
        CGPoint originalPosition = c.sprite.position;
        CGPoint positionInMinimap = ccp(originalPosition.x*self.ratio,originalPosition.y*self.ratio);
        CCSprite* sprite = [CCSprite spriteWithFile:@"icon_civilian.png"];
        sprite.position = positionInMinimap;
        [self addChild:sprite];
    }
    
}

@end
