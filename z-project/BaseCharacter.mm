//
//  BaseCharacter.m
//  z-project
//
//  Created by Aurélien Noce on 09/02/13.
//
//

#import "BaseCharacter.h"
#import "cocos2d.h"

@interface BaseCharacter ()

@end

@implementation BaseCharacter

-(id)initWithSpriteFrameName:(NSString*)frame andTag:(NSInteger)tag; {
    if (self = [super initWithSpriteFrameName:frame]) {
        _properties = [[NSMutableDictionary alloc] init];
        _touching = [[NSMutableArray alloc] init];
        
        self.tag = tag;
        self.state = kStateAlive;
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
    [_touching release];
    
    [super dealloc];
}

- (void)update:(ccTime)dt
{
    if ([self isAlive])
    {
        CGPoint pos = self.position;
        CGPoint halfSize = ccpMult(ccpFromSize(self.boundingBox.size), .5f);
        CGFloat moveX = _velocity.x * dt;
        CGFloat moveY = _velocity.y * dt;
        
        pos = ccpAdd(pos, ccp(moveX, moveY));
        
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
        [self kill];
        return YES;
    }
    return NO;
}

-(void)kill
{
    self.zOrder = kZOrderDead;
}

- (BOOL)isAlive
{
    return NO;
}

- (void)solveCollisions
{
    BOOL overlapping = NO;
    CGFloat distance;
    CGFloat overlapX = 0.0f;
    CGFloat overlapY = 0.0f;
    
    for (BaseCharacter* tile in self.touching)
    {
        distance = 0.0f;
        //calculate overlap X
        if (self.right > tile.left && self.right < tile.right)
        {
            distance = tile.left - self.right;
        }
        else if (self.left > tile.left && self.left < tile.right)
        {
            distance = tile.right - self.left;
        }
        //use square of overlap (for absolute value)
        if ((distance * distance) > (overlapX * overlapX))
        {
            overlapping = YES;
            overlapX = distance;
        }
        
        distance = 0.0f;
        //calculate overlap Y
        if (self.top > tile.bottom && self.top < tile.top)
        {
            distance = tile.bottom - self.top;
        }
        else if (self.bottom > tile.bottom && self.bottom < tile.top)
        {
            distance = tile.top - self.bottom;
        }
        //use square of overlap (for absolute value)
        if ((distance * distance) > (overlapY * overlapY))
        {
            overlapping = YES;
            overlapY = distance;
        }
    }
    
    if (overlapping)
    {
        if (overlapX*overlapX < overlapY*overlapY)
        {
            self.position = ccp(self.position.x + overlapX, self.position.y);
        }
        else
        {
            self.position = ccp(self.position.x, self.position.y + overlapY);
        }
    }
    
    [self.touching removeAllObjects];
}

- (CGRect)getCGRect
{
    return CGRectMake(self.left, self.top, self.contentSize.width, self.contentSize.height);
}


@end
