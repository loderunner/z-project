//
//  Civilian.m
//  z-project
//
//  Created by Aurélien Noce on 09/02/13.
//
//

#import "Civilian.h"

@interface Civilian()
@property (nonatomic,strong) CCSprite* sprite;
@end

@implementation Civilian

-(id)init {
    if (self = [super init]) {
        self.sprite = [CCSprite spriteWithFile:@"civilian.png"];
    }
    return self;
}

@end
