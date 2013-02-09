//
//  Civilian.m
//  z-project
//
//  Created by Aurélien Noce on 09/02/13.
//
//

#import "Civilian.h"
#import "Tags.h"

@interface Civilian()

@property (nonatomic,strong) CCSprite* sprite;

@end

@implementation Civilian

-(id)init {
    if (self = [super init]) {
        _sprite = [[CCSprite spriteWithFile:@"zombie.png"] retain];
        _sprite.tag = TagCivilian;
    }
    return self;
}

- (void)dealloc
{
    [_sprite release];
    [super dealloc];
}

-(Civilian *)initWithPosition:(CGPoint)position {
    if (self = [self init]) {
        self.sprite.position = position;
    }
    return self;
}

-(void)randomWalk {
    int x = arc4random_uniform(40) - 19;
    int y = arc4random_uniform(40) - 19;
    CCMoveBy* move = [CCMoveBy actionWithDuration:1 position:ccp(x,y)];
    CCCallFunc* loop = [CCCallFunc actionWithTarget:self selector:@selector(randomWalk)];
    CCSequence* seq = [CCSequence actions:move, loop, nil];
    [self.sprite runAction:seq];
}

@end
