//
//  MenuLayer.h
//  z-project
//
//  Created by Raphael on 09/02/13.
//
//

#import "cocos2d.h"

@interface MenuLayer : CCLayer

-(MenuLayer*)layer;

-(void)updateNumberOfCivilian:(int)number;
-(void)updateNumberOfZombie:(int)number;

@end
