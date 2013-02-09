//
//  Civilian.m
//  z-project
//
//  Created by Aurélien Noce on 09/02/13.
//
//

#import "Civilian.h"
#import "Zombie.h"

static CGFloat const SPEED = 40.f;

static NSString* const FRAME_FACING_LEFT = @"civilian-left";
static NSString* const FRAME_FACING_RIGHT = @"civilian-right";
static NSString* const FRAME_FACING_UP = @"civilian-up";
static NSString* const FRAME_FACING_DOWN = @"civilian-down";
static NSString* const FRAME_DEAD = @"civilian-dead";
static NSString* const FRAME_DEAD_INFECTED = @"civilian-dead-infected";

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
        [self schedule:@selector(fleeZombie) interval:1.0f];
        [self fleeZombie];
        self.zOrder = kZOrderCivilian;
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

- (BOOL) isAlive
{
    return (self.state == kStateAlive);
}

- (void) kill
{
    self.state = kStateDead;
    [self unschedule:@selector(fleeZombie)];
    [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:FRAME_DEAD]];
    [super kill];
}

- (void) infect
{
    self.state = kStateCivilianDeadInfected;
    [self unschedule:@selector(fleeZombie)];
    [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:FRAME_DEAD_INFECTED]];
}


-(void)fleeZombie {
    CGFloat minDistance2 = CGFLOAT_MAX;
    Zombie* minZombie = nil;
    for (CCSprite* sprite in self.parent.children)
    {
        if ([sprite isKindOfClass:Zombie.class] && [(Civilian*)sprite isAlive])
        {
            CGFloat distance2 = ccpLengthSQ(ccpSub(sprite.position, self.position));
            if (distance2 < minDistance2)
            {
                minZombie = (Zombie*)sprite;
                minDistance2 = distance2;
            }
        }
    }
    
    CGFloat angle = ccpToAngle(ccpSub(self.position, minZombie.position));
    CGFloat x = cosf(angle) * SPEED;
    CGFloat y = sinf(angle) * SPEED;
    self.velocity = ccp(x, y);
    
    //select frame from angle
    CCSpriteFrameCache* cache = [CCSpriteFrameCache sharedSpriteFrameCache];
    if (angle > 7*M_PI_4 || angle <= M_PI_4)
    {
        [self setDisplayFrame:[cache spriteFrameByName:FRAME_FACING_RIGHT]];
    }
    else if (angle > M_PI_4 && angle <= 3*M_PI_4)
    {
        [self setDisplayFrame:[cache spriteFrameByName:FRAME_FACING_UP]];
    }
    else if (angle > 3*M_PI_4 && angle <= 5*M_PI_4)
    {
        [self setDisplayFrame:[cache spriteFrameByName:FRAME_FACING_LEFT]];
    }
    else if (angle > 5*M_PI_4 && angle <= 7*M_PI_4)
    {
        [self setDisplayFrame:[cache spriteFrameByName:FRAME_FACING_DOWN]];
    }
}

@end
