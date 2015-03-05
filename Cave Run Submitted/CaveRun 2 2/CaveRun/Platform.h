//
//  Platform.h
//  CaveRun
//
//  Created by tang on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "Player.h"
#import <Foundation/Foundation.h>
#import "GameOverScene.h"
#import "GameOver.h"
#import "Background.h"
#import "Platform.h"
#import "GameOver.h"

@class Player;

@interface Platform : CCLayer{
    int widMax,widMin,leftWidth,rightWidth,midWidth,gap;
   
    CCLayer *currentPF;
    CCLayer *lastPF;
    CCSprite *__pf,*fall;
    NSMutableArray *pool,*pfsArr,*pfWidthArr,*coinsArr,*coinsArrsArr,*obsArr,*obsArrsArr;
    int lastWid,coinsNum,currentLevel;
    
    
    id player;
    int counter;
    id gm;
}
//-(void)addEnemyCount;
-(void) hideLevelUp;
-(void) hideLostLife;
-(void) createForNewGame;
-(void) initForNewGame;
-(void) move:(float) speed val:(int)soundValue ;
-(void)hitTestOB;
//-(void)done1;
-(CCLayer *) create:(int) _width addOB:(BOOL)addob;
-(void) addMidDecalToPool:(int)cnt;
-(CCSprite *) getDecalFromPool;
-(int) getSafeY;
-(void) removeAll;
-(NSMutableArray *) getCurrentCoinsArr;
-(NSMutableArray *) getCurrentDemonsArr;
-(NSMutableArray *) getCurrentObsArr;
-(CCLayer*) getCurrentPFUnderPlayer;
-(void) tryRemoveCoin;
@property(nonatomic,assign) int widMax, widMin,leftWidth,rightWidth,midWidth,gap,lastWid,coinsNum,currentLevel,lives;
@property(nonatomic,assign)int soundValue;
@property(nonatomic,retain) CCSprite *__pf;
@property(nonatomic,retain) CCLayer *lastPF;
@property(nonatomic,retain) Player *player1;
@property(nonatomic,retain) id player,gm;
@property(nonatomic,retain) NSMutableArray *pool,*pfsArr,*pfWidthArr,*coinsArr,*coinsArrsArr,*obsArr,*obsArrsArr;
@property(nonatomic,retain) NSMutableArray *demonArr,*demonArrsArr;
@property(nonatomic,retain)CCSprite *enemy;
@property(nonatomic,retain)CCMenuItemToggle *soundToggleItem;
@property(nonatomic,retain)id loopFall;
@property(nonatomic,assign)NSInteger Bool;
@property(nonatomic,assign)NSInteger levelBonus;
@property(nonatomic,retain)CCSprite *fall;
@property(nonatomic,assign)BOOL flag;

@end
