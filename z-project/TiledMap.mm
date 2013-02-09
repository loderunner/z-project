//
//  TiledMap.m
//  z-project
//
//  Created by Charles Francoise on 9/2/2013.
//
//

#import "TiledMap.h"

@implementation TiledMap

- (void) sortAllChildren
{
	if (isReorderChildDirty_)
	{
		NSInteger i,j,length = children_->data->num;
		CCNode ** x = children_->data->arr;
		CCNode *tempItem;
        
		// insertion sort
		for(i=1; i<length; i++)
		{
			tempItem = x[i];
			j = i-1;
            
			//continue moving element downwards while y is smaller
			while(j>=0 && ( tempItem.position.y > x[j].position.y ) )
			{
				x[j+1] = x[j];
				j = j-1;
			}
			x[j+1] = tempItem;
		}
        
        [super sortAllChildren];
        
		//don't need to check children recursively, that's done in visit of each child
        
		isReorderChildDirty_ = NO;
	}
}

@end
