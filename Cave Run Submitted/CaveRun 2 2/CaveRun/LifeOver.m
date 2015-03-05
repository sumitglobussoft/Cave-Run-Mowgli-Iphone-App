//
//  LifeOver.m
//  CaveRun
//
//  Created by Sumit Ghosh on 26/03/14.
//  Copyright (c) 2014 tang. All rights reserved.
//

#import "LifeOver.h"
#import "GameOverScene.h"
#import "AppDelegate.h"
#import "SBJson.h"
#import <RevMobAds/RevMobAds.h>
#import "MainMenu.h"
#import "GameMain.h"
#import "LevelSelectionScene.h"
#import "RageIAPHelper.h"
#import "Store.h"
#define RequestTOFacebook @"LifeRequest"

@implementation LifeOver
@synthesize lblNextLifeTime,timeText,menuAskFrnd,lblMoreLifeNow,menuMoreLife,menuBack,cave,nomorelives,menu1,nextLifeImg,nextLife;
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	LifeOver *layer = [LifeOver node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

CGSize ws;

-(id) init
{
	if( (self=[super init])) {
        
         BOOL netwrok_status=[[NSUserDefaults standardUserDefaults] boolForKey:CurrentNetworkStatus];
        
       [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backaction) name:@"backaction" object:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showui) name:@"showui" object:nil];

        
        if (netwrok_status == YES) {
//            AdMobFullScreenViewController *adf= [[AdMobFullScreenViewController alloc]init];
        }
        isInterstitialFail=YES;
        //testing id .
        
        
//        [Chartboost startWithAppId:@"54cb98010d602505e20248d2"
//                      appSignature:@"0657de2558cf69704baa2f2b406013fc4cbfe36c"
//                          delegate:self];
        
        //Live Id.
 
        [Chartboost startWithAppId:@"54859c09c909a6309833a2c4"
                      appSignature:@"6b5efdfe6e15db9fd3948e8e7d21c23a1ad59efc"
                          delegate:self];
      
          rootViewController = (UIViewController*)[(AppDelegate*)[[UIApplication sharedApplication] delegate] getRootViewController];
        
            if (netwrok_status==YES) {
              //  CGSize winSize=[CCDirector sharedDirector].winSize;
               
                if (adm) {
                    adm=nil;
                }
            [GameState sharedState].bottomBanner=NO;
                
                adm = [[AdMobViewController alloc]init];
                viewHost1 = adm.view;
                [[[CCDirector sharedDirector] openGLView] addSubview:viewHost1];


        }

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkTimeNotification:) name:@"CheckTimeForLife" object:nil];
        
        ws=[[CCDirector sharedDirector]winSize];
        
        cave= [CCSprite spriteWithFile:@"background_1-1.png"];
        cave.anchorPoint=ccp(0,0);
        cave.position=ccp(ws.width==568?0:-(568-480)/2,0);
        [self addChild:cave];
        
        nomorelives=[CCSprite spriteWithFile:@"nomorelives.png"];
     //   nomorelives.anchorPoint=ccp(0,0);
        
        if([UIScreen mainScreen].bounds.size.height<500)
        {
            nomorelives.position=ccp(ws.width/2,ws.height/2+90);
        }
        
        else{
            nomorelives.position=ccp(ws.width/2,ws.height/2+90);
        }
        
