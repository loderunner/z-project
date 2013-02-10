//
//  FinishLayer.h
//  z-project
//
//  Created by Raphael on 09/02/13.
//
//

#import "cocos2d.h"
#import "ScoreCounters.h"

@interface FinishLayer : CCLayer


-(FinishLayer *) layerWithStat:(ScoreCounters*)stat;

@end
