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
@property (nonatomic,retain) NSMutableDictionary* properties;
@property (nonatomic, readonly) CGRect hitBox;

// helpers for edges
@property (nonatomic, readonly) CGFloat left;
@property (nonatomic, readonly) CGFloat top;
@property (nonatomic, readonly) CGFloat right;
@property (nonatomic, readonly) CGFloat bottom;

- (id)initWithSpriteFrameName:(NSString*)file andTag:(NSInteger)tag;
-(void)kill;
-(BOOL)isAlive;

@end
