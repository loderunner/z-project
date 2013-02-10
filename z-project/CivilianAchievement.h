//
//  Achievement.h
//  z-project
//
//  Created by Raphael on 10/02/13.
//
//

#import <Foundation/Foundation.h>
#import "AchievementProtocol.h"

@interface CivilianAchievement : NSObject <AchievementProtocol>

@property (nonatomic,readonly) NSString* message;

-(id)initWithNumOfCivilians:(NSInteger)numMaxCivilians;

-(Boolean)testStats:(ScoreCounters*)stat;

@end
