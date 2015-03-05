//
//  LifeOver.h
//  CaveRun
//
//  Created by Sumit Ghosh on 26/03/14.
//  Copyright (c) 2014 tang. All rights reserved.
//

#import "CCSprite.h"
#import "CCLayer.h"
#import "cocos2d.h"
#import <FacebookSDK/FacebookSDK.h>
#import "GameState.h"
#import "AppDelegate.h"
#import "FriendsViewController.h"
#import <Chartboost/Chartboost.h>
#import <Chartboost/CBNewsfeed.h>
#import "AdMobViewController.h"

@interface LifeOver : CCSprite <AppDelegateDelegate,ChartboostDelegate,UIAlertViewDelegate>{
    
    int min;
    int sec;
    int remTime;
    NSUserDefaults *userDefault;
    bool flag_fortimer;
    AdMobViewController *adm;
    UIView *viewHost1;
    BOOL isInterstitialFail;
      UIViewController *rootViewController;

}

@property(nonatomic,retain) CCLabelBMFont *lblNextLifeTime;
@property(nonatomic,retain) CCLabelBMFont *timeText;
@property(nonatomic,retain) CCLabelBMFont *lblMoreLifeNow;
@property(nonatomic,retain) CCMenu *menuAskFrnd;
@property(nonatomic,retain) CCMenu *menuMoreLife,*menu1;
@property(nonatomic,retain) CCMenu *menuBack;
@property(nonatomic,assign) id storeLayer;
@property(nonatomic,assign)CCSprite *nextLife;
@property(nonatomic,retain)CCSprite *cave;
@property(nonatomic,retain)CCSprite *nomorelives;
@property(nonatomic,retain)CCSprite *nextLifeImg;
@property(nonatomic,strong) UIView *feedbackView ;
@property(nonatomic,strong) UIButton *cancelBtn;
@property(nonatomic,strong) UILabel *livesLabel;
@property(nonatomic,strong) UILabel *descLabel;
- (void)Timer;
+(CCScene *) scene;

@end
