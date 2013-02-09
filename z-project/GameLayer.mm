//
//  HelloWorldLayer.mm
//  z-project
//
//  Created by Aurélien Noce on 09/02/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

// Import the interfaces
#import "GameLayer.h"
#import "AppDelegate.h"
#import "Civilian.h"
#import "Zombie.h"
#import "Box2D.h"
#import "ContactListener.h"


#pragma mark - GameLayer

static float const PTM_RATIO = 64.0f;
@interface GameLayer()

@property (nonatomic,retain) MiniMap* minimap;
@property (nonatomic,retain) NSMutableArray* civilians;
@property (nonatomic,retain) NSMutableArray* zombies;

@end

@interface GameLayer()
{
    CGSize winSize;
    CGSize mapSize;
    CGSize tileSize;
    b2World* world;
    ContactListener* contactListener;
    CFTimeInterval  lastTouchEndedTimestamp;
}

@end

@implementation GameLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
    GameLayer *layer = [GameLayer node];
	
	[scene addChild: layer];
	
	return scene;
}

-(id) init
{
	if (self = [super init]) {
        //initialize box2d collision manager
        b2Vec2 gravity = b2Vec2(0.0f, 0.0f);
        world = new b2World(gravity);
        world->SetAllowSleeping(false);
        
        contactListener = new ContactListener();
        world->SetContactListener(contactListener);
        
        _map = [[CCTMXTiledMap alloc] initWithTMXFile:@"firsMap.tmx"];
        _map.anchorPoint = CGPointZero;
        
        [self addChild:_map];
		
        // save all sizes
        winSize  = [CCDirector sharedDirector].winSize;
        mapSize  = _map.mapSize;
        tileSize = _map.tileSize;

        [self scheduleUpdate];
        self.isTouchEnabled = YES;
        
        _civilians = [[NSMutableArray alloc] init];
        _zombies = [[NSMutableArray alloc] init];
        //[self spawnCivilians:200];
        [self spawnZombies:200];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [self createMiniMap];
        }
        [self schedule:@selector(updateMiniMap:) interval:.7f];
	}
	return self;
}

#pragma mark - map populating

-(void)spawnCivilians:(int) numZombies
{
    int totalWidth  = mapSize.width  * tileSize.width;
    int totalHeight = mapSize.height * tileSize.height;
    for (int i = 0; i < numZombies; ++i)
    {
        int x = arc4random_uniform(totalWidth);
        int y = arc4random_uniform(totalHeight);
        
        Civilian* dude = [[Civilian alloc] initWithPosition: ccp(x,y)];
        [self.civilians addObject:dude];
        [self.map addChild:dude];
        [self addBoxBodyForSprite:dude];
        
        [dude randomWalk];
    }
}

-(void)spawnZombies:(int)numZombies{
    int totalWidth  = mapSize.width  * tileSize.width;
    int totalHeight = mapSize.height * tileSize.height;
    for (int i = 0; i < numZombies; ++i)
    {
        int x = arc4random_uniform(totalWidth);
        int y = arc4random_uniform(totalHeight);
        
        Zombie* grrr = [[Zombie alloc] initWithPosition: ccp(x,y)];
        [self.zombies addObject:grrr];
        [self.map addChild:grrr];
        [self addBoxBodyForSprite:grrr];
        
        [grrr randomWalk];
    }
}


#pragma mark - scheduled events

- (void) update:(ccTime)dt
{
    [self handleCollisions];
    [self updateBodies:dt];
    
    if (self.minimap.visible) {
        [self.minimap updateMiniMap:self.civilians];
    } else if (lastTouchEndedTimestamp) {
        CFTimeInterval currentTime = CACurrentMediaTime();
        if ((currentTime-lastTouchEndedTimestamp) > 2.0f) {
            self.minimap.visible = YES;
            [self.minimap updateMiniMap:self.civilians];
        }
    }
}

#pragma mark - minimap

-(void)createMiniMap {
    // we want 100px height for the minimap
    float height = 200.0;
    float ratio = height / (mapSize.height * tileSize.height);
    float width = ratio * (mapSize.width * tileSize.width);
    float padding = 5.0; // padding from the scren limits
    CGPoint position = ccp(padding,padding);
    NSLog(@"position of minimap: %f,%f",position.x,position.y);
    self.minimap = [[MiniMap alloc]
                    initWithPosition:position
                    size:CGSizeMake(width,height)
                    andRatio:ratio];
    [self addChild:self.minimap];
}

- (void)updateMiniMap:(ccTime)dt
{
    [self.minimap updateMiniMap:self.zombies];
}


#pragma mark - Box2D stuff

- (void)addBoxBodyForSprite:(CCSprite *)sprite
{    
    b2BodyDef spriteBodyDef;
    spriteBodyDef.type = b2_dynamicBody;
    spriteBodyDef.position.Set(sprite.position.x/PTM_RATIO,
                               sprite.position.y/PTM_RATIO);
    spriteBodyDef.userData = (void *)sprite;
    b2Body *spriteBody = world->CreateBody(&spriteBodyDef);
    
    b2PolygonShape spriteShape;
    spriteShape.SetAsBox(sprite.contentSize.width/PTM_RATIO/2,
                         sprite.contentSize.height/PTM_RATIO/2);
    b2FixtureDef spriteShapeDef;
    spriteShapeDef.shape = &spriteShape;
    spriteShapeDef.density = 10.0;
    spriteShapeDef.isSensor = true;
    spriteBody->CreateFixture(&spriteShapeDef);
}

