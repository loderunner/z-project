//
//  Civilian.m
//  z-project
//
//  Created by Aurélien Noce on 09/02/13.
//
//

#import "Civilian.h"
#import "Constants.h"

@interface Civilian()

@property (nonatomic,assign) CGPoint velocity;

@end

@implementation Civilian

-(id)init {
    if (self = [super initWithFile:@"zombie.png" tag:kTagCivilian]) {
        
        //[_sprite schedule:@selector(update:)];
        //[_sprite schedule:@selector(randomWalk) interval:1.0f];
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
    }
    return self;
}

- (void)update:(ccTime)dt
{
    
}

-(void)randomWalk {
    int x = arc4random_uniform(40) - 19;
    int y = arc4random_uniform(40) - 19;
    CCMoveBy* move = [CCMoveBy actionWithDuration:1 position:ccp(x,y)];
    CCCallFunc* loop = [CCCallFunc actionWithTarget:self selector:@selector(randomWalk)];
    CCSequence* seq = [CCSequence actions:move, loop, nil];
    [self runAction:seq];
}

@end