//        if ([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0) {
//           nomorelives.position=ccp(205,ws.height/2+90);// for iPhone 6.
//        }
        [self addChild:nomorelives z:100];
        
        nextLife = [CCSprite spriteWithFile:@"nextlife-1.png"];
        
        if([UIScreen mainScreen].bounds.size.height<500)
        {
            nextLife.position=ccp(ws.width/2,ws.height/2+50);
        }
        else
        {
            nextLife.position=ccp(ws.width/2,ws.height/2+50);
        }
      
         [self addChild:nextLife z:100];
       
        
        
        //----------------
        //Time Calculation for next Life
        
        self.timeText=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%i: 0%i",min,sec] fntFile:@"font_30.fnt"];
        userDefault = [NSUserDefaults standardUserDefaults];
       
        
        remTime=(int)[[NSUserDefaults standardUserDefaults]integerForKey:@"timeRem"];
        
        //[self calculateTime:remTime];
        [self compareDate];
        
        self.timeText.position=ccp(ws.width/2,ws.height/2+5);
        [self addChild:self.timeText];
        
        CCMenuItem *menuItemAskFrnds=[CCMenuItemImage itemFromNormalImage:@"refill_lives.png" selectedImage:@"refill_lives.png" target:self selector:@selector(askFrndsButtonClicked:)];
        
        menu1 = [CCMenu menuWithItems: menuItemAskFrnds, nil];
        
        if([UIScreen mainScreen].bounds.size.height<500)
        {
            menu1.position = ccp(ws.width/2,120);
        }
        else{
            menu1.position=ccp(ws.width/2,120);
        }
        [menu1 alignItemsHorizontally];
        [self addChild:menu1 z:100];

        
        CCMenuItem *menuItemMoreLife = [CCMenuItemImage itemFromNormalImage:@"get_more_live.png" selectedImage:@"get_more_live.png" target:self selector:@selector(moreLivesButtonClicked:)];
        
        menuMoreLife = [CCMenu menuWithItems: menuItemMoreLife, nil];
        if([UIScreen mainScreen].bounds.size.height<500)
        {
            menuMoreLife.position = ccp(ws.width/2, 50);
        }
        else{
            self.menuMoreLife.position=ccp(ws.width/2,50);
        }
        [menuMoreLife alignItemsHorizontally];
        [self addChild:menuMoreLife z:100];
        
        CCMenuItem *menuItemBack = [CCMenuItemImage itemFromNormalImage:@"backLevel.png" selectedImage:@"backLevel.png" target:self selector:@selector(back:)];
        
        menuBack = [CCMenu menuWithItems: menuItemBack, nil];
        if([UIScreen mainScreen].bounds.size.height<500)
        {
            menuBack.position = ccp(40, ws.height-45);
        }
        else{
            menuBack.position=ccp(40,ws.height-45);
        }
        [menuBack alignItemsHorizontally];
        [self addChild:menuBack z:100];
      }
    return self;
}
-(void)showui{
    
    CGRect frame = [UIScreen mainScreen].bounds;
    
  //  self.feedbackView = [[[UIView alloc] initWithFrame:CGRectMake(100,70, 276,129)] autorelease];
    
    if([UIScreen mainScreen].bounds.size.height>500){
        self.feedbackView = [[[UIView alloc] initWithFrame:CGRectMake(130,70, 276,129)] autorelease];
        //530
    }else{
        self.feedbackView = [[[UIView alloc] initWithFrame:CGRectMake(100,70, 276,129)] autorelease];
    }

    
//    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0) {
//        self.feedbackView.frame = CGRectMake(150,70, 276,129);
//    }
    self.feedbackView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"life_added.png"]];
    [rootViewController.view addSubview:self.feedbackView];
    
    UIImage *canImg = [UIImage imageNamed:@"close2.png"];
    self.cancelBtn = [[UIButton alloc]init];
    
    if([UIScreen mainScreen].bounds.size.height>500){
       self.cancelBtn .frame=CGRectMake(210,0,100,50);//iphone 6
        //530
    }else{
        self.cancelBtn .frame=CGRectMake(210,0,100,50);
    }
  //  self.cancelBtn .frame=CGRectMake(210,0,100,50);
    
//    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0) {
//        self.cancelBtn.frame = CGRectMake(210,-10,100,50);
//    }
    //                     WithFrame:CGRectMake(400, 20, 30, 30)];
    [ self.cancelBtn  setImage:canImg forState:UIControlStateNormal];
   
    [ self.cancelBtn  addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.feedbackView addSubview:self.cancelBtn];
    
