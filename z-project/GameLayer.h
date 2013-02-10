//
//  HelloWorldLayer.h
//  z-project
//
//  Created by Aurélien Noce on 09/02/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

#import "cocos2d.h"
#import "MiniMap.h"
#import "MenuLayer.h"
#import "TiledMap.h"


@interface GameLayer : CCLayer

@property (nonatomic, strong) TiledMap* map;

+(CCScene *) sceneWithMap:(NSString*)mapName;

@end
