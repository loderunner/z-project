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
        CGPoint halfSize = ccpMult(ccpFromSize(self.boundingBox.size), .5f);
        CGPoint move = ccpMult(_velocity, dt);
        pos = ccpAdd(pos, move);
        
        //clip character to edges
        if (pos.x - halfSize.x < 0)
        {
            pos = ccp(halfSize.x, pos.y);
        }
        if (pos.x + halfSize.x > self.parent.contentSize.width)
        {
            pos = ccp(self.parent.contentSize.width - halfSize.x, pos.y);
        }
        
        if (pos.y - halfSize.y < 0)
        {
            pos = ccp(pos.x, halfSize.y);
        }
        if (pos.y + halfSize.y > self.parent.contentSize.height)
        {
            pos = ccp(pos.x, self.parent.contentSize.height - halfSize.y);
        }
        
        self.position = pos;
    }
}

-(BOOL)takeDamage:(NSInteger)damage {
    self.stamina -= damage;
    if (self.stamina < 0) {
        [self die];
        return YES;
    }
    return NO;
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
