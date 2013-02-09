//
//  Tags.h
//  z-project
//
//  Created by Charles Francoise on 9/2/2013.
//
//

typedef enum
{
    kTagZombie   = 0,
    kTagCivilian
}
Tags;

typedef enum
{
    kZOrderDead = 1000,
    kZOrderCivilian,
    kZOrderZombie
}
ZOrder;

typedef enum
{
    // common states
    kStateAlive = 0,
    kStateDead,
    
    //zombie states
    kStateZombieEating,
    
    //civilian states
    kStateCivilianBeingEaten,
    kStateCivilianDeadInfected,
}
State;

#define kMinimapSpriteKey @"MiniMapSprite"
#define kMinimapImageKey @"ImageForMiniMap"
#define kMinimapSpriteForCivilian @"icon_civilian.png"
#define kMinimapSpriteForZombie @"icon_zombie.png"
#define kMinimapFillColor ccc4f(0.5, 0.5, 0.5, 0.5)

