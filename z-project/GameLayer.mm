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
#import "Constants.h"
#import "ScoreCounters.h"

#pragma mark - GameLayer

static float const PTM_RATIO = 64.0f;
@interface GameLayer()

@property (nonatomic,retain) NSMutableArray* civilians;
@property (nonatomic,retain) NSMutableArray* zombies;
@property (nonatomic,retain) MiniMap* minimap;
@property (nonatomic,retain) MenuLayer* menuLayer;
@property (nonatomic,retain) NSMutableArray* spawnPoints;
@property (nonatomic,retain) NSMutableArray* gestureRecognizers;
@property (nonatomic,retain) ScoreCounters* scoreCounters;

@end

@interface GameLayer()
{
    CGSize winSize;
    CGSize mapSize;
    CGSize tileSize;
    b2World* world;
    ContactListener* contactListener;
}

@end

@implementation GameLayer

+(CCScene *) sceneWithMap:(NSString*)mapName
{
	CCScene *scene = [CCScene node];
    GameLayer *layer = [[[GameLayer alloc] initWithMap:mapName] autorelease];
	
	[scene addChild: layer];
	
	return scene;
}

-(id) initWithMap:(NSString*)mapName
{
	if (self = [super init]) {        
        //initialize box2d collision manager
        b2Vec2 gravity = b2Vec2(0.0f, 0.0f);
        world = new b2World(gravity);
        world->SetAllowSleeping(false);
        
        contactListener = new ContactListener();
        world->SetContactListener(contactListener);
        
        // load the map
        _map = [[TiledMap alloc] initWithTMXFile:mapName];
        _map.anchorPoint = CGPointZero;
        CCTMXLayer* collidables = [_map layerNamed:@"collidable"];
        collidables.visible = NO;
        CCTMXObjectGroup* spawnPoints = [_map objectGroupNamed:@"spawnPoints"];
        _spawnPoints = [spawnPoints.objects copy];
        
        [self addChild:_map];
		
        // save all sizes
        winSize  = [CCDirector sharedDirector].winSize;
        mapSize  = _map.mapSize;
        tileSize = _map.tileSize;
        
        [self scheduleUpdate];
        self.isTouchEnabled = YES;
        
        _civilians = [[NSMutableArray alloc] init];
        _zombies = [[NSMutableArray alloc] init];
        _gestureRecognizers = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < 50; ++i)
        {
            [self addCivilian];
        }
        
        for (NSDictionary* spawnPoint in self.spawnPoints) {
            int x = [[spawnPoint objectForKey:@"x"] intValue];
            int y = [[spawnPoint objectForKey:@"y"] intValue];
            NSLog(@"spawn point at %d,%d",x,y);
            CGPoint pos = ccp(x,y);
            
            [self addZombieAt:pos];
            
            //#DEBUG Chrales: only one zombie to test "smart"zombies
            break;
        }
        
        _scoreCounters = [[ScoreCounters alloc] initWithZombies:_zombies.count civilians:_civilians.count];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [self createMiniMap];

            [self schedule:@selector(updateMiniMapCharacters:) interval:.7f];
            [self schedule:@selector(updateMiniMapPosition:) interval:.05f];  // 1/20th sec

        }
        
        [self createMenuLayer];
        [self schedule:@selector(updateMenuLayer:) interval:.7f];
        
        [self registerRecognisers];
	}
	return self;
}


#pragma mark - gesture recognisers

-(void)registerRecognisers {
    UITapGestureRecognizer* tapRecogniser = [self watchForTap:@selector(onTap:)];
    [self.gestureRecognizers addObject:tapRecogniser];
}

-(void)unregisterRecognisers {
    for (UIGestureRecognizer* recognizer in self.gestureRecognizers) {
        [self unwatch:recognizer];
    }
    [self.gestureRecognizers removeAllObjects];
}

-(BaseCharacter*)findCharacterAt:(CGPoint) location {
    for (BaseCharacter* character in self.map.children)
    {
        if ([character isKindOfClass:BaseCharacter.class])
        {
            if (CGRectContainsPoint(character.boundingBox, location) && [character isAlive]) {
                return character;
            }
        }
    }
    return nil;
}

-(void)onTap:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:[[CCDirector sharedDirector] view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    location = ccpSub(location, self.map.position);

    BaseCharacter* character = [self findCharacterAt:location];

    BOOL characterWasKilled = [character takeDamage:1];
    if (characterWasKilled) {
        if ( character.tag == kTagZombie) {
            [_scoreCounters registerZombieKilledByPlayer];
        } else if (character.tag == kTagCivilian) {
            [_scoreCounters registerCivilianKilledByPlayer];
        }
    }
}


- (UITapGestureRecognizer *)watchForTap:(SEL)selector {
    UITapGestureRecognizer *recognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:selector] autorelease];
    [self registerRecognizer:recognizer];
    return recognizer;
}


-(void)registerRecognizer:(UIGestureRecognizer*)recognizer {
    [[[CCDirector sharedDirector] view] addGestureRecognizer:recognizer];
}


- (void)unwatch:(UIGestureRecognizer *)gr {
    [[[CCDirector sharedDirector] view] removeGestureRecognizer:gr];
}


#pragma mark - map populating

-(void)addCivilian {
    int totalWidth  = mapSize.width  * tileSize.width;
    int totalHeight = mapSize.height * tileSize.height;
    
    int x = arc4random_uniform(totalWidth);
    int y = arc4random_uniform(totalHeight);
    
    [self addCivilianAt:ccp(x, y)];
}

- (void)addCivilianAt:(CGPoint)pos
{
    Civilian* civilian = [[Civilian alloc] initWithPosition:pos];
    [self.civilians addObject:civilian];
    [self.map addChild:civilian];
    [self addBoxBodyForSprite:civilian];
    
    [civilian randomWalk];
}

