//
//  Tags.h
//  z-project
//
//  Created by Charles Francoise on 9/2/2013.
//
//

typedef enum
{
    kTagZombie   = 1000,
    kTagCivilian,
    kTagTile
}
Tags;

typedef enum
{
    kZOrderDead = 1000,
    kZOrderCivilian,
    kZOrderZombie,
    kZOrderTile
}
ZOrder;

typedef enum
{
    kTouchingLeft= 1<<0,
    kTouchingRight = 1<<1,
    kTouchingTop = 1<<2,
    kTouchingBottom = 1<<3
}
TouchingEdges;

typedef enum
{
    // common states
    kStateAlive = 0,
    kStateDead,
    
    //zombie states
    kStateZombieEating,
    
    //civilian states
    kStateCivilianBeingEaten,
    kStateCivilianDeadInfected
}
State;

#define kMinimapSpriteKey @"MiniMapSprite"
#define kMinimapImageKey @"ImageForMiniMap"
#define kMinimapSpriteForCivilian @"icon_civilian.png"
#define kMinimapSpriteForZombie @"icon_zombie.png"
#define kMinimapFillColor ccc4f(0x00, 0x00, 0x00, 0.2)
#define kHeadmenuSpriteForCivilian @"icon_menu_civilian.png" //TODO change with the correct file
#define kHeadmenuSpriteForZombie @"icon_menu_zombie.png"
#define kFinishmenuFillColor ccc4f(0.5, 0.5, 0.5, 0.5)
#define kHomemenuSprit @"screen.png"
