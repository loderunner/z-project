//
//  LevelManager.m
//  z-project
//
//  Created by Lo_c Jalmin on 10/02/13.
//
//

#import "LevelManager.h"

@implementation LevelManager

-(id)initWithMap:(NSString *)mapFile {
    if (self = [super init]) {
        _scoreCounters = [[ScoreCounters alloc] init];
        _settings = [[NSMutableDictionary alloc] init];
        _mapFile = [mapFile retain];
    }
    return self;
}

-(CGFloat) zombieSpeed {
    NSNumber* speed = [self.settings valueForKey:@"zombieSpeed"];
    return [speed floatValue];
}

-(void)dealloc {
    [_mapFile release];
    [_scoreCounters release];
    [_settings release];
    [super dealloc];
}

@end