- (void)updateBodies:(ccTime)dt
{
    world->Step(dt, 10, 10);
    for(b2Body *b = world->GetBodyList(); b; b = b->GetNext())
    {
        if (b->GetUserData() != NULL)
        {
            CCSprite *sprite = (CCSprite *)b->GetUserData();
            
            b2Vec2 b2Position = b2Vec2(sprite.position.x/PTM_RATIO,
                                       sprite.position.y/PTM_RATIO);
            float32 b2Angle = -1 * CC_DEGREES_TO_RADIANS(sprite.rotation);
            
            b->SetTransform(b2Position, b2Angle);
        }
    }
}

- (void)handleCollisions
{
    //CCLOG(@"%ld collisions", contactListener->_contacts.size());
    
    std::vector<Contact>::iterator pos;
    for(pos = contactListener->_contacts.begin(); pos != contactListener->_contacts.end(); ++pos) {
        Contact contact = *pos;
        
        b2Body *bodyA = contact.fixtureA->GetBody();
        b2Body *bodyB = contact.fixtureB->GetBody();
        if (bodyA->GetUserData() != NULL && bodyB->GetUserData() != NULL)
        {
            BaseCharacter* spriteA = (BaseCharacter*) bodyA->GetUserData();
            BaseCharacter* spriteB = (BaseCharacter*) bodyB->GetUserData();
            CGFloat overlapX, overlapY;
            
            // if same sprite class, do not let them overlap
            if (spriteA.tag == spriteB.tag)
            {
                if (spriteA.right > spriteB.left && spriteA.right < spriteB.right)
                {
                    //A's right edge is touching
                    overlapX = spriteB.left - spriteA.right;
                }
                else if (spriteA.left > spriteB.left && spriteA.left < spriteB.right)
                {
                    //A's left edge is touching
                    overlapX = spriteB.right - spriteA.left;
                }
                
                if (spriteA.top > spriteB.bottom && spriteA.top < spriteB.top)
                {
                    //A's top edge is touching
                    overlapY = spriteB.bottom - spriteA.top;
                }
                else if (spriteA.bottom > spriteB.bottom && spriteA.bottom < spriteB.top)
                {
                    //A's bottom edge is touching
                    overlapY = spriteB.top - spriteA.bottom;
                }
                
                if (overlapX*overlapX < overlapY*overlapY)
                {
                    spriteA.position = ccp(spriteA.position.x + overlapX, spriteA.position.y);
                    if (spriteA.movedSprites)
                    {
                    }
                    [spriteB.movedSprites addObject:spriteA];
                }
                else
                {
                    spriteA.position = ccp(spriteA.position.x, spriteA.position.y + overlapY);
                    for (BaseCharacter* bc in spriteA.movedSprites)
                    {
                    }
                    [spriteB.movedSprites addObject:spriteA];
                } 
            }
        }
    }
    
    // cleanup movedForCollision flags
    for(pos = contactListener->_contacts.begin(); pos != contactListener->_contacts.end(); ++pos) {
        Contact contact = *pos;
        
        b2Body *bodyA = contact.fixtureA->GetBody();
        b2Body *bodyB = contact.fixtureB->GetBody();
        if (bodyA->GetUserData() != NULL && bodyB->GetUserData() != NULL)
        {
            BaseCharacter* spriteA = (BaseCharacter*) bodyA->GetUserData();
            BaseCharacter* spriteB = (BaseCharacter*) bodyB->GetUserData();
            
            spriteA.movedForCollision = NO;
            spriteB.movedForCollision = NO;
        }
    }
}

#pragma mark - touch events

-(void) registerWithTouchDispatcher
{
	CCDirector *director = [CCDirector sharedDirector];
	[[director touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInView: [touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    
    if([self.minimap intersectsLocation:touchLocation withPadding:15.0]) {
        self.minimap.visible    = NO;
        lastTouchEndedTimestamp = 0;
    }
    return YES;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    lastTouchEndedTimestamp = CACurrentMediaTime();
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint touchLocation = [touch locationInView: [touch view]];
	CGPoint prevLocation  = [touch previousLocationInView: [touch view]];
    
	touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
	prevLocation  = [[CCDirector sharedDirector] convertToGL: prevLocation];
    
	CGPoint diff = ccpSub(touchLocation,prevLocation);
    
    CGPoint currentPos = [self.map position];
    CGPoint newPos     = ccpAdd(currentPos, diff);
    
    // constraints
    if (newPos.x > 0) newPos.x = 0;
    if (newPos.y > 0) newPos.y = 0;

    float layerWidth = tileSize.width * mapSize.width;
    float winWidth   = winSize.width;
    float minimumX   = winWidth-layerWidth;
    if (newPos.x < minimumX) newPos.x = minimumX;
    float layerHeight = tileSize.height * mapSize.height;
    float winHeight   = winSize.height;
    float minimumY    = winHeight-layerHeight;
    if (newPos.y < minimumY) newPos.y = minimumY;

	[self.map setPosition: newPos];
}

#pragma mark - cleanup

- (void)dealloc
{
    [_civilians release];
    [_zombies release];
    [_map release];
    delete world;
    delete contactListener;
    
    [super dealloc];
}

@end
