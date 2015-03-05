//
//  GameOverNext.h
//  CaveRun
//
//  Created by Sumit on 29/07/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCSprite.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameMain.h"
#import "GameOverScene.h"
#import <Parse/Parse.h>
#import "UIImageView+WebCache.h"

@class GameMain;
@class GameOverScene;

@interface GameOverNext : CCLayer {
    CCSprite *gameOverSprite;
    UIActivityIndicatorView *activityInd;
    
    NSUserDefaults *userDefaults;
    int score1;
    BOOL isNewHighScore;
    PFObject *secondHighScore;
    
    AppDelegate *appDelegate;
     UIViewController *rootViewController;
    UIView *firstView;
    UIView *secondView;
}

@property(nonatomic,retain) CCSprite *gameOverSprite,*bg1;
@property(nonatomic,assign)int score1;
@property(nonatomic,retain) CCMenu *shareButtons;
@property(nonatomic,retain) CCMenuItemImage *shareOnFb;
@property(nonatomic,retain) NSString *strPostMessage;
@property(nonatomic,strong) CCLabelTTF *bestScore,*high_score,*for_score;
@property(nonatomic,assign) int *hscore;
@property(nonatomic,assign)bool *new_high;
@property(nonatomic)int a;
@property(nonatomic)int s,score;
@property(nonatomic,retain) NSString *str;
@property(nonatomic,assign) NSInteger currentLevel;
//@property (nonatomic,assign) NSInteger *score;

@property(nonatomic, retain) NSMutableArray *mutArray;
@property(nonatomic, retain)NSMutableArray *mutscoreArray;
@property(nonatomic, retain)NSMutableArray *mutFBidArray;

@property(nonatomic,retain) NSMutableArray *mutArrScores;
@property(nonatomic,retain) NSMutableArray *arrMutableCopy;
@property(nonatomic, retain) NSString *lblFbFirstName;
@property(nonatomic, retain) NSString *lblFbLastName;

@property(nonatomic,retain) CCLabelTTF *levelDisplay;
@property(nonatomic,strong) CCLabelTTF *levelDisplay1;
@property(nonatomic,strong)  CCMenu  *menu1nex;

@property(nonatomic,strong) NSString * bname;
@property(nonatomic,retain) UIView *backgroundView;
@property(nonatomic,retain) UIButton *playButton;
@property(nonatomic,retain) UIButton *cancelButton;
@property(nonatomic,retain) UILabel *levellabel;
@property (nonatomic,retain) UILabel *beatlabel; 


@end
