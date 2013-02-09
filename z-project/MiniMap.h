//
//  MiniMap.h
//  z-project
//
//  Created by Aurélien Noce on 09/02/13.
//
//

#import "CCNode.h"

@interface MiniMap : CCNode

-(MiniMap*)initWithPosition:(CGPoint)point size:(CGSize)size andRatio:(float)ratio;
-(void)updateMiniMap:(NSArray*)civilians;

@end
