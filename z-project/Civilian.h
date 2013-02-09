//
//  Civilian.h
//  z-project
//
//  Created by Aurélien Noce on 09/02/13.
//
//

#import "cocos2d.h"
#import <Foundation/Foundation.h>

@interface Civilian : NSObject

-(Civilian*)initWithPosition:(CGPoint)position;
-(CCSprite*)sprite;
-(void)randomWalk;

@end
