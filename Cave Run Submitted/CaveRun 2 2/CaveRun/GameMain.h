//
//  HelloWorldLayer.h
//  CaveRun
//
//  Created by tang on 12-6-4.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import <Foundation/Foundation.h>
#import "GameOverScene.h"
#import "GameOver.h"
#import "Background.h"
#import "Player.h"
#import "Platform.h"
#import "GameOver.h"
#import <Parse/Parse.h>
#import "AdMobViewController.h"
#import <Chartboost/Chartboost.h>
#import <Chartboost/CBNewsfeed.h>


@class GameOverScene;
@class GameOver;
@class Player;
@class Platform;

// HelloWorldLayer
@interface GameMain : CCLayerColor<ChartboostDelegate>
{
     
     UIViewController *rootViewController;
    Player *player;
    
    Background *bg;
    
    Platform *pf;
    
    float speed;
    int sec,limit;
    int dis;
    NSString *limit_coin;
    
    Boolean stopGame,readyGoClipIsFinished;
    
    CCSprite *gameOverSprite,*disCMC;
    
    CCSprite *readyGoClip;
    CCSprite *coinBigClip;
//    GameOverScene *gameOverScreen;
    id readyGoClipAction;
    id loopCoinBig;
    
    CCLabelTTF *disText,*coinText,*levelText,*totalScoreText,*runTimeDisText,*runTimeCoinText;
    CCMenu *pause;
    CCMenu *connectWithFB;
    CCSprite *levelUp;
    CCSprite *lostLife;
   // GameOver *gameover;
     int theTimer,limitTime;
  //  GameOver *gameOverScreen;
    int distextcount;
    int score;
    int remaining_time;
   // GameOverScene *gameOverScreen;
    
   // NSUserDefaults *lives;
    //parse
      BOOL isNewHighScore;
    PFObject *secondHighScore;
    NSUserDefaults * userDefault;
    
    AdMobViewController *adm;
//    UIView *viewHost1;
    
 
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

-(void) moveStage:(float)sp delta:(ccTime)de;

-(void) showGameOver;
-(void) newGame;
-(void) onEnterTransitionDidFinish;
-(void) startGame;
-(void) updateScore;
-(void) updateLives:(int)cnt;
-(void)updatelevelBonus:(int)cnt;
-(void)updateLevel:(int)cnt;
-(void) newGame1;
-(void) loop:(ccTime) delta;
-(void) saveScoreToParse:(NSInteger)score1 forLevel:(NSInteger)level1;
-(void) retriveFriendsScore:(NSInteger)level1 andScore:(NSInteger)score1;
-(void)getDate;
@property(nonatomic,strong)  UIView *viewHost1;
 @property (nonatomic, assign) BOOL transValue;
//@property(nonatomic,retain)  RevMobBannerView *ad1 ;
@property(nonatomic,retain) Player *player;
@property(nonatomic,retain) Background *bg;
@property(nonatomic,retain) Platform *pf;
@property(nonatomic,assign) Boolean stopGame,readyGoClipIsFinished;

@property(nonatomic,assign) int dis;
@property(nonatomic,assign)int score;
@property(nonatomic,assign) int distextcount;
@property(nonatomic,assign) int lives;
@property(nonatomic,assign) int test;

@property(nonatomic,retain) CCSprite *gameOverSprite,*readyGoClip,*coinBigClip,*disCMC,*levelUp,*lostLife,*levelfail,*bg1;
@property(nonatomic,retain) id readyGoClipAction,loopStand,loopCoinBig;

@property(nonatomic,retain) CCLabelTTF *disText,*coinText,*levelText,*totalScoreText,*runTimeDisText,*runTimeCoinText,*livesText,*lives1,*levelText1,* level,*timer;
@property(nonatomic,retain) CCMenuItemImage *shareOnFb;
@property(nonatomic,retain) CCMenu *shareButtons;

@property(nonatomic,retain)CCMenu *bottomMenu;
@property(nonatomic,retain) NSString *strPostMessage;

@property(nonatomic,retain)NSString *coinText1;
@property(nonatomic,strong) CCLabelBMFont *lblTime;

@property(nonatomic,retain)CCMenuItemToggle *soundToggleItem;
@property(nonatomic,retain)  CCSprite *runTimeUICMC;
@property(nonatomic,retain)  GameOverScene *gameOverScreen;
//@property(nonatomic,retain)  GameOver *gameOverScreen;
@property(nonatomic,assign)NSInteger Bool;
@property(nonatomic,assign)NSInteger levelBonus;

@property (nonatomic, strong) CCMenu *connectWithFB;

@property(nonatomic,retain) NSMutableArray *mutArrScores;
@property (nonatomic, assign) NSInteger currentLevel;
@property(nonatomic, retain) NSString *lblFbFirstName;
@property(nonatomic, retain) NSString *lblFbLastName;
@property(nonatomic,assign) id lifeOverLayer;
//@property(nonatomic,assign) CCLabelBMFont *levelText;

@end
