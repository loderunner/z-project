//
//  GameManager.h
//  z-project
//
//  Created by Lo_c Jalmin on 10/02/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "SoundManager.h"

@interface GameManager : NSObject

@property (nonatomic,readonly) SoundManager* soundManager;

+(GameManager*) sharedManager;

-(void) loadFirstScene;
-(void) loadSelectionMenuScene;
-(void)loadLevelWithMap:(NSString*)mapName;

@end
