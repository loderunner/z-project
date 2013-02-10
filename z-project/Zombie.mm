//
//  Zombie.m
//  z-project
//
//  Created by Aurélien Noce on 09/02/13.
//
//

#import "Zombie.h"
#import "Civilian.h"

static CGFloat const SPEED = 60.f;

static NSString* const FRAME_FACING_LEFT = @"zombie-left";
static NSString* const FRAME_FACING_RIGHT = @"zombie-right";
static NSString* const FRAME_FACING_UP = @"zombie-up";
static NSString* const FRAME_FACING_DOWN = @"zombie-down";
static NSString* const FRAME_DEAD = @"zombie-dead";

@interface Zombie()

@end

@implementation Zombie

+ (void)initialize
{
    [super initialize];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"zombie.plist"];
}

-(id)init {
    if (self = [super initWithSpriteFrameName:@"zombie-up" andTag:kTagZombie])
    {
        [self schedule:@selector(followCivilian) interval:1.0f];
        [self followCivilian];
        self.zOrder = kZOrderZombie;
        self.state = kStateAlive;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

-(Zombie *)initWithPosition:(CGPoint)position {
    if (self = [self init]) {
        self.position = position;
        [self.properties setObject:kMinimapSpriteForZombie forKey:kMinimapImageKey];
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
    
    [self unschedule:@selector(followCivilian)];
    [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:FRAME_DEAD]];
    [super kill];
}

-(void)eatCivilian:(Civilian*)civilian
{
    self.state = kStateZombieEating;
    self.position = civilian.position;
    [self scheduleOnce:@selector(doneEating) delay:1];
}

- (void)doneEating
{
    self.state = kStateAlive;
}

-(void)followCivilian {
    CGFloat minDistance2 = CGFLOAT_MAX;
    Civilian* minCivilian = nil;
    for (CCSprite* sprite in self.parent.children)
    {
        if ([sprite isKindOfClass:Civilian.class] && [(Civilian*)sprite isAlive])
        {
            CGFloat distance2 = ccpLengthSQ(ccpSub(sprite.position, self.position));
            if (distance2 < minDistance2)
            {
                minCivilian = (Civilian*)sprite;
                minDistance2 = distance2;
            }
        }
    }
    
    CGFloat angle;
    if (!minCivilian)
    {
        angle = CCRANDOM_MINUS1_1() * M_PI;
    }
    else
    {
        angle = ccpToAngle(ccpSub(minCivilian.position, self.position));
    }
    CGFloat x = cosf(angle) * SPEED;
    CGFloat y = sinf(angle) * SPEED;
    self.velocity = ccp(x, y);
    
    //select frame from angle
    CCSpriteFrameCache* cache = [CCSpriteFrameCache sharedSpriteFrameCache];
    if (angle < -3*M_PI_4)
    {
        [self setDisplayFrame:[cache spriteFrameByName:FRAME_FACING_LEFT]];
    }
    else if (angle < -M_PI_4)
    {
        [self setDisplayFrame:[cache spriteFrameByName:FRAME_FACING_DOWN]];
    }
    else if (angle < M_PI_4)
    {
        [self setDisplayFrame:[cache spriteFrameByName:FRAME_FACING_RIGHT]];
    }
    else if (angle < 3*M_PI_4)
    {
        [self setDisplayFrame:[cache spriteFrameByName:FRAME_FACING_UP]];
    }
    else
    {
        [self setDisplayFrame:[cache spriteFrameByName:FRAME_FACING_LEFT]];
    }
}

@end
