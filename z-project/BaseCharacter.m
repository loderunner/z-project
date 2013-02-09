//
//  BaseCharacter.m
//  z-project
//
//  Created by Aurélien Noce on 09/02/13.
//
//

#import "BaseCharacter.h"

@implementation BaseCharacter

-(id)initWithFile:(NSString*)file tag:(NSInteger*)tag; {
    if (self = [super initWithFile:file]) {
        _properties = [[NSMutableDictionary alloc] init];
        
        // init tag (inherited property(
        self.tag = tag;
    }
    return self;
}

@end
