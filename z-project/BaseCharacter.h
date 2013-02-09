//
//  BaseCharacter.h
//  z-project
//
//  Created by Aurélien Noce on 09/02/13.
//
//

#import "CCSprite.h"

@interface BaseCharacter : CCSprite

@property (nonatomic,retain) NSMutableDictionary* properties;

-(id)initWithFile:(NSString*)file tag:(NSInteger)tag;

@end
