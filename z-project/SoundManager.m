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
    allMusics = @[
                  kMusicCity,
                  kMusicHome];
    allDeathSounds = @[
                  kSoundDeath1
                  ,kSoundDeath2
                  ,kSoundDeath3
                  ,kSoundDeath4
                  ,kSoundDeath5
                  ,kSoundDeath6
                  ];
    allDeathScreams = @[
                  kSoundScreamCivilian
                  ,kSoundScreamZombie];
    allMenuSounds = @[
                  kSoundPlay];
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
            [engine preloadBackgroundMusic:sound];
        }
        for (NSString* sound in allDeathScreams) {
            [engine preloadBackgroundMusic:sound];
        }
    }
    return self;
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