//    self.livesLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,20,frame.size.height-150, 20)] ;
    if([UIScreen mainScreen].bounds.size.height>500){
       self.livesLabel = [[UILabel alloc] initWithFrame:CGRectMake(70,20,frame.size.width-150, 20)] ;
        //530
    }else{
        self.livesLabel = [[UILabel alloc] initWithFrame:CGRectMake(70,20,frame.size.width-150, 20)] ;
    }
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
//      if([UIScreen mainScreen].bounds.size.width>660) {
//         self.livesLabel.frame = CGRectMake(50,20,frame.size.height-150, 20);
//     }
//        //iphone 6
//    }

    self.livesLabel.textColor = [UIColor blackColor];
    self.livesLabel.font = [UIFont boldSystemFontOfSize:15];
    self.livesLabel.backgroundColor = [UIColor clearColor];
//    self.livesLabel.textAlignment = NSTextAlignmentCenter;
    self.livesLabel.text = @"Lives added";
    [self.feedbackView addSubview:self.livesLabel];

    
   // self.descLabel = [[UILabel alloc] initWithFrame:CGRectMake(-30,90,frame.size.height-140, 20)] ;
    if([UIScreen mainScreen].bounds.size.height>500){
       self.descLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,90,frame.size.width-70, 20)] ;
        //530
    }else{
        self.descLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,90,frame.size.width-70, 20)] ;
    }
    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
////         if([UIScreen mainScreen].bounds.size.width>660) {
//        self.descLabel.frame = CGRectMake(0,90,frame.size.height-50, 20);
////         }
//        //iphone 6
//    }
    self.descLabel.textColor = [UIColor blackColor];
    self.descLabel.font = [UIFont boldSystemFontOfSize:10];
     self.descLabel.backgroundColor = [UIColor clearColor];
//    self.descLabel.textAlignment = NSTextAlignmentCenter;
  //  self.descLabel.numberOfLines = 2;
    self.descLabel.text = [NSString stringWithFormat:@"Cave Run Mowgli refilled with lives.Enjoy the game"];
  //  self.descLabel.text = @"Cave Run Mowgli refilled with lives \n Enjoy the game";
    [self.feedbackView addSubview:self.descLabel];

    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"showui" object:nil];
}

-(void)cancelBtnAction:(id)sender{
    [self.feedbackView removeFromSuperview];
       [[NSNotificationCenter defaultCenter] postNotificationName:@"backaction" object:nil];
}


#pragma mark-
-(void) checkTimeNotification:(NSNotification *)notification{
    
    NSLog(@"Notification Received");
    [self compareDate];
    
}

-(void)compareDate {
    
    NSString *strDate = [userDefault objectForKey:@"strtdate"];
    
    if (![strDate isEqualToString:@"0"]) {
        
        NSDate *currentDate = [NSDate date];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
        
        NSString *strCurrentDate = [formatter stringFromDate:currentDate];
        
        currentDate=[formatter dateFromString:strCurrentDate];
        
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc]init];
        [formatter1 setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
        
        NSDate *oldDate = [formatter1 dateFromString:strDate];
        
        unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSSecondCalendarUnit;
        NSCalendar *gregorianCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        
        NSDateComponents *conversionInfo = [gregorianCal components:unitFlags fromDate:oldDate  toDate:currentDate  options:0];
        
        //int months = (int)[conversionInfo month];
        int days = (int)[conversionInfo day];
        int hours = (int)[conversionInfo hour];
        int minutes = (int)[conversionInfo minute];
        int seconds = (int)[conversionInfo second];
        
        //NSLog(@"%d months , %d days, %d hours, %d min %d sec", months, days, hours, minutes, seconds);
        
        [self getExtraLife:days andHour:hours andMin:minutes andSec:seconds];
    }
    else{
        
        self.timeText.visible = NO;
        [self.lblNextLifeTime setString:@"Full of life"];
        
    }
}

