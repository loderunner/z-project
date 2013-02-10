//
//  MiniMap.m
//  z-project
//
//  Created by Aurélien Noce on 09/02/13.
//
//

#import <GLKit/GLKit.h>
#import "cocos2d.h"
#import "MiniMap.h"
#import "Civilian.h"
#import "Constants.h"

@interface MiniMap()

@property (nonatomic,assign) CGPoint point;
@property (nonatomic,assign) CGSize  size;
@property (nonatomic,assign) float   ratio;
@property (nonatomic,assign) CGPoint viewPosition;

@end

@implementation MiniMap

-(MiniMap*)initWithPosition:(CGPoint)point size:(CGSize)size andRatio:(float)ratio {
    if (self = [self init]) {
        _point = point;
        _size  = size;
        _ratio = ratio;
        _viewPosition = CGPointZero;
        self.isTouchEnabled = YES;
    }
    return self;
}

- (void)draw
{
    glEnable(GL_LINE_SMOOTH);
    glColor4ub(0x66, 0x00, 0x00, 0xFF);
    glLineWidth(2);
    ccColor4F fillColor = kMinimapFillColor;
    ccDrawSolidRect(self.point,ccp(self.point.x+self.size.width,self.point.y+self.size.height), fillColor);
    
    float left   = self.viewPosition.x * self.ratio;
    float bottom = self.viewPosition.y * self.ratio;
    CGSize windowsSize = [[CCDirector sharedDirector] winSize];
    float right = left + windowsSize.width * self.ratio;
    float top = bottom + windowsSize.height * self.ratio;
    ccDrawRect(ccp(left,bottom),ccp(right,top));
}

-(BOOL)intersectsLocation:(CGPoint)location withPadding:(float)padding {
    float left   = self.point.x;
    float bottom = self.point.y;
    float right  = self.point.x+self.size.width;
    float top    = self.point.y+self.size.height;
    if (location.x > right + padding) return NO;
    if (location.x < left - padding) return NO;
    if (location.y < bottom - padding) return NO;
    if (location.y > top + padding) return NO;
    return YES;
}

#pragma mark - update methods

-(void)updateMiniMap:(NSArray*)characters {
    for (BaseCharacter* c in characters) {
        // compute position in the minimap
        CGPoint originalPosition = c.position;
        CGPoint positionInMinimap = ccp(originalPosition.x*self.ratio, originalPosition.y*self.ratio);
        // dequeue reusable sprite
        CCSprite* sprite = [[c.properties objectForKey:kMinimapSpriteKey] retain];
        if (sprite == nil) {
            // create new sprite
            NSString* imageFileName = [[c.properties objectForKey:kMinimapImageKey] retain];
            sprite = [[CCSprite alloc] initWithFile:imageFileName];
            [imageFileName release];
            [c.properties setObject:sprite forKey:kMinimapSpriteKey];
            [self addChild:sprite];
        }
        // move
        sprite.position = ccp(positionInMinimap.x+self.point.x,positionInMinimap.y+self.point.y);
        sprite.visible = [self intersectsLocation:sprite.position withPadding:0.0];
        [sprite release];
    }
}

-(void)updateViewPosition:(CGPoint)position {
    self.viewPosition = position;
}

-(void)removeCharacter:(BaseCharacter *)character {
    CCSprite* miniMapSprite = [character.properties objectForKey:kMinimapSpriteKey];
    if (!miniMapSprite) return;
    
    [self removeChild:miniMapSprite cleanup:YES];
 }

#pragma mark - touch events

-(void) registerWithTouchDispatcher
{
	CCDirector *director = [CCDirector sharedDirector];
	[[director touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(void)showAgain {
    self.visible = YES;
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInView: [touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    
    if([self intersectsLocation:touchLocation withPadding:15.0]) {
        [self unschedule:@selector(showAgain)];
        [self scheduleOnce:@selector(showAgain) delay:2.0];
        self.visible = NO;
    }
    return NO; //do *not* swallow touches !
}

#pragma mark - cleanup

-(void)dealloc {
    [super dealloc];
}

@end
