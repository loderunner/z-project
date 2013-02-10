//
//  FinishLayer.m
//  z-project
//
//  Created by Raphael on 09/02/13.
//
//

#import "FinishLayer.h"
#import <GLKit/GLKit.h>
#import "Constants.h"
#import "AchievementProtocol.h"
#import "CivilianAchievement.h"

@interface FinishLayer()

@property (nonatomic,assign) ScoreCounters* stat;

@end

@implementation FinishLayer

-(FinishLayer*) layerWithStat:(ScoreCounters*)stat {
    if (self = [self init]) {
    
        _stat = stat;
        CGSize winSize  = [CCDirector sharedDirector].winSize;
        
        // Center the layer
        self.position = CGPointMake(winSize.width/2, winSize.height/2);
        
        NSString* finishTitle;
        ccColor3B titleColor;
        
        if ([_stat numCivilians] == 0)
        {
            finishTitle = @"FAILURE";
            titleColor = ccRED;
        } else {
            finishTitle = @"SUCCESS";
            titleColor = ccGREEN;
        }
        
        CCLabelTTF* finishLabel = [CCLabelTTF labelWithString:finishTitle fontName:@"Helvetica-BoldOblique" fontSize:26];
        finishLabel.position = CGPointMake(0, 100);
        finishLabel.color = titleColor;
        [self addChild:finishLabel];
        
        [self addCount];
        [self addAchievements];
    }
    return self;
}

- (void)draw
{
    CGSize winSize  = [CCDirector sharedDirector].winSize;
    
    glEnable(GL_LINE_SMOOTH);
    glColor4ub(255, 255, 255, 255);
    glLineWidth(2);
    ccColor4F fillColor = kFinishmenuFillColor;
    CGPoint point = CGPointMake( - winSize.width / 4, - winSize.height / 4);
    
    ccDrawSolidRect(point,ccp(point.x + winSize.width / 2, point.y + winSize.height / 2 ), fillColor);
}

-(void)addCount {
    CCNode* countNode = [CCNode node];
    
    CCNode* zombieNode = [CCNode node];
    CCLabelTTF* zombiesLabel = [CCLabelTTF labelWithString:@"Zombies killed:" fontName:@"Helvetica" fontSize:20];
    zombiesLabel.color = ccBLACK;
    zombiesLabel.position = CGPointMake(0, 10);
    
    [zombieNode addChild:zombiesLabel];

    int zombieNumKilled = _stat.numZombiesKilledByPlayer;
    
    CCLabelTTF* zombiesCount = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", zombieNumKilled] fontName:@"Helvetica-Bold" fontSize:20];
    zombiesCount.color = ccBLACK;
    zombiesCount.position = CGPointMake(0, -10);
    [zombieNode addChild:zombiesCount];
    
    zombieNode.position = CGPointMake(-100, 0);
    [countNode addChild:zombieNode];
    
    CCNode* civilianNode = [CCNode node];
    CCLabelTTF* civilianLabel = [CCLabelTTF labelWithString:@"Civilians saved:" fontName:@"Helvetica" fontSize:20];
    civilianLabel.color = ccBLACK;
    civilianLabel.position = CGPointMake(0, 10);
    
    [civilianNode addChild:civilianLabel];
    
    int civilianNumKilled = _stat.numCivilians;
    
    CCLabelTTF* civilianCount = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", civilianNumKilled] fontName:@"Helvetica-Bold" fontSize:20];
    civilianCount.color = ccBLACK;
    civilianCount.position = CGPointMake(0, -10);
    [civilianNode addChild:civilianCount];
    
    civilianNode.position = CGPointMake(100, 0);
    [countNode addChild:civilianNode];
    
    [self addChild:countNode];
}

-(void)addAchievements {
    
    NSMutableArray *achievementList = [[NSMutableArray alloc] init];
    
    [achievementList addObject:[[CivilianAchievement alloc] initWithNumOfCivilians:5]];

    [achievementList addObject:[[CivilianAchievement alloc] initWithNumOfCivilians:10]];

    [achievementList addObject:[[CivilianAchievement alloc] initWithNumOfCivilians:15]];
    
    CCNode* achievementNode = [CCNode node];
    
    achievementNode.position = CGPointMake(0, -100);
    
    for (NSUInteger i = 0; i < [achievementList count]; i++) {
        id <AchievementProtocol> achievement = [achievementList objectAtIndex:i];
        NSMutableString *message;
        if ([achievement testStats:_stat]) {
            //TODO add a beautiful imagie in case of successful achievement
            message = [NSMutableString stringWithString:@"v "];
        } else {
            message = [NSMutableString stringWithString:@"x "];
        }
    
        [message appendString:achievement.message];
    
        CCLabelTTF* achievementLabel = [CCLabelTTF labelWithString:message fontName:@"Helvetica" fontSize:20];
        
        achievementLabel.position = CGPointMake(0, i * 20);
        [achievementNode addChild:achievementLabel];
    }
    
    [self addChild:achievementNode];
}

@end
