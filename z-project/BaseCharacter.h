//
//  BaseCharacter.h
//  z-project
//
//  Created by Aurélien Noce on 09/02/13.
//
//

#import "CCSprite.h"

@interface BaseCharacter : CCSprite

@property (nonatomic, assign) CGPoint velocity;
@property (nonatomic,retain)  NSMutableDictionary* properties;

@property (nonatomic,assign) NSInteger stamina;

// helpers for edges
@property (nonatomic, readonly) CGFloat left;
@property (nonatomic, readonly) CGFloat top;
@property (nonatomic, readonly) CGFloat right;
@property (nonatomic, readonly) CGFloat bottom;

- (id)initWithSpriteFrameName:(NSString*)file andTag:(NSInteger)tag;
-(void)die;
-(BOOL)isAlive;

-(BOOL)takeDamage:(NSInteger)damage;

@end
