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

typedef enum
{
    kStateAlive = 0,
    kStateDead
}
State;

@interface Civilian()

@property (nonatomic, assign) CGPoint velocity;
@property (nonatomic) State state;

@end

@implementation Civilian

-(id)init {
    if (self = [super initWithFile:@"civilian.png" tag:kTagCivilian])
    {
        [self schedule:@selector(update:)];
        [self schedule:@selector(randomWalk) interval:1.0f];
        _state = kStateAlive;
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

- (void)update:(ccTime)dt
{
    if ([self isAlive])
    {
        CGPoint pos = self.position;
        CGPoint move = ccpMult(_velocity, dt);
        pos = ccpAdd(pos, move);
        
        self.position = pos;
    }
}

-(void)randomWalk {
    CGFloat angle = CCRANDOM_0_1() * 2 * M_PI;
    CGFloat x = cosf(angle) * SPEED;
    CGFloat y = sinf(angle) * SPEED;
    _velocity = ccp(x, y);
}

-(void)kill
{
    _state = kStateDead;
}

-(BOOL)isAlive
{
    return (_state == kStateAlive);
}

@end
