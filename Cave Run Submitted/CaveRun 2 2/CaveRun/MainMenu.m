//
//  Ham.m
//  CaveRun
//
//  Created by tang on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MainMenu.h"
#import "cocos2d.h"
#import "Player.h"
#import "GameMain.h"
#import "SimpleAudioEngine.h"
#import <FacebookSDK/FacebookSDK.h>
#import "LevelSelectionScene.h"
#import "gameResume.h"
#import "AppDelegate.h"
#import <RevMobAds/RevMobAds.h>
#import "Store.h"
#import "RootViewController.h"
#import "Reachability.h"
#import "AdMobViewController.h"
#import "AdMobFullScreenViewController.h"
#import "FriendsLevel.h"
#import "GADBannerView.h"

@implementation MainMenu
CGSize ws;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainMenu *layer = [MainMenu node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
    
    NSLog(@"[UIScreen mainScreen].bounds.size.width %f",[UIScreen mainScreen].bounds.size.width);
    NSLog(@"height = %f",[UIScreen mainScreen].bounds.size.height);
    
    BOOL netwrok_status=[[NSUserDefaults standardUserDefaults] boolForKey:CurrentNetworkStatus];
    if (netwrok_status==YES) {
        rootViewController = (UIViewController*)[(AppDelegate*)[[UIApplication sharedApplication] delegate] getRootViewController];
//         CGSize winSize = [CCDirector sharedDirector].winSize;
        if (adm) {
            adm=nil;
        }
        [GameState sharedState].bottomBanner=YES;
        
        adm = [[AdMobViewController alloc]init];
        viewHost1 = adm.view;
        [[[CCDirector sharedDirector] openGLView] addSubview:viewHost1];
    }

    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(success) name:@"success" object:nil];

     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(failure) name:@"failure" object:nil];
    
    
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"clips.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"enemy.plist"];
    
        
        ws=[[CCDirector sharedDirector]winSize];

        NSLog(@"ws.width is %f",ws.width);
        NSLog(@"ws.height is %f",ws.height);
                
        [CDSoundEngine setMixerSampleRate:CD_SAMPLE_RATE_MID];
    
        self.isTouchEnabled = NO;
        
        CCSprite *sp=[CCSprite spriteWithFile:@"background_1-1.png"];
        sp.anchorPoint=ccp(0,0);
        sp.position=ccp(ws.width==568?0:-(568-480)/2,0);
       
        NSLog(@"ws.width==568?0:-(568-480)/2 %d",ws.width==568?0:-(568-480)/2);
        [self addChild:sp];
        
        
        sp1=[CCSprite spriteWithFile:@"textnew.png"];
        sp1.anchorPoint=ccp(0,0);
        if([UIScreen mainScreen].bounds.size.height>500){
            sp1.position=ccp(80,150);
        }else{
        sp1.position=ccp(50,150);
        }
        
        NSLog(@"[UIScreen mainScreen].bounds.size.height %f",[UIScreen mainScreen].bounds.size.height);
          NSLog(@"[UIScreen mainScreen].bounds.size.width %f",[UIScreen mainScreen].bounds.size.width);
        
        
        if ([UIScreen mainScreen].bounds.size.width>[UIScreen mainScreen].bounds.size.height) {
             sp1.position=ccp(110,150);//iphone 6.
        }
        [self addChild:sp1 ];
        
        
        if (self.connectWithFB) {
            self.connectWithFB=nil;
        }
        self.connectWithFB=[CCMenuItemImage itemFromNormalImage:@"fb1.png" selectedImage:@"fb1.png" target:self selector:@selector(connectwithFacebook)];
        
        self.connectWithFB=[CCMenu menuWithItems:self.connectWithFB, nil];
        if([UIScreen mainScreen].bounds.size.height<500) {
            self.connectWithFB.position=ccp(229, ws.height-269);//iphone 4
        }
        else{
            self.connectWithFB.position=ccp(279, ws.height-269);//iphone 5
        }
        
        NSLog(@"value is [UIScreen mainScreen].bounds.size.width %f",[UIScreen mainScreen].bounds.size.width);
        
        if ([UIScreen mainScreen].bounds.size.width>[UIScreen mainScreen].bounds.size.height) {
             self.connectWithFB.position = ccp(299, ws.height-269);//iphone 6.
        }

        [self addChild:self.connectWithFB];
        
        
        
        if (self.inviteFriend) {
            self.inviteFriend=nil;
        }
        self.inviteFriend=[CCMenuItemImage itemFromNormalImage:@"logout.png" selectedImage:@"logout.png" target:self selector:@selector(LogoutFriendButtonAction)];
        self.inviteFriend=[CCMenu menuWithItems:self.inviteFriend, nil];
        if([UIScreen mainScreen].bounds.size.height<500) {
            self.inviteFriend.position=ccp(229, ws.height-269);
        }
        else{
            self.inviteFriend.position=ccp(279, ws.height-269);
            
        }
        
        if ([UIScreen mainScreen].bounds.size.width>[UIScreen mainScreen].bounds.size.height) {
           self.inviteFriend.position = ccp(299, ws.height-269);//iphone 6.
        }

        [self addChild:self.inviteFriend];
        
       // BOOL fbCheck=[[NSUserDefaults standardUserDefaults]boolForKey:FacebookConnected];
       
        if (FBSession.activeSession.isOpen) {
            self.connectWithFB.visible=NO;
            self.inviteFriend.visible=YES;
            
        }else{
            
            self.connectWithFB.visible=YES;
            self.inviteFriend.visible=NO;
            
        }
