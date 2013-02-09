//
//  MainMenuLayer.m
//  z-project
//
//  Created by Aurélien Noce on 09/02/13.
//
//

#import "cocos2d.h"
#import "MainMenuLayer.h"

@implementation MainMenuLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
    MainMenuLayer *layer = [MainMenuLayer node];
	
	[scene addChild: layer];
	
	return scene;
}

-(id)init {
    if (self = [super init]) {
        CCMenuItemSprite* level1 = [self
                                    createMenuItemWithNormalImage:@"leve1_nornal.png"
                                    selectedImage:@"leve1_selected.png"
                                    selector:@selector(firstLevel:)];
        CCMenuItemSprite* level2 = [self
                                    createMenuItemWithNormalImage:@"leve2_nornal.png"
                                    selectedImage:@"leve2_selected.png"
                                    selector:@selector(secondLevel:)];
        CCMenuItemSprite* level3 = [self
                                    createMenuItemWithNormalImage:@"leve3_nornal.png"
                                    selectedImage:@"leve3_selected.png"
                                    selector:@selector(thirdLevel:)];
        CCMenu* menu = [CCMenu menuWithItems:level1,level2,level3, nil];
        
        CGSize size = [CCDirector sharedDirector].winSize;
        menu.position = CGPointMake(size.width/2, size.height/2);
        [self addChild:menu];
        [menu alignItemsHorizontallyWithPadding:40.0];
    }
    return self;
}

-(void)firstLevel:(id)sender {
    
}

-(void)secondLevel:(id)sender {
    
}

-(void)thirdLevel:(id)sender {
    
}

-(CCMenuItemSprite*)createMenuItemWithNormalImage:(NSString*)normalImage selectedImage:(NSString*)selectedImage selector:(SEL)selector {
    CCSprite* normal   = [CCSprite spriteWithFile:normalImage];
    CCSprite* selected = [CCSprite spriteWithFile:selectedImage];
    return [CCMenuItemSprite
            itemWithNormalSprite:normal
            selectedSprite:selected
            target:self
            selector:selector];
}

@end