- (void)removeCivilian:(Civilian*)civilian
{
    if (self.minimap) [self.minimap removeCharacter:civilian];
    [self.civilians removeObject:civilian];
    [self.map removeChild:civilian cleanup:YES];
    [self removeBoxForBody:civilian];
}

-(void)addZombieAt:(CGPoint)pos {
    Zombie* zombie = [[Zombie alloc] initWithPosition: pos];
    [self.zombies addObject:zombie];
    [self.map addChild:zombie];
    [self addBoxBodyForSprite:zombie];
    
    [zombie randomWalk];
}

- (void)removeZombie:(Zombie*)zombie
{
    if (self.minimap) [self.minimap removeCharacter:zombie];
    [self.zombies removeObject:zombie];
    [self.map removeChild:zombie cleanup:YES];
    [self removeBoxForBody:zombie];
}

#pragma mark - scheduled events

- (void) update:(ccTime)dt
{
    [self updateBodies:dt];
    [self handleCollisions];
}

#pragma mark - minimap

-(void)createMiniMap {
    // we want 100px height for the minimap
    float height = 200.0;
    float ratio = height / (mapSize.height * tileSize.height);
    float width = ratio * (mapSize.width * tileSize.width);
    float padding = 5.0; // padding from the scren limits
    CGPoint position = ccp(padding,padding);
    self.minimap = [[MiniMap alloc]
                    initWithPosition:position
                    size:CGSizeMake(width,height)
                    andRatio:ratio];
    [self addChild:self.minimap];
}

- (void)updateMiniMapCharacters:(ccTime)dt
{
    [self.minimap updateMiniMap:self.civilians];
    [self.minimap updateMiniMap:self.zombies];
}

- (void)updateMiniMapPosition:(ccTime)dt {
    CGPoint viewPosition = ccp(-self.map.position.x,-self.map.position.y);
    [self.minimap updateViewPosition:viewPosition];
}


#pragma mark - menuLayer

-(void)createMenuLayer {
    self.menuLayer = [[MenuLayer alloc] layer];
    [self addChild:self.menuLayer];
}

-(void)updateMenuLayer:(ccTime)dt {
    [self.menuLayer updateNumberOfCivilian:_scoreCounters.numCivilians];
    [self.menuLayer updateNumberOfZombie:_scoreCounters.numZombies];
}


#pragma mark - Box2D stuff

- (void)addBoxBodyForSprite:(BaseCharacter *)sprite
{    
    b2BodyDef spriteBodyDef;
    spriteBodyDef.type = b2_dynamicBody;
    spriteBodyDef.position.Set(sprite.position.x/PTM_RATIO,
                               sprite.position.y/PTM_RATIO);
    spriteBodyDef.userData = (void *)sprite;
    b2Body *spriteBody = world->CreateBody(&spriteBodyDef);
    
    b2PolygonShape spriteShape;
    spriteShape.SetAsBox(.5f * sprite.contentSize.width/PTM_RATIO,
                         .5f * sprite.contentSize.height/PTM_RATIO);
    b2FixtureDef spriteShapeDef;
    spriteShapeDef.shape = &spriteShape;
    spriteShapeDef.density = 10.0;
    spriteShapeDef.isSensor = true;
    spriteBody->CreateFixture(&spriteShapeDef);
}

- (void)removeBoxForBody:(CCSprite*)sprite
{
    b2Body *spriteBody = NULL;
    for(b2Body *b = world->GetBodyList(); b; b=b->GetNext()) {
        if (b->GetUserData() != NULL) {
            CCSprite *curSprite = (CCSprite *)b->GetUserData();
            if (sprite == curSprite) {
                spriteBody = b;
                break;
            }
        }
    }
    if (spriteBody != NULL) {
        world->DestroyBody(spriteBody);
    }
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
    for(pos = contactListener->_contacts.begin(); pos != contactListener->_contacts.end(); ++pos)
    {
        Contact contact = *pos;
        
        b2Body *bodyA = contact.fixtureA->GetBody();
        b2Body *bodyB = contact.fixtureB->GetBody();
        if (bodyA->GetUserData() != NULL && bodyB->GetUserData() != NULL)
        {
            BaseCharacter* spriteA = (BaseCharacter*) bodyA->GetUserData();
            BaseCharacter* spriteB = (BaseCharacter*) bodyB->GetUserData();
            
            if (spriteA.tag != spriteB.tag)
            {
                Zombie* zombie;
                Civilian* civilian;
                if (spriteA.tag == kTagZombie)
                {
                    zombie = (Zombie*)spriteA;
                    civilian = (Civilian*)spriteB;
                }
                else
                {
                    zombie = (Zombie*)spriteB;
                    civilian = (Civilian*)spriteA;
                }
                
                // kill civilian and wake as zombie in 3 seconds
                if ([civilian isAlive] && [zombie isAlive])
                {
                    [civilian infect];
                    CCDelayTime* delayAction = [CCDelayTime actionWithDuration:3];
                    CCCallBlock* blockAction = [CCCallBlock actionWithBlock:^(void)
                                                {
                                                    [self addZombieAt:civilian.position];
                                                    [self removeCivilian:civilian];
                                                    [_scoreCounters registerCivilianConvertedToZombie];
                                                }];
                    CCSequence* sequenceAction = [CCSequence actionOne:delayAction two:blockAction];
                    [self runAction:sequenceAction];
                }
            }
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
    
    return YES;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
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
    [self unregisterRecognisers];
    self.civilians   = nil;
    self.zombies     = nil;
    self.map         = nil;
    self.spawnPoints = nil;
    self.gestureRecognizers = nil;

    delete world;
    delete contactListener;
    
    [super dealloc];
}

@end