//        if (fbCheck==NO){
//            self.connectWithFB.visible=YES;
//            self.inviteFriend.visible=NO;
//        }
//        else{
//            self.connectWithFB.visible=NO;
//            self.inviteFriend.visible=YES;
//        }
        
        
        CCMenuItemImage *play = [CCMenuItemImage  itemFromNormalImage:@"click1.png" selectedImage:@"click1.png" target:self selector:@selector(clickToPlay:)];
      
        click=[CCMenu menuWithItems:play, nil];
        if([UIScreen mainScreen].bounds.size.height>500){
         click.position=ccp(279, ws.height-230);
        }else{
       click.position=ccp(229, ws.height-230);
        }
 
        if ([UIScreen mainScreen].bounds.size.width>[UIScreen mainScreen].bounds.size.height) {
          click.position = ccp(299, ws.height-230);//iphone 6.
        }
        
        [self addChild:click];
        CCMenuItemImage *store_img = [CCMenuItemImage  itemFromNormalImage:@"store.png" selectedImage:@"store.png" target:self selector:@selector(store_button:)];
        
        store=[CCMenu menuWithItems:store_img, nil];
        if([UIScreen mainScreen].bounds.size.height>500){
            store.position=ccp(450, ws.height-230);
        }else{
            store.position=ccp(390, ws.height-230);
        }
        
        
        if ([UIScreen mainScreen].bounds.size.width>[UIScreen mainScreen].bounds.size.height) {
            store.position = ccp(480, ws.height-230);//iphone 6.
        }
        
        [self addChild:store];
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"bgm.mp3" loop:YES];
        
    }
    return self;
    
}

-(void)success{
    self.connectWithFB.visible=NO;
    self.inviteFriend.visible=YES;

   //  [[NSNotificationCenter defaultCenter] removeObserver:self name:@"success" object:nil];
}

-(void)failure{
    self.connectWithFB.visible=YES;
    self.inviteFriend.visible=NO;

  //  [[NSNotificationCenter defaultCenter] removeObserver:self name:@"failure" object:nil];
}

-(void)hideaction{
     self.inviteFriend.visible=YES;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hideaction" object:nil];
}

