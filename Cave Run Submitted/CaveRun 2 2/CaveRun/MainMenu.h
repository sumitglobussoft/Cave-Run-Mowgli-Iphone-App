//
//  Ham.h
//  CaveRun
//
//  Created by tang on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"
#import <RevMobAds/RevMobAds.h>
#import "AppDelegate.h"
#import "RootViewController.h"
#import "FacebookFriendsTableViewController.h"
#import "FriendsViewController.h"
#import "AdMobViewController.h"
#import <Chartboost/Chartboost.h>
#import <Chartboost/CBNewsfeed.h>


@interface MainMenu : CCLayer<ChartboostDelegate>{
    CCMenu *connectWithFB;
    CCMenu *click,*store;
    CCSprite *sp1;
     UIViewController *rootViewController;
    AdMobViewController *adm;
    UIView *viewHost1;
//    GADBannerView *mBannerView;
    
}
+(CCScene *) scene;
-(void)store_button:(id)sender;
@property(nonatomic,retain)CCMenuItemToggle *fbToggle;
@property (nonatomic, strong) CCMenuItem *connectWithFB,* inviteFriend;
@end
