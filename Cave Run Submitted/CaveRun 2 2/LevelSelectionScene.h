//
//  LevelSelectionScene.h
//  BowHunting
//
//  Created by Sumit Ghosh on 03/05/14.
//  Copyright (c) 2014 tang. All rights reserved.
//

#import "CCSprite.h"
#import "cocos2d.h"
#import "AdMobViewController.h"
#import "CCAnimation+SequenceLoader.h"
#import "CCAnimate+SequenceLoader.h"
#import "AdMobFullScreenViewController.h"
#import "CCAnimation.h"
#import <RevMobAds/RevMobAds.h>
#import "RootViewController.h"
#import "UIImageView+WebCache.h"



@interface LevelSelectionScene : CCSprite<GADInterstitialDelegate> {
    UIButton *btnLevels;
    UIButton *btnBack;
    UIViewController *rootViewController;
    UIScrollView *scrollV;
    UIView *firstView;
    UIView *secondView;
    CCMenu *menuBack;
    CCSprite *spriteBackground;
    CCSprite *levelBackground;
    CCSprite *man;
    CCAction *walkAction;
    NSUserDefaults *lives1;
    AdMobViewController *adMob ;
    UIView *viewHost ;
    RootViewController	*viewController;
     UIWindow *window;
    AdMobViewController *adm;
    UIView *viewHost1;

}

@property(nonatomic, strong) GADInterstitial *interstitial;
@property(nonatomic,retain) id gm,loopRun;
@property(nonatomic,retain) UIButton *playButton;
@property(nonatomic,retain) UIView *backgroundView;
@property(nonatomic,retain) UIButton *cancelButton1;
@property(nonatomic,retain) UIButton *cancelBtn; 
@property(nonatomic,retain) CCSprite *man;
@property(nonatomic,assign) int lives;
@property(nonatomic,retain) id player;
@property(nonatomic,retain) UIImageView *imgView;
@property(nonatomic,retain) UILabel *namelabel;
@property(nonatomic,retain) UILabel *scorelabel;
@property(nonatomic,retain) UILabel *levellabel;
@property(nonatomic,retain) UILabel *targetlabel;
@property(nonatomic,assign)  int target;
@property(nonatomic,assign) NSMutableArray *mutArray;
@property(nonatomic,retain) NSMutableArray *arrMutableCopy;
@property(nonatomic,strong) UIView *friendsView;
@property(nonatomic,strong) UIScrollView *bottomScroll ; 


+(CCScene *) scene;
-(void)cancelBtnAction:(id)sender ; 
-(void) retriveFriendsScore:(NSInteger)level ;
- (void) createUI:(int)level;
-(id)init;







@end
