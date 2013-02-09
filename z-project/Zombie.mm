//
//  Zombie.m
//  z-project
//
//  Created by Aurélien Noce on 09/02/13.
//
//

#import "Zombie.h"
#import "Constants.h"

static CGFloat const SPEED = 40.f;

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
        [self schedule:@selector(randomWalk) interval:2.0f];
        self.zOrder = kZOrderZombie;
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

- (void) kill
{
    [self unschedule:@selector(randomWalk)];
    [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:FRAME_DEAD]];
    [super kill];
}

-(void)randomWalk {
    CGFloat angle = CCRANDOM_0_1() * 2 * M_PI;
    CGFloat x = cosf(angle) * SPEED;
    CGFloat y = sinf(angle) * SPEED;
    self.velocity = ccp(x, y);
    
    //select frame from angle
    CCSpriteFrameCache* cache = [CCSpriteFrameCache sharedSpriteFrameCache];
    if (angle > 7*M_PI_4 || angle < M_PI_4)
    {
        [self setDisplayFrame:[cache spriteFrameByName:FRAME_FACING_RIGHT]];
    }
    else if (angle < 3*M_PI_4)
    {
        [self setDisplayFrame:[cache spriteFrameByName:FRAME_FACING_UP]];
    }
    else if (angle < 5*M_PI_4)
    {
        [self setDisplayFrame:[cache spriteFrameByName:FRAME_FACING_LEFT]];
    }
    else if (angle < 3*M_PI_4)
    {
        [self setDisplayFrame:[cache spriteFrameByName:FRAME_FACING_DOWN]];
    }
}

@end
