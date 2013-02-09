//
//  MenuLayer.m
//  z-project
//
//  Created by Raphael on 09/02/13.
//
//

#import "MenuLayer.h"
#import "cocos2d.h"

@interface MenuLayer()

@property (nonatomic,assign) CGSize size;
@property (nonatomic,assign) CCLabelTTF* zombieNum;
@property (nonatomic,assign) CCLabelTTF* civilianNum;

@end

@implementation MenuLayer

-(MenuLayer*)initWithWinSize:(CGSize)winSize {
    if (self = [self init]) {
        _size = CGSizeMake(100, 100);
        // create a few labels with text and selector
        CCLabelTTF* zombieLabel = [CCLabelTTF labelWithString:@"Zombies" fontName:@"Helvetica-BoldOblique" fontSize:26];
        _zombieNum = [CCLabelTTF labelWithString:@"" fontName:@"Helvetica-BoldOblique" fontSize:26];
        CCLabelTTF* civilianLabel = [CCLabelTTF labelWithString:@"Civilians" fontName:@"Helvetica-BoldOblique" fontSize:26];
        _civilianNum = [CCLabelTTF labelWithString:@"" fontName:@"Helvetica-BoldOblique" fontSize:26];
        
        zombieLabel.position = CGPointMake(_size.width/2, winSize.height- _size.height/2);
        [self addChild:zombieLabel];
        _zombieNum.position = CGPointMake(3 * _size.width/2, winSize.height-_size.height/2);
        [self addChild:_zombieNum];
        civilianLabel.position = CGPointMake(winSize.width - _size.width/2, winSize.height-_size.height/2);
        [self addChild:civilianLabel];
        _civilianNum.position = CGPointMake(winSize.width - 3 * _size.width/2, winSize.height-_size.height/2);
        [self addChild:_civilianNum];
    }
    return self;
}

-(void)updateNumberOfCivilian:(int)number {
    [_civilianNum setString:[NSString stringWithFormat:@"%d", number]];
}

-(void)updateNumberOfZombie:(int)number {
    [_zombieNum setString:[NSString stringWithFormat:@"%d", number]];
}

@end
