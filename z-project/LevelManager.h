//
//  LevelManager.h
//  z-project
//
//  Created by Lo_c Jalmin on 10/02/13.
//
//

#import <Foundation/Foundation.h>
#import "ScoreCounters.h"

@interface LevelManager : NSObject

@property (nonatomic,retain) NSString            *mapFile;
@property (nonatomic,retain) ScoreCounters       *scoreCounters;
@property (nonatomic,retain) NSMutableDictionary *settings;
@property (nonatomic,readonly) CGFloat           zombieSpeed;

-(id)initWithMap:(NSString *)mapFile;

@end
