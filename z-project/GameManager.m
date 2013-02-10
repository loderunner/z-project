//
//  GameManager.m
//  z-project
//
//  Created by Lo_c Jalmin on 10/02/13.
//
//

#import "GameManager.h"
#import "IntroLayer.h"
#import "MainMenuLayer.h"
#import "LevelManager.h"
#import "GameLayer.h"

typedef enum {
    kGameStateNotRunning = 0,
    kGameStateSplashScreen,
    kGameStateLevelSelectionMenu,
    kGameStateInGame,
    kGameStatePaused
} GameState;

typedef enum {
    kGameDifficultyEasy,
    kGameDifficultyNormal,
    kGameDifficultyHard
} GameDifficulty;

@interface GameManager()

@property (nonatomic,assign) GameState state;
@property (nonatomic,retain) LevelManager *level;

@end

@implementation GameManager

+(GameManager*) sharedManager {
    static GameManager* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GameManager alloc] init];
    });
    return instance;
}

-(id)init {
    if (self = [super init]) {
        _state = kGameStateNotRunning;
        _soundManager = [[SoundManager alloc] init];
    }
    return self;
}

-(LevelManager*) currentLevel {
    return self.level;
}

#pragma mark - scene transition helpers (public API)

-(void)loadFirstScene {
    [self transitionStateTo:kGameStateSplashScreen];
}

-(void)loadSelectionMenuScene {
    [self transitionStateTo:kGameStateLevelSelectionMenu];
}

-(void)loadLevelWithMap:(NSString*)mapName {
    [self loadLevelWithMap:mapName andDifficulty:kGameDifficultyNormal];
}

-(void)loadLevelWithMap:(NSString*)mapName andDifficulty:(GameDifficulty)difficulty {
    self.level = [[LevelManager alloc] initWithMap:mapName];
    switch (difficulty) {
        case kGameDifficultyEasy:
            [self.level.settings setObject:[NSNumber numberWithFloat:50.0] forKey:@"zombieSpeed"];
            break;
        case kGameDifficultyNormal:
            [self.level.settings setObject:[NSNumber numberWithFloat:80.0] forKey:@"zombieSpeed"];
            break;
        case kGameDifficultyHard:
            [self.level.settings setObject:[NSNumber numberWithFloat:100.0] forKey:@"zombieSpeed"];
            break;
        default:
            break;
    }
    [self transitionStateTo:kGameStateInGame];
}

#pragma mark - state transition mechanics (actual State Machine)

-(void)loadInitialScene:(CCScene*)scene {
    CCDirector* director = [CCDirector sharedDirector];
    [director pushScene: scene];
}

-(void)transitionToScene:(CCScene*)scene duration:(float)duration {
    CCDirector* director = [CCDirector sharedDirector];

    CCTransitionFade *transition = [CCTransitionFade
                                    transitionWithDuration:duration
                                    scene:scene
                                    withColor:ccBLACK];
    [director replaceScene:transition];
}

-(void)transitionStateTo:(GameState)newState {
    // detect and transition the scenes
    GameState previousState = self.state;
    switch (previousState) {
        case kGameStateNotRunning:
            if (newState == kGameStateSplashScreen) {
                // OFF -> Splash Screen
                CCScene* scene = [IntroLayer scene];
                [self loadInitialScene:scene];
                self.state = kGameStateSplashScreen;
            }
            break;
        case kGameStateSplashScreen:
            if (newState == kGameStateLevelSelectionMenu) {
                // Splash Screen -> Level Selection
                CCScene *menuScene = [MainMenuLayer scene];
                [self transitionToScene:menuScene duration:0.5];
                self.state = kGameStateLevelSelectionMenu;
                // sound events
                [self.soundManager startMusic:kMusicHome];
            }
            break;
        case kGameStateLevelSelectionMenu:
            if (newState == kGameStateInGame) {
                // Level Selection -> In Game
                CCScene *gameScene = [GameLayer sceneForLevel:self.level];
                [self transitionToScene:gameScene duration:1.0];
                // sound events
                [self.soundManager startMusic:kMusicCity];
            }
            break;
        default:
            break;
    }
    
    if (previousState != self.state) {
        NSLog(@"Game State transitionned from %d to %d",previousState,self.state);
    }
}

#pragma mark - cleanup

-(void)dealloc {
    [_soundManager release];
    [super dealloc];
}

@end
