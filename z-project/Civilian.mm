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

static NSString* const FRAME_FACING_LEFT = @"civilian-left";
static NSString* const FRAME_FACING_RIGHT = @"civilian-right";
static NSString* const FRAME_FACING_UP = @"civilian-up";
static NSString* const FRAME_FACING_DOWN = @"civilian-down";
static NSString* const FRAME_DEAD = @"civilian-dead";

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
        [self schedule:@selector(randomWalk) interval:2.0f];
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
