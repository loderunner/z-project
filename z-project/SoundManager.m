//
//  SoundManager.m
//  z-project
//
//  Created by Raphael on 10/02/13.
//
//

#import "SoundManager.h"
#import "SimpleAudioEngine.h"

static NSArray* allMusics;
static NSArray* allDeathSounds;
static NSArray* allDeathScreams;
static NSArray* allDeathScreamsZombie;
static NSArray* allMenuSounds;

@interface SoundManager()
@end

@implementation SoundManager

+(void)initialize {
    allMusics = [@[
                  kMusicCity,
                  kMusicHome] retain];
    allDeathSounds = [@[
                  kSoundDeath1
                  ,kSoundDeath2
                  ,kSoundDeath3
                  ,kSoundDeath4
                  ,kSoundDeath5
                  ,kSoundDeath6
                  ] retain];
    allDeathScreams = [@[
                  kSoundScreamCivilian
                  ] retain];
    allDeathScreamsZombie = [@[kSoundScreamZombie1
                        ,kSoundScreamZombie2
                        ,kSoundScreamZombie3
                        ,kSoundScreamZombie4
                        ] retain];
    allMenuSounds = [@[
                  kSoundPlay] retain];
}

-(id)init {
    if (self = [super init]) {
        SimpleAudioEngine* engine = [SimpleAudioEngine sharedEngine];
        for (NSString* music in allMusics) {
            [engine preloadBackgroundMusic:music];
        }
        for (NSString* sound in allDeathSounds) {
            [engine preloadEffect:sound];
        }
        for (NSString* sound in allDeathScreams) {
            [engine preloadEffect:sound];
        }
        for (NSString* sound in allMenuSounds) {
            [engine preloadEffect:sound];
        }
        for (NSString* sound in allDeathScreamsZombie) {
            [engine preloadEffect:sound];
        }
        
        [engine setBackgroundMusicVolume:.2];
        [engine setEffectsVolume:.2];
    }
    return self;
}

-(void)playDeathSound {
    NSUInteger index = arc4random_uniform([allDeathSounds count]);
    NSString *selectedSound = [allDeathSounds objectAtIndex:index];
    [self playSound:selectedSound];
}

-(void)playScreamZombie {
    NSUInteger index = arc4random_uniform([allDeathScreamsZombie count]);
    NSString *selectedSound = [allDeathScreamsZombie objectAtIndex:index];
    [self playSound:selectedSound];
}

-(void)playSound:(NSString *)sound {
    [[SimpleAudioEngine sharedEngine] playEffect:sound];
}

-(void)startMusic:(NSString *)music {
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:music loop:YES];
}

-(void)stopMusic {
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

@end
