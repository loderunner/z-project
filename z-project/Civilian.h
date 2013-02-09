//
//  Civilian.h
//  z-project
//
//  Created by Aurélien Noce on 09/02/13.
//
//

#import "cocos2d.h"
#import <Foundation/Foundation.h>

#import "BaseCharacter.h"

@interface Civilian : BaseCharacter


-(Civilian*)initWithPosition:(CGPoint)position;
-(void)infect;
-(void)randomWalk;

@end
