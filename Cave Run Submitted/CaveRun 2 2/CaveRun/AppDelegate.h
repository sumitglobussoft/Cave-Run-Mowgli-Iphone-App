//
//  AppDelegate.h
//  CaveRun
//
//  Created by tang on 12-6-4.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <FacebookSDK/FacebookSDK.h>
#import "MBProgressHUD.h"
#import <sqlite3.h>
#import "GADBannerView.h"


@class RootViewController;
@class GADBannerView;

@protocol AppDelegateDelegate <NSObject>

@optional
-(void)displayFacebookFriendsList;
-(void) hideFacebookFriendsList;
@end

@interface AppDelegate : NSObject <UIApplicationDelegate,NSURLSessionDelegate, NSURLSessionTaskDelegate,
NSURLSessionDownloadDelegate, FBFriendPickerDelegate,GADBannerViewDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
    FBFrictionlessRecipientCache* ms_friendCache;
    MBProgressHUD *HUD;
    GADBannerView *bannerView;
    
     sqlite3 *_databaseHandle;
    NSMutableArray * localData;
    BOOL master;
}

@property (nonatomic, strong) id <AppDelegateDelegate> delegate;
@property(nonatomic, assign) CGRect frame1;
@property(nonatomic,retain) id pl; 
@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, assign) NSInteger CurrentValue;
@property(nonatomic,strong) NSMutableString *friendsList;
@property(nonatomic,assign)int friendsCount;

@property (nonatomic,retain) NSString *userName;

@property (nonatomic, strong) NSDictionary *openGraphDict;

@property (retain, nonatomic) FBFriendPickerViewController *friendPickerController;
- (IBAction)pickFriendsButtonClick:(id)sender;

- (BOOL)openSessionWithAllowLoginUI:(NSInteger)isLoginReq;
-(void) fetchFacebookGameFriends:(NSString *)accessToken;
-(UIViewController *) getRootViewController;

- (BOOL)openSessionWithAllowLoginUI:(NSInteger)isLoginReq;
-(BOOL) openSessionWithLoginUI:(NSInteger)value withParams: (NSDictionary *)dict withString:(NSMutableString *)string;
-(void) shareOnFacebookWithParams:(NSDictionary *)params;

-(void) sendRequestToFriends:(NSMutableString *)params;

-(void) storyPostwithDictionary:(NSDictionary *)dict;
-(void) fetchAllFacebookFriends;
-(void) shareOnFacebookWithParamsForLives:(NSDictionary *)params;
-(void) shareOnFacebookFeedDialog:(NSDictionary *)params;
-(void) shareBeatStoryWithParams:(NSDictionary *)params;

+(AppDelegate *)sharedAppDelegate;
-(void) showHUDLoadingView:(NSString *)strTitle;
-(void) hideHUDLoadingView;
-(void)showToastMessage:(NSString *)message;
-(void)saveinSqlite;
-(void)showBannerAdd;
-(void)hideBannerAd;
@end
