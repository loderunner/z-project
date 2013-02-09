//
//  ScoreCounters.m
//  z-project
//
//  Created by Aurélien Noce on 09/02/13.
//
//

#import "ScoreCounters.h"

@implementation ScoreCounters

-(id)initWithZombies:(NSInteger)zombies civilians:(NSInteger)civilians {
    if (self = [super init]) {
        // save initial settings
        _numCiviliansInitial = civilians;
        _numZombiesInitial   = zombies;
        // start values
        _numCiviliansConvertedToZombie = 0;
        _numCiviliansKilledByPlayer    = 0;
        _numZombiesKilledByPlayer      = 0;
        _numZombiesSpawned             = 0;
    }
    return self;
}

-(void)registerCivilianConvertedToZombie {
    _numCiviliansConvertedToZombie += 1;
}

-(void)registerCivilianKilledByPlayer {
    _numCiviliansKilledByPlayer += 1;
}

-(void)registerZombieKilledByPlayer {
    _numZombiesKilledByPlayer += 1;
}

-(void)registerZombieSpawned {
    _numZombiesSpawned += 1;
}


-(NSInteger)numCivilians {
    return self.numCiviliansInitial
        - self.numCiviliansConvertedToZombie
        - self.numCiviliansKilledByPlayer;
}

-(NSInteger)numZombies {
    return self.numZombiesInitial
    - self.numZombiesKilledByPlayer
    + self.numCiviliansConvertedToZombie
    + self.numZombiesSpawned;

}

@end
