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
#import "MenuLayer.h"
#import "FinishLayer.h"
#import "GameManager.h"
#import "LevelManager.h"

#pragma mark - GameLayer

static float const PTM_RATIO = 64.0f;

@interface GameLayer()

@property (nonatomic,retain) LevelManager* level;
@property (nonatomic,retain) MiniMap* minimap;
@property (nonatomic,retain) MenuLayer* menuLayer;
@property (nonatomic,retain) FinishLayer* finishLayer;
@property (nonatomic,retain) NSMutableArray* civilians;
@property (nonatomic,retain) NSMutableArray* zombies;
@property (nonatomic,retain) NSMutableArray* collidables;
@property (nonatomic,retain) NSMutableArray* spawnPoints;
@property (nonatomic,retain) NSMutableArray* gestureRecognizers;
@property (nonatomic,retain) ScoreCounters* scoreCounters;
@property (nonatomic,retain) NSMutableDictionary* zombitesTospawn;


@end

@interface GameLayer()
{
    CGSize winSize;
    CGSize mapSize;
    CGSize tileSize;
    b2World* world;
    ContactListener* contactListener;
    float timeCounter;
    float timeForLastSpawn;
}

@end

@implementation GameLayer

+(CCScene *) sceneForLevel:(LevelManager*) level
{
    CCScene *scene = [CCScene node];
    GameLayer *layer = [[[GameLayer alloc] initWithLevel:level] autorelease];
    
    [scene addChild: layer];
    
    return scene;
}

-(id) initWithLevel:(LevelManager*) level
{
    if (self = [super init]) {
        //initialize box2d collision manager
        b2Vec2 gravity = b2Vec2(0.0f, 0.0f);
        world = new b2World(gravity);
        world->SetAllowSleeping(false);
        
        contactListener = new ContactListener();
        world->SetContactListener(contactListener);
        
        // load the map
        _map = [[TiledMap alloc] initWithTMXFile:level.mapFile];
        _map.anchorPoint = CGPointZero;
        
        //        [self enumerateTilesInMap:_map layer:collidables usingBlock:^(NSUInteger x, NSUInteger y, NSDictionary *property) {
        //            if ([@"0" compare: [property objectForKey:@"can_walk"]] == NSOrderedSame) {
        //                int xOnScreen = x * _map.tileSize.width;
        //                int yOnScreen = (_map.mapSize.height - y) * _map.tileSize.height;
        //            }
        //        }];
        _collidables = [[NSMutableArray alloc] init];
        CCTMXLayer* collidables = [_map layerNamed:@"collidables"];
        for (NSUInteger y = 0; y < collidables.layerSize.height; y++)
        {
            for (NSUInteger x = 0; x < collidables.layerSize.width; x++)
            {
                NSUInteger pos = x + collidables.layerSize.width * y;
                uint32_t gid = collidables.tiles[pos];
                if (gid > 0)
                {
                    NSDictionary* properties = [_map propertiesForGID:gid];
                    NSString* canWalkString = [properties objectForKey:@"can_walk"];
                    if ([canWalkString isEqualToString:@"0"])
                    {
                        [self addBoxBodyForTile:ccp(x,y)];
                    }
                }
            }
        }
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
        _zombitesTospawn = [[NSMutableDictionary alloc] init];
        
        for (int i = 0; i < 50; ++i)
        {
            [self addCivilian];
        }
        
        timeForLastSpawn = 0;
        for (NSDictionary* spawnPoint in self.spawnPoints) {
            int x = [[spawnPoint objectForKey:@"x"] intValue];
            int y = [[spawnPoint objectForKey:@"y"] intValue];
            CGPoint pos = ccp(x,y);
            
            NSString* timeString = [spawnPoint objectForKey:@"time"];
            if (timeString) {
                float value = [timeString floatValue];
                timeForLastSpawn = MAX(timeForLastSpawn,value);
                NSNumber *keyValue = [NSNumber numberWithFloat:value];
                NSMutableArray* list = [[_zombitesTospawn objectForKey:keyValue] retain];
                if (!list) {
                    list = [[NSMutableArray alloc] init];
                    [_zombitesTospawn setObject:list forKey:keyValue];
                }
                [list addObject:[NSValue valueWithCGPoint:pos]];
                [list release];
            } else {
                [_scoreCounters registerZombieSpawned];
                [self addZombieAt:pos];
            }
        }
        timeCounter = 0;
        [self schedule:@selector(timerCallback:) interval:0.5];
        
        _scoreCounters = [[ScoreCounters alloc] initWithZombies:_zombies.count civilians:_civilians.count];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [self createMiniMap];
            
            [self schedule:@selector(updateMiniMapCharacters:) interval:.7f];
            [self schedule:@selector(updateMiniMapPosition:) interval:.05f];  // 1/20th sec
            
        }
        
        [self createMenuLayer];
        [self schedule:@selector(updateMenuLayer:) interval:.7f];
        [self schedule:@selector(testFinishGame:) interval:.5f]; //TODO make it appear once
        
        [self registerRecognisers];
    }
    return self;
}

