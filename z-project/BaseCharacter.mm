//
//  BaseCharacter.m
//  z-project
//
//  Created by Aurélien Noce on 09/02/13.
//
//

#import "BaseCharacter.h"
#import "cocos2d.h"
#import "Constants.h"

typedef enum
{
    kStateAlive = 0,
    kStateDead
}
State;

@interface BaseCharacter ()

@property (nonatomic) State state;

@end

@implementation BaseCharacter

-(id)initWithSpriteFrameName:(NSString*)frame andTag:(NSInteger)tag; {
    if (self = [super initWithSpriteFrameName:frame]) {
        _properties = [[NSMutableDictionary alloc] init];
        _state = kStateAlive;
        
        self.tag = tag;
        
        [self schedule:@selector(update:)];
    }
    return self;
}

- (CGFloat)left
{
    return self.position.x - self.contentSize.width * .5f;
}


- (CGFloat)right
{
    return self.position.x + self.contentSize.width * .5f;
}


- (CGFloat)bottom
{
    return self.position.y - self.contentSize.height * .5f;
}


- (CGFloat)top
{
    return self.position.y + self.contentSize.height * .5f;
}

-(void)dealloc {
    [_properties release];
    
    [super dealloc];
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

-(void)kill
{
    self.state = kStateDead;
    self.zOrder = kZOrderDead;
}

-(BOOL)isAlive
{
    return (_state == kStateAlive);
}


@end