-(void)getExtraLife :(int)aday andHour:(int)ahour andMin:(int)amin andSec:(int)asec
{
    //call for notifications for full life alert....
    [self setupLocalNotifications ];
    int hoursInMin = ahour*60;
    hoursInMin=hoursInMin+amin;
    int extralife =amin/5;
    
    int totalTime = amin*60+asec;
    
    int rem =amin%5;
    
    int remTimeforLife = rem*60+asec;
    
    remTimeforLife=300-remTimeforLife;
    
    
    if (aday>0 || hoursInMin>=25) {
        
        [userDefault setInteger:5 forKey:@"live"];
        [userDefault setObject:@"0" forKey:@"strtdate"];
      }
    else if(totalTime>=300){
        
        if(extralife>=5){
            
            [userDefault setInteger:5 forKey:@"live"];
            [userDefault synchronize];
            [userDefault setObject:@"0" forKey:@"strtdate"];
            self.timeText.visible = NO;
            [self.lblNextLifeTime setString:@"Full of life"];
        }
        else{
            
            if (extralife>5) {
                extralife = 5;
            }
           
            [userDefault setInteger:extralife forKey:@"live"];
            [userDefault synchronize];
            [self calculateTime:remTimeforLife];
        }
    }
    else{
        [self calculateTime:remTimeforLife];
    }
    
    
}

- (void)setupLocalNotifications {
    
    BOOL check = [[NSUserDefaults standardUserDefaults]boolForKey:@"checkLivesNotification"];
    if(check){
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
        UILocalNotification * localNotification = [[UILocalNotification alloc] init];
        
        // current time plus 1500(.25 hrs) secs
        
        NSDate *now = [NSDate date];
        NSDate *dateToFire = [now dateByAddingTimeInterval:1500];
        
        NSLog(@"now time: %@", now);
        NSLog(@"fire time: %@", dateToFire);
        
        localNotification.fireDate = dateToFire;
        
        localNotification.alertBody =@"% Cave Run Mowgli is full of Lives Now! ";
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"checkLivesNotification"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
    }
}

-(void) calculateTime:(int)timeRem{
    
    remTime = timeRem;
    NSLog(@"remaining time is %d",remTime);
    
    if (remTime) {
        
        min=remTime/60;
        sec=remTime%60;
        
       
        
        if (sec<10) {
            [self.timeText setString:[NSString stringWithFormat:@"%i: 0%i",min,sec]];
        }
        else{
            [self.timeText setString:[NSString stringWithFormat:@"%i: %i",min,sec]];
        }
        
        
        [self unschedule:@selector(Timer)];
        [self schedule:@selector(Timer) interval:1];
    }
}

- (void)Timer {
    
      int life = (int)[userDefault integerForKey:@"live"];
    
    if (life>=5) {
        self.timeText.visible = NO;
        [self unschedule:@selector(Timer)];
        return;
    }
    
    remTime--;
    //NSLog(@"First value of rem%d",remTime);
    [[NSUserDefaults standardUserDefaults] setInteger:remTime forKey:@"timeRem"];
    int minute = remTime/60;
    int second = remTime%60;
    
    if (second<10) {
        [self.timeText setString:[NSString stringWithFormat:@"%i:0%i",minute,second]];
    }
    else{
        [self.timeText setString:[NSString stringWithFormat:@"%i:%i",minute,second]];
    }
    
    if (remTime==0) {
       [self unschedule:@selector(Timer)];
        
      
        
        life++;
        remTime=300;
        
      [self.timeText setString:[NSString stringWithFormat:@"30:00"]];
        if (life>=5) {
            self.timeText.visible = NO;
            [self.lblNextLifeTime setString:@"Full of life"];
            self.lblNextLifeTime.visible = YES;
            [userDefault setInteger:5 forKey:@"live"];
            [userDefault setObject:@"0" forKey:@"strtdate"];
//            [userDefault setInteger:0 forKey:@"GainLife"];
        }
        else if (life<5){
            [userDefault setInteger:life forKey:@"live"];
            [self schedule:@selector(Timer) interval:1];
        }
        
        NSLog(@"life in timer after increment is %d",life);
        [userDefault setInteger:1 forKey:@"check"];
        [userDefault synchronize];
        
    }
}


