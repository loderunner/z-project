//
//  FinishLayer.m
//  z-project
//
//  Created by Raphael on 09/02/13.
//
//

#import "FinishLayer.h"

@implementation FinishLayer

-(FinishLayer*) layer {
    if (self = [self init]) {
    
        CGSize winSize  = [CCDirector sharedDirector].winSize;
        
        // Center the layer
        self.position = CGPointMake(winSize.width/2, winSize.height/2);
        
        CCLabelTTF* finishLabel = [CCLabelTTF labelWithString:@"FAILURE" fontName:@"Helvetica-BoldOblique" fontSize:26];
        finishLabel.position = CGPointMake(0, 200);
        finishLabel.color = ccRED;
        [self addChild:finishLabel];
        
        [self addZombiesCount];
        [self addCivilianCount];
    }
    return self;
}

-(void)addZombiesCount {
    CCNode* node = [CCNode node];
    CCLabelTTF* zombiesLabel = [CCLabelTTF labelWithString:@"Zombies killed:" fontName:@"Helvetica" fontSize:20];
    zombiesLabel.color = ccBLACK;
    zombiesLabel.position = CGPointMake(0, 10);
    
    [node addChild:zombiesLabel];

    int numKilled = 32;
    CCLabelTTF* zombiesCount = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", numKilled] fontName:@"Helvetica-Bold" fontSize:20];
    zombiesCount.color = ccBLACK;
    zombiesCount.position = CGPointMake(0, -10);
    [node addChild:zombiesCount];
    
    node.position = CGPointMake(-100, 100);
    [self addChild:node];
    
}

-(void)addCivilianCount {
    CCNode* node = [CCNode node];
    CCLabelTTF* civilianLabel = [CCLabelTTF labelWithString:@"civilians killed:" fontName:@"Helvetica" fontSize:20];
    civilianLabel.color = ccBLACK;
    civilianLabel.position = CGPointMake(0, 10);
    
    [node addChild:civilianLabel];
    
    int numKilled = 26;
    
    CCLabelTTF* civilianCount = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", numKilled] fontName:@"Helvetica-Bold" fontSize:20];
    civilianCount.color = ccBLACK;
    civilianCount.position = CGPointMake(0, -10);
    [node addChild:civilianCount];
    
    node.position = CGPointMake(100, 100);
    [self addChild:node];
}

@end
