//
//  MenuLayer.m
//  z-project
//
//  Created by Raphael on 09/02/13.
//
//

#import "MenuLayer.h"
#import "cocos2d.h"
#import "Constants.h"

@interface MenuLayer()

@property (nonatomic,assign) CGSize size;
@property (nonatomic,assign) CCLabelTTF* zombieNum;
@property (nonatomic,assign) CCLabelTTF* civilianNum;

@end

@implementation MenuLayer

-(MenuLayer*) layer {
    if (self = [self init]) {
        
        CGSize winSize  = [CCDirector sharedDirector].winSize;
        // TODO change the size with the size of the picture provided by disigners
        _size = CGSizeMake(125, 103);
        CGPoint positionNumber = CGPointMake(93,72);
        // create a few labels with text and selector
        CCSprite* zombieIcone = [CCSprite spriteWithFile:kHeadmenuSpriteForZombie];
        _zombieNum = [CCLabelTTF labelWithString:@"" fontName:@"Helvetica-BoldOblique" fontSize:20];
        CCSprite* civilianIcone = [CCSprite spriteWithFile:kHeadmenuSpriteForCivilian];
        _civilianNum = [CCLabelTTF labelWithString:@"" fontName:@"Helvetica-BoldOblique" fontSize:20];
        
        zombieIcone.position = CGPointMake(_size.width/2 + 20, winSize.height- _size.height/2);
        [self addChild:zombieIcone];
        _zombieNum.position = CGPointMake(positionNumber.x + 20, winSize.height- positionNumber.y);
        [self addChild:_zombieNum];
        
        civilianIcone.position = CGPointMake(winSize.width - _size.width/2 - 20, winSize.height-_size.height/2);
        [self addChild:civilianIcone];
        _civilianNum.position = CGPointMake(winSize.width - positionNumber.x - 20 , winSize.height- positionNumber.y);
        [self addChild:_civilianNum];
    }
    return self;
}

-(void)updateNumberOfCivilian:(int)number {
    [_civilianNum setString:[NSString stringWithFormat:@"%d", number]];
    
    // At the end the game color of the number changes
    if (number < 10) {
        _civilianNum.color = ccRED;
    } else {
        _civilianNum.color = ccWHITE;
    }
}

-(void)updateNumberOfZombie:(int)number {
    [_zombieNum setString:[NSString stringWithFormat:@"%d", number]];
    
    // At the end the game color of the number changes
    if (number < 10) {
        _zombieNum.color = ccGREEN;
    } else {
        _zombieNum.color = ccWHITE;
    }
}

@end
