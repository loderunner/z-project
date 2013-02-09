//
//  Zombie.m
//  z-project
//
//  Created by Aurélien Noce on 09/02/13.
//
//

#import "Zombie.h"
#import "Tags.h"

static CGFloat const SPEED = 40.f;

@interface Zombie()

@property (nonatomic, strong) CCSprite* sprite;
@property (nonatomic) CGPoint velocity;

@end

@implementation Zombie

-(id)init {
    if (self = [super initWithFile:@"zombie.png"]) {
        self.tag = TagZombie;
        
        [self schedule:@selector(update:)];
        [self schedule:@selector(randomWalk) interval:1.0f];
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
    }
    return self;
}

- (void)update:(ccTime)dt
{
    CGPoint pos = self.position;
    CGPoint move = ccpMult(_velocity, dt);
    pos = ccpAdd(pos, move);
    
    self.position = pos;
}

-(void)randomWalk {
    CGFloat angle = CCRANDOM_0_1() * 2 * M_PI;
    CGFloat x = cosf(angle) * SPEED;
    CGFloat y = sinf(angle) * SPEED;
    _velocity = ccp(x, y);
}

@end
