//
//  ScoreCounters.h
//  z-project
//
//  Created by Aurélien Noce on 09/02/13.
//
//

#import <Foundation/Foundation.h>

@interface ScoreCounters : NSObject

// initial properties
@property (nonatomic,readonly) NSInteger numZombiesInitial;
@property (nonatomic,readonly) NSInteger numCiviliansInitial;

// generated properties
@property (nonatomic,readonly) NSInteger numZombies;
@property (nonatomic,readonly) NSInteger numCivilians;
@property (nonatomic,readonly) NSInteger numCiviliansKilledByPlayer;
@property (nonatomic,readonly) NSInteger numCiviliansConvertedToZombie;
@property (nonatomic,readonly) NSInteger numZombiesSpawned;
@property (nonatomic,readonly) NSInteger numZombiesKilledByPlayer;

-(void)registerCivilianConvertedToZombie;
-(void)registerZombieKilledByPlayer;
-(void)registerCivilianKilledByPlayer;
-(void)registerZombieSpawned;

-(id)initWithZombies:(NSInteger)zombies civilians:(NSInteger)civilians;

@end
