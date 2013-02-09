//
//  MenuLayer.m
//  z-project
//
//  Created by Raphael on 09/02/13.
//
//

#import "MenuLayer.h"
#import "cocos2d.h"

@interface MenuLayer()

@property (nonatomic,assign) CGSize size;

@end

@implementation MenuLayer

-(MenuLayer*)initWithPosition:(CGPoint)point size:(CGSize)size {
    if (self = [self init]) {
        _size = size;
        
        [CCMenuItemFont setFontName:@"Helvetica-BoldOblique"];
        [CCMenuItemFont setFontSize:26];
        // create a few labels with text and selector
        CCMenuItemFont* zombieLabel = [CCMenuItemFont itemWithString:@"Zombies : "
                                                        target:self
                                                      selector:@selector(menuItem1Touched:)];
        CCMenuItemFont* zombieNum = [CCMenuItemFont itemWithString:@"45"
                                                              target:self
                                                            selector:@selector(menuItem1Touched:)];
        
        CCMenuItemFont* civilianLabel = [CCMenuItemFont itemWithString:@"Civilians : "
                                                        target:self
                                                      selector:@selector(menuItem2Touched:)];
        CCMenuItemFont* civilianNum = [CCMenuItemFont itemWithString:@"32"
                                                                target:self
                                                              selector:@selector(menuItem2Touched:)];
        self = [CCMenu menuWithItems:zombieLabel, zombieNum,civilianLabel, civilianNum, nil];
        
        self.position = point;
        [self alignItemsHorizontallyWithPadding:40];
    }
    return self;
}

@end
