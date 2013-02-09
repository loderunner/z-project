//
//  Civilian.m
//  z-project
//
//  Created by Aurélien Noce on 09/02/13.
//
//

#import "Civilian.h"
#import "Constants.h"

static CGFloat const SPEED = 40.f;

@interface Civilian()

@end

@implementation Civilian

+ (void)initialize
{
    [super initialize];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"civilian.plist"];
}

-(id)init {
    if (self = [super initWithSpriteFrameName:@"civilian-up" andTag:kTagCivilian])
    {
        [self schedule:@selector(randomWalk) interval:1.0f];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

-(Civilian *)initWithPosition:(CGPoint)position {
    if (self = [self init]) {
        self.position = position;
        [self.properties setObject:kMinimapSpriteForCivilian forKey:kMinimapImageKey];
    }
    return self;
}

-(void)randomWalk {
    CGFloat angle = CCRANDOM_0_1() * 2 * M_PI;
    CGFloat x = cosf(angle) * SPEED;
    CGFloat y = sinf(angle) * SPEED;
    self.velocity = ccp(x, y);
}

@end