-(void)LogoutFriendButtonAction{
 
    BOOL FBConnected = [[NSUserDefaults standardUserDefaults] boolForKey:FacebookConnected];
   
    if (FBConnected) {
        
          NSLog(@"log out");
        self.connectWithFB.visible=YES;
        self.inviteFriend.visible=NO;
        
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:FacebookConnected];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        if (FBSession.activeSession.isOpen) {
            [FBSession.activeSession closeAndClearTokenInformation];
            [FBSession.activeSession close];
            [FBSession setActiveSession:nil];
            
//            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:FacebookConnected];
//            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    }
    
    else{
        
//       UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"There is no Internet Connection in your device" message:@"Check Internet ConnectionFirst" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//         [alert show];
    }
}

 #pragma mark-
-(void)connectwithFacebook{
    
    NSLog(@"connect with facebook button clicked.");
    BOOL connect=[[NSUserDefaults standardUserDefaults]boolForKey:CurrentNetworkStatus];
//    BOOL FBConnected = [[NSUserDefaults standardUserDefaults] boolForKey:FacebookConnected];
    
    if(connect==YES)
    {
          NSLog(@"log in");
//        self.connectWithFB.visible=NO;
//        self.inviteFriend.visible=YES;
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDelegate.delegate = nil;
        [appDelegate openSessionWithLoginUI:8 withParams:nil withString:nil];
//        [appDelegate openSessionWithAllowLoginUI:1];
        
    }
    else{
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"There is no Internet Connection in your device" message:@"Check Internet Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];

    }
}

/*
-(void) fbButtonTapped: (id) sender
{
    if ((self.fbToggle.selectedIndex==1)) {
        NSLog(@"Sound button tapped!");
        [self connectwithFacebook];
    }else{
        
        [self logOut];
        
    }
    
}
*/

#pragma connectivity check
-(void)reacheability
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if(status == NotReachable)
    {
        NSLog(@"stringgk////");
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"There is no Internet Connection in your device" message:@"Check Internet ConnectionFirst" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (status == ReachableViaWiFi)
    {
        NSLog(@"reachable");
        
    }
    else if (status == ReachableViaWWAN)
    {
        //3G
    }
    // Do any additional setup after loading the view.
    
}

#pragma mark-connnect to facebook 
#pragma mark====================
/*
-(void)connectwithFacebook{
    
    NSLog(@"connect with facebook button clicked.");
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDelegate.delegate = nil;
    [appDelegate openSessionWithLoginUI:8 withParams:nil];
//        connectWithFB.visible = NO;

}
*/
-(void)logOut{
    
    [FBSession.activeSession closeAndClearTokenInformation];
    [FBSession.activeSession close];
    [FBSession setActiveSession:nil];
}

-(void)clickToPlay:(id)sender{
  [[NSNotificationCenter defaultCenter] postNotificationName:@"hidebanner" object:nil];
    
   [viewHost1 removeFromSuperview];
    viewHost1 = nil;
//    [adm.view removeFromSuperview];
   // [[GameState sharedState].bannerView removeFromSuperview];
// [[NSNotificationCenter defaultCenter] postNotificationName:@"hidebannerview" object:nil];
    BOOL fbCheck = [[NSUserDefaults standardUserDefaults] boolForKey:FacebookConnected];
    BOOL networkStatus = [[NSUserDefaults standardUserDefaults]boolForKey:CurrentNetworkStatus];
    
     if (fbCheck==YES && networkStatus == YES) {
        
          [[CCDirector sharedDirector]replaceScene:[CCTransitionFadeTR transitionWithDuration:0.8 scene:[FriendsLevel scene]]];
        
    }else{
       [[CCDirector sharedDirector]replaceScene:[CCTransitionFadeTR transitionWithDuration:0.8 scene:[LevelSelectionScene scene]]];
    }
     
//      [self performSelector:@selector(playAction) withObject:nil afterDelay:3];
    
    
    
}
-(void)playAction{
    
    BOOL fbCheck = [[NSUserDefaults standardUserDefaults] boolForKey:FacebookConnected];
    BOOL networkStatus = [[NSUserDefaults standardUserDefaults]boolForKey:CurrentNetworkStatus];

    if (fbCheck==YES && networkStatus == YES) {
        
        [[CCDirector sharedDirector]replaceScene:[CCTransitionFadeTR transitionWithDuration:0.8 scene:[FriendsLevel scene]]];
        
    }else{
        [[CCDirector sharedDirector]replaceScene:[CCTransitionFadeTR transitionWithDuration:0.8 scene:[LevelSelectionScene scene]]];
    }

    
}
-(void)store_button:(id)sender
{
    [viewHost1 removeFromSuperview];
    viewHost1 = nil;
    
   
//     [[NSNotificationCenter defaultCenter] postNotificationName:@"hidebannerview" object:nil];
//     [adm.view removeFromSuperview];

//    [GameState sharedState].bannerView = nil;
    
    BOOL networkStatus = [[NSUserDefaults standardUserDefaults] objectForKey:CurrentNetworkStatus];
    NSLog(@"network status is %d",networkStatus);
    
    if(networkStatus==NO)
    {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"internet connection required for this process  " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        return;
    }
    
    store.visible=NO;
    sp1.visible=NO;
    click.visible=NO;
    Store *obj = [[Store alloc]init];
    [self addChild:obj];
    
    /*
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    RootViewController *viewCntrler = (RootViewController*)[appDelegate getRootViewController];
    CGRect frame = [UIScreen mainScreen].bounds;
    FriendsViewController *fbFrnds = [[FriendsViewController alloc] initWithHeaderTitle:@"Ask Life"];//WithNibName:@"FriendsViewController" bundle:nil];
    fbFrnds.view.frame = CGRectMake(0, 0, frame.size.height, 0);;
   
    //fbFrnds.headerTitle = @"Ask Life";
    [UIView animateWithDuration:1 animations:^{
        
        fbFrnds.view.frame = CGRectMake(0, 0, frame.size.height, frame.size.width);
        [viewCntrler presentViewController:fbFrnds animated:YES completion:nil];
        //[viewCntrler.view addSubview:fbFrnds.view];
    }];
    
    
    
    return;
    NSString *toSend = @"AVm832yUM485NgS2KPYdymJ6W8jM98BIIKrtuaOs--8gOqCijWTfbFGB_fis50wcXSibPqeqLWEC9IMR4myLZ1NG9LVj45idb_keykShqyfb2w,AVl8ZzMAWvs8PcrUmDwkkHi0FGAWWDxLylRV6WMC-0XnjdsZrWywPOQ9PYJI-H52BvXEgF0T8pJBCZRlfH7SAIwUcsHjKS_aLUtlZwnkjm2_Og";
    
    NSMutableDictionary* params =   [NSMutableDictionary dictionaryWithObjectsAndKeys:toSend, @"to",@"Invite Friends", @"data",@"Invite Friends a",@"message",@"Invite Friends",@"Title",nil];
    
    //AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (!FBSession.activeSession.isOpen){
        [appDelegate openSessionWithLoginUI:8 withParams:nil];
    }
    else{
        [appDelegate sendRequestToFriends:params];
    }
    
    return;
    
    if (!FBSession.activeSession.isOpen) {
        // if the session is closed, then we open it here, and establish a handler for state changes
        [FBSession openActiveSessionWithReadPermissions:nil
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session,
                                                          FBSessionState state,
                                                          NSError *error) {
                                          if (error) {
                                              UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                  message:error.localizedDescription
                                                                                                 delegate:nil
                                                                                        cancelButtonTitle:@"OK"
                                                                                        otherButtonTitles:nil];
                                              [alertView show];
                                          } else if (session.isOpen) {
                                              [appDelegate pickFriendsButtonClick:nil];
                                          }
                                      }];
        return;
    }
    else{
        [appDelegate pickFriendsButtonClick:nil];
    }
    
    return;
    
    
    [ad removeFromSuperview];
     */
}
//replaceScene to GameMain
#pragma mark - chartboost interstial ads delegate.

- (BOOL)shouldRequestInterstitial:(CBLocation)location{
    NSLog(@"shouldRequestInterstitial");
    return YES;
}
- (BOOL)shouldDisplayInterstitial:(CBLocation)location{
    NSLog(@"shouldDisplayInterstitial");
    return YES;
}
- (void)didDisplayInterstitial:(CBLocation)location{
    NSLog(@"didDisplayInterstitial");
}
- (void)didCacheInterstitial:(CBLocation)location{
    NSLog(@"didCacheInterstitial");
}
- (void)didFailToLoadInterstitial:(CBLocation)location
                        withError:(CBLoadError)error{
    NSLog(@"didFailToLoadInterstitial");
}
- (void)didFailToRecordClick:(CBLocation)location
                   withError:(CBClickError)error{
    NSLog(@"didFailToRecordClick");
}

- (void)didDismissInterstitial:(CBLocation)location{
    NSLog(@"didDismissInterstitial");
}
- (void)didCloseInterstitial:(CBLocation)location{
    NSLog(@"didCloseInterstitial");
}
- (void)didClickInterstitial:(CBLocation)location{
    NSLog(@"didClickInterstitial");
}


-(void) dealloc{
    [super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