-(void)timerCallback:(ccTime)time {
    timeCounter += time;
    NSMutableArray* toRemove = [[NSMutableArray alloc] init];
    [self.zombitesTospawn enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSNumber *numkey = (NSNumber*)key;
        float timeCondition = [numkey floatValue];
        if (timeCondition < timeCounter) {
            NSArray* positions = (NSArray*) obj;
            for (NSValue *rawPosition in positions) {
                CGPoint point = [rawPosition CGPointValue];
                [_scoreCounters registerZombieSpawned];
                [self addZombieAt:point];
            }
            [toRemove addObject:numkey];
        }
    }];
    [toRemove enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSNumber *numkey = obj;
        [self.zombitesTospawn removeObjectForKey:numkey];
    }];
    [toRemove release];
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
        SoundManager* soundManager = [[GameManager sharedManager] soundManager];
        [soundManager playDeathSound];
        [self.minimap removeCharacter:character];
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

#pragma mark - finishGame
-(void)testFinishGame:(ccTime)dt  {
    if (([_scoreCounters numCivilians] == 0 || [_scoreCounters numZombies] == 0) && timeCounter > timeForLastSpawn) {
        [self unschedule:@selector(testFinishGame:)];
        [self finishGame];
    }
}

-(void)finishGame {
    self.finishLayer = [[FinishLayer alloc] layerWithStat:self.scoreCounters];
    [self addChild:self.finishLayer];
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

- (void)addBoxBodyForTile:(CGPoint)coord
{
    CGFloat x = 1.5f * coord.x * _map.tileSize.width;
    CGFloat y = 1.5f * (_map.mapSize.height - coord.y) * _map.tileSize.height;
    
    CCNode* tile = [CCNode node];
    tile.position = ccp(x, y);
    tile.contentSize = CGSizeMake(_map.tileSize.width, _map.tileSize.height);
    tile.tag = kTagTile;
    [_collidables addObject:tile];
    
    b2BodyDef spriteBodyDef;
    spriteBodyDef.type = b2_dynamicBody;
    spriteBodyDef.position.Set(x/PTM_RATIO,
                               y/PTM_RATIO);
    spriteBodyDef.userData = tile;
    b2Body *spriteBody = world->CreateBody(&spriteBodyDef);
    
    b2PolygonShape spriteShape;
    spriteShape.SetAsBox(.5f * _map.tileSize.width/PTM_RATIO,
                         .5f * _map.tileSize.width/PTM_RATIO);
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
            CCNode* spriteA = (CCNode*) bodyA->GetUserData();
            CCNode* spriteB = (CCNode*) bodyB->GetUserData();
            
            Zombie* zombie = nil;
            Civilian* civilian = nil;
            CCNode* tile = nil;
            if (spriteA.tag == kTagZombie)
            {
                zombie = (Zombie*)spriteA;
            }
            else if (spriteA.tag == kTagCivilian)
            {
                civilian = (Civilian*) spriteA;
            }
            else if (spriteA.tag == kTagTile)
            {
                tile = spriteA;
            }
            
            if (spriteB.tag == kTagZombie)
            {
                zombie = (Zombie*)spriteB;
            }
            else if (spriteB.tag == kTagCivilian)
            {
                civilian = (Civilian*)spriteB;
            }
            else if (spriteB.tag == kTagTile)
            {
                tile = spriteB;
            }
            
            if (civilian != nil && zombie != nil)
            {
                if ([civilian isAlive] && [zombie isAlive])
                {
                    [zombie eatCivilian:civilian];
                    
                    // kill civilian and wake as zombie in 3 seconds
                    [civilian infect];
                    
                    
                    CGPoint positionCivilian = civilian.position;
                    CGPoint mapPosition = self.map.position;
                    CGPoint viewPosition = ccpSub(CGPointZero,mapPosition);
                    CGRect viewFrustrum = CGRectMake(viewPosition.x,viewPosition.y,winSize.width,winSize.height);
                    BOOL isCivilianVisible = CGRectContainsPoint(viewFrustrum, positionCivilian);
                    SoundManager* soundManager = [[GameManager sharedManager] soundManager];
                    if (isCivilianVisible) {
                        [soundManager playSound:kSoundScreamCivilian];
                    } else {
                        [soundManager playSound:kSoundScreamZombie];
                    }
                    
                    CCDelayTime* delayAction = [CCDelayTime actionWithDuration:3];
                    CCCallBlock* blockAction = [CCCallBlock actionWithBlock:^(void)
                                                {
                                                    [_scoreCounters registerCivilianConvertedToZombie];
                                                    [self addZombieAt:civilian.position];
                                                    [self removeCivilian:civilian];
                                                    
                                                }];
                    CCSequence* sequenceAction = [CCSequence actionOne:delayAction two:blockAction];
                    [self runAction:sequenceAction];
                }
            }
            else if (tile != nil)
            {
                BaseCharacter* character = (zombie == nil) ? civilian : zombie;
                
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
    [_civilians release];
    [_zombies release];
    [_collidables release];
    [_map release];
    [_spawnPoints release];
    [_gestureRecognizers release];
    
    delete world;
    delete contactListener;
    
    [super dealloc];
}

@end
