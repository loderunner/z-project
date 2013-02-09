//
//  BaseCharacter.m
//  z-project
//
//  Created by Aurélien Noce on 09/02/13.
//
//

#import "BaseCharacter.h"
#import "cocos2d.h"

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
    _state = kStateDead;
}

-(BOOL)isAlive
{
    return (_state == kStateAlive);
}

- (CGRect)hitBox
{
    return CGRectMake(32, 32, 64, 88);
}


@end
