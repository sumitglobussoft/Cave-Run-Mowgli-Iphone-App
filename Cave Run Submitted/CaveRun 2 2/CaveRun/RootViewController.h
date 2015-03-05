//
//  RootViewController.h
//  CaveRun
//
//  Created by tang on 12-6-4.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADInterstitial.h"
#import "GADInterstitialDelegate.h"
#import <RevMobAds/RevMobAds.h>
#import <FacebookSDK/FacebookSDK.h>
#import "GADBannerView.h"
typedef enum _bannerType
{
    kBanner_Portrait_Top,
    kBanner_Portrait_Bottom,
    kBanner_Landscape_Top,
    kBanner_Landscape_Bottom,
    
}CocosBannerType;

@interface RootViewController : UIViewController<GADInterstitialDelegate,GADBannerViewDelegate> {
 GADBannerView *bannerView;
}
//@property(nonatomic,strong) GADBannerView  *bannerView ;
@property(nonatomic, assign) CGRect frame1;
@property (nonatomic, strong) RevMobBannerView *rev_BannerView;
@property(nonatomic) CocosBannerType mBannerType;

@property (nonatomic, strong) NSString *senderID;
@property (nonatomic, retain) UIView *displayRequestView;
@property (nonatomic, retain) UIView *containerView;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *messageLabel;
@property (nonatomic, retain) UIButton *sendButton;
@property (nonatomic, retain) UIButton *cancelButton;

@property (nonatomic, retain) NSString *senderName;
@property (nonatomic, retain) NSString *currentUserName;
@property (nonatomic, retain) NSArray *requestIDsAry;
@property (nonatomic, assign) NSInteger count;
@property(nonatomic, strong) GADInterstitial *interstitial;
//@property (nonatomic, assign) BOOL revMobSessionStarted;

-(void) createAddBannerView;
-(void) createFullscreenAdmob;
-(void) displayBannerView:(BOOL)display;



@end
