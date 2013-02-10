//
//  SoundManager.h
//  z-project
//
//  Created by Raphael on 10/02/13.
//
//

#import <Foundation/Foundation.h>

#define kSoundDeath1 @"sfx_death1.mp3"
#define kSoundDeath2 @"sfx_death2.mp3"
#define kSoundDeath3 @"sfx_death3.mp3"
#define kSoundDeath4 @"sfx_death4.mp3"
#define kSoundDeath5 @"sfx_death_short2.mp3"
#define kSoundDeath6 @"sfx_death_short4.mp3"
#define kSoundScreamZombie @"sfx_scream_zombie.mp3"
#define kSoundScreamCivilian @"sfx_scream.mp3"
#define kSoundPlay @"sfx_play.mp3"
#define kMusicCity @"sfx_music_city.mp3"
#define kMusicHome @"sfx_music_home.mp3"

@interface SoundManager : NSObject

-(void)startMusic:(NSString*)music;
-(void)stopMusic;
-(void)playSound:(NSString*)sound;
+(SoundManager*)sharedManager;

@end
