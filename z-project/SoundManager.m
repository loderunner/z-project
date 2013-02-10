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
                  ,kSoundScreamZombie] retain];
    allMenuSounds = [@[
                  kSoundPlay] retain];
}

+(SoundManager*)sharedManager {
    static SoundManager* manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SoundManager alloc] init];
    });
    return manager;
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
        
        [engine setBackgroundMusicVolume:0.05];
        [engine setEffectsVolume:1];
    }
    return self;
}

-(void)playDeathSound {
    NSUInteger index = arc4random_uniform([allDeathSounds count]);
    NSString *selectedSound = [allDeathSounds objectAtIndex:index];
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
