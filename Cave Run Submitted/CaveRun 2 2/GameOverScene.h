//
//  GameOverScene.h
//  CaveRun
//
//  Created by Sumit on 17/06/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//
#import "CCSprite.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameMain.h"
#import "GameOverScene.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "AdMobViewController.h"
#import <Chartboost/Chartboost.h>
#import <Chartboost/CBNewsfeed.h>
#import <sqlite3.h>

@class GameMain;
@class LevelSelectionScene;

@interface GameOverScene : CCLayer <UITextViewDelegate,ChartboostDelegate>{
    CCSprite *gameOverSprite;
    //CCLabelTTF *levelText,*runTimeDisText;
        //CCLabelBMFont *text1,*text2,*text3,*text4;
    GameMain *gm;
    id gameMain;
    GameOverScene *gameOverScreen;
    NSUserDefaults *userDefaults;
    
    BOOL isNewHighScore;
    PFObject *secondHighScore;
    CCMenu  *menu1nex;
    BOOL if_beated;
    AppDelegate *appDelegate;
    UIViewController *rootViewController;
    UIView *firstView;
    UIView *secondView;
    NSString *BeatFbId;
    UIView *backView;
    AdMobViewController *adm;
    UIView *viewHost1;
    
     sqlite3 *_databaseHandle;
}

+(CCScene *) scene;
-(void)facebookBtnClick:(id)sender ;
@property(nonatomic,strong)NSString *s1;
@property(nonatomic,retain)  GameOverScene *gameOverScreen;
@property(nonatomic,retain) CCSprite *gameOverSprite;
@property(nonatomic,retain) CCLabelTTF *disText,*levelText,*totalScoreText,*runTimeDisText,*runTimeCoinText,*coinText;
@property(nonatomic)NSInteger coinCount;
@property(nonatomic,assign)NSInteger currentLevel;
@property(nonatomic,retain) CCLabelTTF *shareText;
@property (nonatomic,retain) id gameMain;
@property(nonatomic,strong)NSString *coinText1;
@property(nonatomic,assign) int dis;
@property(nonatomic,assign)int scoree;
@property(nonatomic,assign) int distextcount;
@property(nonatomic,assign) int levelBonus;

@property(nonatomic,retain)NSTimer * timer;
@property(nonatomic)NSInteger numsec;
@property(nonatomic,retain) CCLabelTTF *timerTextCnt;
@property(nonatomic,retain)GameMain * gm;

//facebook
@property(nonatomic,retain) CCMenu *shareButtons;
@property(nonatomic,retain) CCMenuItemImage *shareOnFb;
@property(nonatomic,retain) NSString *strPostMessage;
-(void) saveScoreToParse:(NSInteger)score forLevel:(NSInteger)level;

@property(nonatomic,retain) NSMutableArray *mutArrScores;
@property(nonatomic, retain) NSString *lblFbFirstName;
@property(nonatomic, retain) NSString *lblFbLastName;

@property(nonatomic, retain) NSMutableArray *mutArray;

@property(nonatomic, retain)NSMutableArray *mutscoreArray;
@property(nonatomic, retain)NSMutableArray *mutFBidArray;
@property(nonatomic,retain) NSString *str;
@property(nonatomic,retain) NSMutableArray *arrMutableCopy;
@property(nonatomic,strong) NSString * bname;

@property(nonatomic)int a;
@property(nonatomic)int s;
@property(nonatomic,assign)  int pos;

-(void) sendRequestToFrnds;
//-(void) testing;


@property(nonatomic,retain) UIView *backgroundView;
@property(nonatomic,retain) UIButton *playButton;
@property(nonatomic,retain) UIButton *cancelButton;
@property (nonatomic,retain) UIButton *facebookShare; 
@property(nonatomic,retain) UILabel *levellabel;
@property (nonatomic,retain) UILabel *beatlabel;
@property (nonatomic,retain) UILabel *highScoreLabel;
@property (nonatomic,retain) UILabel *yourScore; 

@property(nonatomic,retain)  NSMutableArray * scoreCheck;
@property(nonatomic,retain) UIScrollView *scrollView;



@end
