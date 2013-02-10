//
//  Achievement.m
//  z-project
//
//  Created by Raphael on 10/02/13.
//
//

#import "CivilianAchievement.h"


@interface CivilianAchievement()

@property (nonatomic,assign) NSInteger numMax;

@end


@implementation CivilianAchievement

-(id)initWithNumOfCivilians:(NSInteger)numMaxCivilians {
    
    if (self = [super init]) {
        _numMax = numMaxCivilians;
        _message = [NSString stringWithFormat:@"Less than %d civilians killed", _numMax];
    }
    return self;
}

-(Boolean)testStats:(ScoreCounters *)stat {
    NSInteger numCivilianKilled = stat.numCiviliansKilledByPlayer + stat.numCiviliansConvertedToZombie;
    return (numCivilianKilled < _numMax);
}

@end