-(void)retryAction:(id)sender {
    NSLog(@"in retry action");
    
    [self removeChild:self.lblNextLifeTime cleanup:YES];
    [self removeChild:self.menuAskFrnd cleanup:YES];
    [self removeChild:self.menuBack cleanup:YES];
    [self removeChild:self.menuMoreLife cleanup:YES];
    [self removeChild:self.cave cleanup:YES];
    [self removeChild:self.nomorelives cleanup:YES];
  
 [[CCDirector sharedDirector]replaceScene:[CCTransitionFadeTR transitionWithDuration:0.5 scene:[GameMain scene]]];
    
    
}

#pragma mark
#pragma mark Button methods
#pragma mark ==============================================
-(void)backaction{
    [viewHost1 removeFromSuperview];
    viewHost1 = nil;
    
    [self.feedbackView removeFromSuperview];
    
    [self removeChild:self.lblNextLifeTime cleanup:YES];
    [self removeChild:self.menuAskFrnd cleanup:YES];
    [self removeChild:self.menuBack cleanup:YES];
    [self removeChild:self.menuMoreLife cleanup:YES];
    [self removeChild:self.cave cleanup:YES];
    [self removeChild:self.nomorelives cleanup:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CheckTimeForLife" object:nil];
//     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backaction" object:nil];
    [[CCDirector sharedDirector]replaceScene:[LevelSelectionScene scene]];
    
}

-(void)back:(id)sender {
    
    [viewHost1 removeFromSuperview];
    viewHost1 = nil;
    
    [self.feedbackView removeFromSuperview];
    
        [self removeChild:self.lblNextLifeTime cleanup:YES];
        [self removeChild:self.menuAskFrnd cleanup:YES];
        [self removeChild:self.menuBack cleanup:YES];
        [self removeChild:self.menuMoreLife cleanup:YES];
        [self removeChild:self.cave cleanup:YES];
        [self removeChild:self.nomorelives cleanup:YES];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CheckTimeForLife" object:nil];
    [[CCDirector sharedDirector]replaceScene:[LevelSelectionScene scene]];
}

-(void)askFrndsButtonClicked:(id)sender {
     [self.feedbackView removeFromSuperview];
    [viewHost1 removeFromSuperview];
    viewHost1 = nil;
    
//     [adm.view removeFromSuperview];
//    [viewHost1 removeFromSuperview];
//    viewHost1 = nil;
// [[NSNotificationCenter defaultCenter] postNotificationName:@"hidebannerview" object:nil];
//    [GameState sharedState].bannerView = nil;

    BOOL networkStatus = [[NSUserDefaults standardUserDefaults] boolForKey:CurrentNetworkStatus];
    if(networkStatus==NO)
    {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"internet connection required for this process  " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        return;
    }
    
//    BOOL netwrok_status=[[NSUserDefaults standardUserDefaults] boolForKey:CurrentNetworkStatus];
    
    if (networkStatus) {
        
        [[AppDelegate sharedAppDelegate]showHUDLoadingView:@""];
        
        [Chartboost showInterstitial:CBLocationStartup];
        
         [self performSelector:@selector(chartBoostInterstitial) withObject:self afterDelay:6];
        
    }
   
//      [self gotoFriendsView];
}

-(void)chartBoostInterstitial{
     [[AppDelegate sharedAppDelegate]hideHUDLoadingView];
    if (isInterstitialFail) {
      //  [self sendRequestToFrnds];
         [self gotoFriendsView];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
         [[CCDirector sharedDirector] replaceScene:[MainMenu scene]];
    }
}

-(void) displayFacebookFriendsList{
//    [self gotoFriendsView];
}
-(void) gotoFriendsView{
    
    BOOL facebookConnection = [[NSUserDefaults standardUserDefaults] objectForKey:FacebookConnected];
    
    NSLog(@"facebook status is %d",facebookConnection);
    
    if(facebookConnection==NO)
    {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Please login with Facebook" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        return;
    }

    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.delegate = nil;
    RootViewController *viewCntrler = (RootViewController*)[appDelegate getRootViewController];
    CGRect frame = [UIScreen mainScreen].bounds;
    FriendsViewController *fbFrnds = [[FriendsViewController alloc] initWithHeaderTitle:@"Ask Life"];//
    fbFrnds.view.frame = CGRectMake(0, 0, frame.size.height, 0);;
    
    [UIView animateWithDuration:1 animations:^{
        
        fbFrnds.view.frame = CGRectMake(0, 0, frame.size.height, frame.size.width);
        [viewCntrler presentViewController:fbFrnds animated:YES completion:nil];
        //[viewCntrler.view addSubview:fbFrnds.view];
    }];
}

-(void)moreLivesButtonClicked:(id)sender {
    
    [self.feedbackView removeFromSuperview];
    
    [viewHost1 removeFromSuperview];
    viewHost1 = nil;
    
    
    BOOL networkStatus = [[NSUserDefaults standardUserDefaults] objectForKey:CurrentNetworkStatus];
    if(networkStatus==NO)
    {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"internet connection required for this process  " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        return;
    }

    [self removeChild:menuAskFrnd cleanup:YES];
    [self removeChild:menuMoreLife cleanup:YES];
    [self removeChild:menuBack cleanup:YES];
    [self removeChild:cave cleanup:YES];
    [self removeChild:timeText cleanup:YES];
    [self removeChild:nextLifeImg cleanup:YES];
    [self removeChild:nomorelives cleanup:YES];
    [self removeChild:menu1 cleanup:YES];
    [self removeChild:nextLife cleanup:YES];
   
    Store *obj = [[Store alloc]init];
    [self addChild:obj];
    NSLog(@"More Lives Button Click");
}

#pragma mark
#pragma mark Send REquest to friends method
#pragma mark ==============================================

-(void) sendRequestToFrnds{
       
    NSString * strMessge = @"Hi Friends, Please join me in Cave Run Mowgli and help Mowgli clear the various levels of his jungle, collect coins and save himself from monsters. ";
    NSMutableDictionary *params1 =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   strMessge, @"description",
                                   @"https://itunes.apple.com/app/id903886678", @"link",@"Cave Run Mowgli",@"name",
                                   @"i.imgur.com/1612f7A.png?1",@"picture",
                                   nil];
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    BOOL check = [[NSUserDefaults standardUserDefaults] boolForKey:FacebookConnected];
    
    if (check == YES) {
        
        
        if (FBSession.activeSession.isOpen) {
            
            [appDelegate shareOnFacebookWithParamsForLives:params1 ];
            
            
        }
        else{
            
            [appDelegate openSessionWithLoginUI:1 withParams:params1 withString:nil];
            
        }
    }else{
        
        [appDelegate shareOnFacebookWithParamsForLives:params1];
        
        
    }
}



- (void)didFailToLoadInterstitial:(CBLocation)location
                        withError:(CBLoadError)error{
    
    //    [[AppDelegate sharedAppDelegate]hideHUDLoadingView];
    
    isInterstitialFail=YES;
    
}

- (void)didCloseInterstitial:(CBLocation)location{
    isInterstitialFail=NO;
       [[AppDelegate sharedAppDelegate]hideHUDLoadingView];
   // [self sendRequestToFrnds];
    [self gotoFriendsView];
}

- (void)didDisplayInterstitial:(CBLocation)location{
      [[AppDelegate sharedAppDelegate]hideHUDLoadingView];
    
    isInterstitialFail=NO;
    
    
}

-(void)dealloc {

    [super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
@end
