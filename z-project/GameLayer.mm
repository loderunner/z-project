//
//  HelloWorldLayer.mm
//  z-project
//
//  Created by Aurélien Noce on 09/02/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

// Import the interfaces
#import "GameLayer.h"
#import "AppDelegate.h"


#pragma mark - GameLayer

@interface GameLayer()
@end

@implementation GameLayer {
    CGSize winSize;
    CGSize mapSize;
    CGSize tileSize;
}

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
    GameLayer *layer = [GameLayer node];
	
	[scene addChild: layer];
	
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
        //CGSize s = [CCDirector sharedDirector].winSize;
        // save all sizes
        winSize  = [CCDirector sharedDirector].winSize;
        mapSize  = self.map.mapSize;
        tileSize = self.map.tileSize;

        self.map = [CCTMXTiledMap tiledMapWithTMXFile:@"firsMap.tmx"];
        self.map.anchorPoint = CGPointZero;
        //CCTMXLayer*    layer = [self.map layerNamed:@"map"];
        
        [self addChild:self.map];
		
        
        self.isTouchEnabled = YES;
		
	}
	return self;
}

-(void) registerWithTouchDispatcher
{
	CCDirector *director = [CCDirector sharedDirector];
	[[director touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

#pragma mark - touch events

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	return YES;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint touchLocation = [touch locationInView: [touch view]];
	CGPoint prevLocation  = [touch previousLocationInView: [touch view]];
    
	touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
	prevLocation  = [[CCDirector sharedDirector] convertToGL: prevLocation];
    
	CGPoint diff = ccpSub(touchLocation,prevLocation);
    
    CGPoint currentPos = [self.map position];
    CGPoint newPos     = ccpAdd(currentPos, diff);
    
    if (newPos.x > 0) newPos.x = 0;
    if (newPos.y > 0) newPos.y = 0;

    float layerHeight = tileSize.height * mapSize.height;
    float winHeight   = winSize.height;
    float minimumY    = winHeight-layerHeight;
    if (newPos.y < minimumY) newPos.y = minimumY;
    
    float layerWidth = tileSize.width * mapSize.width;
    float winWidth   = winSize.width;
    float minimumX   = winWidth-layerWidth;
    if (newPos.x < minimumX) newPos.x = minimumX;

	[self.map setPosition: newPos];
}


@end
