//
//  Zombie.h
//  z-project
//
//  Created by Aurélien Noce on 09/02/13.
//
//

#import "BaseCharacter.h"

#import "cocos2d.h"
#import <Foundation/Foundation.h>

@interface Zombie : BaseCharacter

-(Zombie*)initWithPosition:(CGPoint)position;
-(void)randomWalk;

@end
