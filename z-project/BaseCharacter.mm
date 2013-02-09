//
//  BaseCharacter.m
//  z-project
//
//  Created by Aurélien Noce on 09/02/13.
//
//

#import "BaseCharacter.h"

@implementation BaseCharacter

-(id)initWithFile:(NSString*)file tag:(NSInteger)tag; {
    if (self = [super initWithFile:file]) {
        _properties = [[NSMutableDictionary alloc] init];
        
        self.tag = tag;
    }
    return self;
}

- (CGFloat)left
{
    return self.position.x - self.contentSize.width * .5f;
}


- (CGFloat)right
{
    return self.position.x + self.contentSize.width * .5f;
}


- (CGFloat)bottom
{
    return self.position.y - self.contentSize.height * .5f;
}


- (CGFloat)top
{
    return self.position.y + self.contentSize.height * .5f;
}

-(void)dealloc {
    self.properties = nil;
    
    [super dealloc];
}

@end
