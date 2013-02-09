//
//  HelloWorldLayer.h
//  z-project
//
//  Created by Aurélien Noce on 09/02/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

#import "cocos2d.h"
#import "MiniMap.h"

@interface GameLayer : CCLayer
{
}

@property (nonatomic, strong) CCTMXTiledMap* map;

+(CCScene *) scene;

@end
