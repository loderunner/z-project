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

@property (nonatomic) CGPoint velocity;

-(Zombie*)initWithPosition:(CGPoint)position;
-(void)followCivilian;

@end
