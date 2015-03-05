//
//  Player.h
//  CaveRun
//
//  Created by tang on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "Platform.h"
#import <RevMobAds/RevMobAds.h>
#import "LifeOver.h"
#import <Chartboost/Chartboost.h>
#import <Chartboost/CBNewsfeed.h>

@class Platform;
@interface Player : CCLayer<UIAlertViewDelegate,ChartboostDelegate>{
//    RevMobBannerView *ad ;
//    UIViewController *rootViewController;
    
    CCSprite *mc;
    
    id loopStand,loopRun,loopJump,jumFall,loopFire,oneTimeHit,oneTimeIce;
    
    int state;
    
    float _playerJump,_playerJumpPower;
    
    int minY,currentLevel;
    
    float acceleration,initSpeed,currentSpeed;
    
    Platform *platformAcc;
    
    Boolean isDead;
    
    id gm;
    
    
    float speed,maxSpeed;
     NSUserDefaults *lives;
    
    BOOL isChartBoostFail;
    UIView *secondView;
    UIViewController *rootViewController;
      UILabel *friendsLevel;
    UIButton *okButton ;
    UIButton *cancelButton ;
    UIButton *player;

    BOOL checkAdState ; 
  
}
//-(void)showBanner;
-(void) fireUp;
-(void) goStand;
-(void) callSnd;
-(int) currentY;
+(int) initX;
+(int) initY;
-(void) readyForNewGame;
-(void) readyForNewGame1;
-(void) gotoAndStop:(NSString *) frame val:(int)soundValue;
-(void) update:(ccTime)de;
-(void) jump;
-(void) fall;
- (void) done ;
-(void)hideLevelUp;
//-(void)setPosition1;
-(void)customGameOver;

@property(nonatomic,retain) CCSprite *mc,*man;

@property(nonatomic,retain) id gm,loopStand,loopRun,loopJump,loopFall,loopFire,oneTimeHit,oneTimeIce;
@property(nonatomic,retain) Platform *platformAcc;
 

@property(nonatomic,assign) int state,minY,currentLevel;

@property(nonatomic,assign) float _playerJump,_playerJumpPower,acceleration,initSpeed,speed,currentSpeed,maxSpeed;

 
@property(nonatomic,assign) int lives1;
@property(nonatomic,assign) int pcheck;
@property(nonatomic,assign) Boolean isDead;
@property(nonatomic,assign) int soundValue1;
@property(nonatomic,assign)BOOL flag;
@property(nonatomic,assign) BOOL flag1;



//-(void) gotoAndStop:(NSString *) frame val:(int)soundValue withLayer:(CCLayer *)layer;
@end
