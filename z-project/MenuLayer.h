//
//  MenuLayer.h
//  z-project
//
//  Created by Raphael on 09/02/13.
//
//

#import "CCMenu.h"
#import "cocos2d.h"

@interface MenuLayer : CCLayer

-(MenuLayer*)initWithWinSize:(CGSize)winSize;

-(void)updateNumberOfCivilian:(int)number;
-(void)updateNumberOfZombie:(int)number;

@end
