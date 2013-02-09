//
//  MiniMap.h
//  z-project
//
//  Created by Aurélien Noce on 09/02/13.
//
//

#import "CCNode.h"

@interface MiniMap : CCLayer

-(MiniMap*)initWithPosition:(CGPoint)point size:(CGSize)size andRatio:(float)ratio;
-(void)updateMiniMap:(NSArray*)civilians;
-(BOOL)intersectsLocation:(CGPoint)touchLocation withPadding:(float)padding;

@end
