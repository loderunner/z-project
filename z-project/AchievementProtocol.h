//
//  AchievementProtocol.h
//  z-project
//
//  Created by Raphael on 10/02/13.
//
//

#import <Foundation/Foundation.h>
#import "ScoreCounters.h"

@protocol AchievementProtocol <NSObject>
@required
- (Boolean) testStats: (ScoreCounters*)stat;
@property (nonatomic,readonly) NSString* message;
@end
