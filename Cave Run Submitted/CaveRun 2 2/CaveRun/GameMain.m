//
//  HelloWorldLayer.m
//  CaveRun
//
//  Created by tang on 12-6-4.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//


// Import the interfaces
#import "GameMain.h"
#import "Player.h"
#import "Background.h"
#import "Platform.h"
#import "CCAnimate+SequenceLoader.h"
#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "GameState.h"
#import "gameResume.h"
#import "GameOver.h"
#import "cocos2d.h"
#import <Parse/Parse.h>
#import "LifeOver.h"
#import "AdMobFullScreenViewController.h"


// Add to top of file
#import "SimpleAudioEngine.h"

#define ShareToFacebook @"FacebookShare"
// GameMain implementation
CGSize ws;
@implementation GameMain

@synthesize player,bg,pf,stopGame,gameOverSprite,readyGoClip,coinBigClip,readyGoClipAction,readyGoClipIsFinished;
@synthesize disText,coinText,levelText,totalScoreText,runTimeDisText,runTimeCoinText,loopStand,loopCoinBig,disCMC,dis,levelUp,distextcount,score,coinText1,bottomMenu,livesText,lives1,levelText1,level,lostLife,timer,levelfail;
@synthesize Bool,levelBonus,test,connectWithFB,viewHost1;

+(CCScene *) scene
{
    // 'scene' is an autorelease object.
    CCScene *scene = [CCScene node];
    
    // 'layer' is an autorelease object.
    GameMain *layer = [GameMain node];
    
    // add layer as a child to scene
    [scene addChild: layer];
    
    // return the scene
    return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
    NSLog(@"ws.width is %f",ws.width);
    NSLog(@"ws.height is %f",ws.height);
    
    self.transValue = YES;
    rootViewController = (UIViewController*)[(AppDelegate*)[[UIApplication sharedApplication] delegate] getRootViewController];
    /*
    BOOL netwrok_status=[[NSUserDefaults standardUserDefaults] boolForKey:CurrentNetworkStatus];
    
    if (netwrok_status==YES) {
        rootViewController = (UIViewController*)[(AppDelegate*)[[UIApplication sharedApplication] delegate] getRootViewController];
        
        adm = [[AdMobViewController alloc]init];
        if([UIScreen mainScreen].bounds.size.height>500){
//            adm.frame1 = CGRectMake(0, 287,568, 33);
        }else{
//            adm.frame1 = CGRectMake(0, 287,420, 33);
        }
//        adm.frame1 = CGRectMake(0, 287, 480, 33);
//        viewHost1 = adm.view;
        [GameState sharedState].bannerView = adm.view;
      [[[CCDirector sharedDirector] openGLView] addSubview: [GameState sharedState].bannerView];
    }
     */
    //Testing id.
    
    int levelNumbers = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"levelClear"];
    NSLog(@"level numbers is %d",levelNumbers);
   
//    [Chartboost startWithAppId:@"54cb98010d602505e20248d2"
//                  appSignature:@"0657de2558cf69704baa2f2b406013fc4cbfe36c"
//                      delegate:self];
    
    //Live Id.
   
    [Chartboost startWithAppId:@"54859c09c909a6309833a2c4"
                  appSignature:@"6b5efdfe6e15db9fd3948e8e7d21c23a1ad59efc"
                      delegate:self];

  
    
    if( (self=[super init])) {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"decal.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"clips.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"readyGo.plist"];
        
        ws=[[CCDirector sharedDirector]winSize];
        //create game over sprite
        self.readyGoClipIsFinished=NO;
        self.gameOverSprite=[CCSprite spriteWithFile:@"GameOver.png"];
        self.gameOverSprite.visible=NO;
        
        self.disText=[CCLabelTTF labelWithString:@"0" fontName:@"JFRocSol.TTF" fontSize:20];
        [self.gameOverSprite addChild:self.disText];
        self.disText.anchorPoint=ccp(0,0);
       self.disText.position=ccp(340+20,280);
//          self.disText.position=ccp(340+20,ws.height/2+115);

        
        //create text to show total coins collected
        self.coinText=[CCLabelTTF labelWithString:@"0" fontName:@"JFRocSol.TTF" fontSize:20];
        [self.gameOverSprite addChild:self.coinText];
        self.coinText.anchorPoint=ccp(0,0);
     self.coinText.position=ccp(340+20,290);
//        self.coinText.position=ccp(340+20,ws.height/2+115);
        
        //level text
        self.levelText=[CCLabelTTF labelWithString:@"0" fontName:@"JFRocSol.TTF" fontSize:20];
        [self.gameOverSprite addChild:self.levelText];
        self.levelText.anchorPoint=ccp(0,0);
       self.levelText.position=ccp(340+20,225);
//         self.levelText.position=ccp(340+20,ws.height/2+115);
        
        //SCORE TEXT
        self.totalScoreText=[CCLabelTTF labelWithString:@"0" fontName:@"JFRocSol.TTF" fontSize:28];
        [self.gameOverSprite addChild:self.totalScoreText];
        // self.totalScoreText.anchorPoint=ccp(0,0);
      self.totalScoreText.position=ccp(300+20,150);
//        self.totalScoreText.position=ccp(300+20,ws.height/2+115);
        self.totalScoreText.color=ccc3(255,180,0);
        
        
        // At end of applicationDidFinishLaunching, replace last line with the following 2 lines:
        //[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"ouch.wav" loop:YES];
        
        self.gameOverSprite.anchorPoint=ccp(0.5,0.5);
        self.gameOverSprite.position=ccp(ws.width/2,ws.height/2);
        
        
        self.isTouchEnabled = YES;
        
        self.stopGame=NO;
        
        //background
        
        self.bg=[ Background node];
        
        [self.bg setColorWithRBG];
        
        [self addChild:bg];
        
        
        
        self.pf=[Platform node];
        self.pf.gm=self;
        [self addChild:self.pf];
        
        self.player=[Player node];
        
        self.player.platformAcc=self.pf;
        
        self.player.position=ccp([Player initX],[self.pf getSafeY]);
        
        
        self.player.gm=self;
        
        
        //play idle anination
        
        [self.player gotoAndStop:@"stand" val:0];
        
        self.pf.player=self.player;
        
        [self addChild:self.player];
        
        
        
        [self addChild:self.gameOverSprite];
        
        
        //reday go sequence animation
        
        self.readyGoClipAction=[CCSequence actions:[CCAnimate actionWithSpriteSequence:@"readyGo%04d.png" numFrames:55 delay:0.03f restoreOriginalFrame:NO],
                                [CCCallFunc actionWithTarget:self selector:@selector(startGame)],nil];
        
        self.readyGoClip=[CCSprite node];
        
        CGSize winSize = [[CCDirector sharedDirector]winSize];
        
        self.readyGoClip.position=ccp(winSize.width/2,winSize.height/2);
        
        [self addChild:self.readyGoClip];
        
        self.loopCoinBig=[CCRepeatForever actionWithAction:[CCAnimate actionWithSpriteSequence:@"coin_big%04d.png" numFrames:36 delay:0.05f restoreOriginalFrame:NO]];
        
        self.disCMC=[CCSprite node];
        
        [self addChild:self.disCMC];
        
        self.coinBigClip=[CCSprite node];
        self.coinBigClip.anchorPoint=ccp(0,0);
        self.coinBigClip.position=ccp(ws.width-30,285);
        [self.disCMC addChild:self.coinBigClip];
        
        [self.coinBigClip runAction:self.loopCoinBig];
        
        
        self.runTimeCoinText=[CCLabelTTF labelWithString:@"0" fontName:@"JFRocSol.TTF" fontSize:22];
        
        self.runTimeCoinText.anchorPoint=ccp(1,0);
        
       self.runTimeCoinText.position=ccp(ws.width-(480-446),290);
//         self.runTimeCoinText.position=ccp(ws.width-(480-446),ws.height/2+115);
        
        [self.disCMC addChild:self.runTimeCoinText];
        
        int i = [GameState sharedState].levelNumber;
        NSString *myString = [NSString stringWithFormat:@"%d",i];
        // [GameState sharedState].levelNumber;
        self.levelText1=[CCLabelTTF labelWithString:myString fontName:@"JFRocSol.TTF" fontSize:22];
        
        self.levelText1.anchorPoint=ccp(1,0);
        
        self.levelText1.position=ccp(300, 290);
//        self.levelText1.position=ccp(300, ws.height/2+115);

        
        [self.disCMC addChild:self.levelText1];
        
        
        NSInteger myLife=[[NSUserDefaults standardUserDefaults] integerForKey:@"live"];
        
        
        NSString *myLife1 = [NSString stringWithFormat:@"%d",(int)myLife];
        
        self.livesText=[CCLabelTTF labelWithString:myLife1 fontName:@"JFRocSol.TTF" fontSize:22];
        
        self.livesText.anchorPoint=ccp(1, 0);
        
       self.livesText.position=ccp(130,290);
//         self.livesText.position=ccp(130,ws.height/2+115);
        [self.disCMC addChild:self.livesText];
        
        self.lives1=[CCLabelTTF labelWithString:@"Lives " fontName:@"JFRocSol.TTF" fontSize:22];
        self.lives1.anchorPoint=ccp(1, 0);
        
        self.lives1.position=ccp(100,290);
//          self.lives1.position=ccp(100,ws.height/2+115);
        [self.disCMC addChild:self.lives1];
        
        if(i<10)
        {
            self.level=[CCLabelTTF labelWithString:@"Level" fontName:@"JFRocSol.TTF" fontSize:22];
            self.level.anchorPoint=ccp(1, 0);
        }
        else
        {
            self.level=[CCLabelTTF labelWithString:@"Level " fontName:@"JFRocSol.TTF" fontSize:22];
            self.level.anchorPoint=ccp(1, 0);
            
        }
        self.level.position=ccp(270,290);
        [self.disCMC addChild:self.level];
        
        
        
        self.lostLife=[CCSprite spriteWithFile:@"lost life.png"];
        self.lostLife.anchorPoint=ccp(0,0);
        self.lostLife.position=ccp(100, 100);
        
        
        self.lostLife.visible=NO;
        [self addChild:self.lostLife];
        
        
        //added now
        
        CCMenuItemImage *pauseItem = [CCMenuItemImage  itemFromNormalImage:@"pause.png" selectedImage:@"pause.png" target:self selector:@selector(pauseAction:)];
        
        pause=[CCMenu menuWithItems:pauseItem, nil];
     
        if([UIScreen mainScreen].bounds.size.height>500){
            pause.position=ccp(25, 80);//530
        }else{
            
            pause.position=ccp(30, 80);//450,80
        }

//        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
//      // pause.position=ccp(450, 80);//ipad
////             if([UIScreen mainScreen].bounds.size.width>660) {
//        pause.position=ccp(30,80);//iphone 6
////             }
//        }
        /*
        if(ws.width>500){
           pause.position = ccp(ws.width-70, ws.height-240);
        }else{
            pause.position=ccp(450, 80);
        }
        */
        [self addChild:pause];
        
        
        // sound toggle on/off
        
        CCMenuItem *soundOnItem = [CCMenuItemImage itemFromNormalImage:@"musicOn2.png"
                                                         selectedImage:@"musicOn2.png"
                                                                target:nil
                                                              selector:nil];
        
        
        CCMenuItem *soundOffItem = [CCMenuItemImage itemFromNormalImage:@"musicOff2.png"
                                                          selectedImage:@"musicOff2.png"
                                                                 target:nil
                                                               selector:nil];
        
        self.soundToggleItem = [CCMenuItemToggle itemWithTarget:self
                                                       selector:@selector(soundButtonTapped:)
                                                          items:soundOnItem, soundOffItem, nil];
        
        
        if ((self.soundToggleItem.selectedIndex==0)) {
            NSLog(@"Sound button tapped!");
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"bgm.mp3" loop:YES];
        }
        
        
        
        bottomMenu = [CCMenu menuWithItems:self.soundToggleItem, nil];
        NSLog(@"[UIScreen mainScreen].bounds.size.height is %f",[UIScreen mainScreen].bounds.size.height);
        
        
        if([UIScreen mainScreen].bounds.size.height>500){
            self.soundToggleItem.position = ccp(-260,170);//250,170
        }else{
            self.soundToggleItem.position = ccp(-210,120);//210,120
            
        }
        
        if ([UIScreen mainScreen].bounds.size.width>[UIScreen mainScreen].bounds.size.height) {
             self.soundToggleItem.position = ccp(-250,-110);
        }
     
//        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
////             if([UIScreen mainScreen].bounds.size.width>660) {
//            self.soundToggleItem.position = ccp(-250,-110);
////             }
//        }

       /*

        if (ws.width>500) {
             self.soundToggleItem.position = ccp(210,ws.width-620);

        }else{
            self.soundToggleItem.position = ccp(210, 120);
        }
        */
        [self addChild: bottomMenu z:2];
        
        //timer
        //----------------------------Label for timer--------------
        
        int levelc = [GameState sharedState].levelNumber;
        if(levelc==1)
        {
            limit=360;
        }
        else{
            limit=(360-(30*abs((levelc%10)-1)));
        }
        sec=limit;
        
        limit_coin=[NSString stringWithFormat:@"%i",limit];
        self.timer=[CCLabelTTF labelWithString:limit_coin fontName:@"JFRocSol.TTF" fontSize:22];
        
        self.timer.anchorPoint=ccp(1,0);
        
        self.timer.position=ccp(ws.width-(540-446),290);
        
        [self.disCMC addChild:self.timer];
        //        self.lblTime=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"Time :%i",limitTime] fntFile:@"font_30.fnt"];
        self.lblTime = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Time :%i",limitTime] fontName:@"JFRocSol.TTF" fontSize:20 ];
        //       self.lblTime = [CCLabelTTF labelWithString:@"play!" fontName:@"JFRocSol.TTF" fontSize:40];
        
        limitTime=30;
        
        theTimer=limitTime;
        self.lblTime.position=ccp(80, 20);
        //-------------image for level up and level fail---------------------------
        self.levelUp=[CCSprite spriteWithFile:@"wonderful.png"];
        if([UIScreen mainScreen].bounds.size.height<500)
        {
            self.levelUp.position=ccp(ws.width/2-280,0);
        }
        else{
            self.levelUp.position=ccp(0,0);
        }
        self.levelUp.anchorPoint=ccp(0,0);
        
        //self.flash.scale=10;
        
        self.levelUp.visible=NO;
        [self addChild:self.levelUp];
        self.levelfail=[CCSprite spriteWithFile:@"levelfailed.png"];
        if([UIScreen mainScreen].bounds.size.height<500)
        {
            self.levelfail.position=ccp(ws.width/2-300,0);
        }
        else{
            self.levelfail.position=ccp(0,0);
        }
        self.levelfail.anchorPoint=ccp(0,0);
        
        self.levelfail.visible=NO;
        [self addChild:self.levelfail];
        
        
    }
    return self;
}

#pragma mark
#pragma mark Get date
#pragma mark ============================
-(void)getDate {
    
    NSString *strDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"strtdate"];
    
    if (![strDate isEqualToString:@"0"]) {
        
        NSDate *currentDate = [NSDate date];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
        
        NSString *strCurrentDate = [formatter stringFromDate:currentDate];
        
        currentDate=[formatter dateFromString:strCurrentDate];
        
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc]init];
        [formatter1 setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
        
        NSDate *oldDate = [formatter1 dateFromString:strDate];
        
        int units = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSSecondCalendarUnit;
        NSCalendar *gregorianCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        
        NSDateComponents *components = [gregorianCal components:units fromDate:oldDate  toDate:currentDate  options:0];
        
        int months = [components month];
        int days = [components day];
        int hours = [components hour];
        int minutes = [components minute];
        int seconds = [components second];
        
        NSLog(@"%d months , %d days, %d hours, %d min %d sec", months, days, hours, minutes, seconds);
        
        [self getExtraLife:days andHour:hours andMin:minutes andSec:seconds];
    }
    
}

-(void)getExtraLife :(int)aday andHour:(int)ahour andMin:(int)amin andSec:(int)asec {
    
    int hoursInMin = ahour*60;
    hoursInMin=hoursInMin+amin;
    
    int totalTime = amin*60+asec;
    
    int life = (int)[userDefault integerForKey:@"live"];
    int rem =amin%30;
    
    int remTimeforLife = rem*60+asec;
    
    remTimeforLife=1800-remTimeforLife;
    
    
    if (aday>0 || hoursInMin>=150) {
        
        [userDefault setInteger:5 forKey:@"live"];
        [userDefault setObject:@"0" forKey:@"strtdate"];
    }
    else if(totalTime>=1800){
        int extralife =amin/30;
        
        life=life+extralife;
        
        if(life>=5){
            
            [userDefault setInteger:5 forKey:@"live"];
            [userDefault synchronize];
            [userDefault setObject:@"0" forKey:@"strtdate"];
            //self.timeText.visible = NO;
            //[self.lblNextLifeTime setString:@"Full of life"];
        }
        else{
            [userDefault setInteger:life forKey:@"live"];
            [userDefault synchronize];
            // [self updateTime:remTimeforLife];
            [[NSUserDefaults standardUserDefaults]setInteger:remTimeforLife forKey:@"remTime"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    }
    else{
        [[NSUserDefaults standardUserDefaults]setInteger:remTimeforLife forKey:@"remTime"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }
    
    
}

-(void) showLifeOver {
    
    if(!self.lifeOverLayer){
        self.lifeOverLayer=[[LifeOver alloc]init];
        [self addChild:self.lifeOverLayer];
    }
    else{
        ((LifeOver*)self.lifeOverLayer).visible=YES;
    }
}

#pragma mark
#pragma mark Update fields
#pragma mark =============================
-(void)updatelevelBonus:(int)cnt{
    
    self.levelBonus=cnt;
}



//timer action

-(void)updateTimeDisplay{
    theTimer--;
    //NSLog(@"time is======%d",theTimer);
    [self.lblTime setString:[NSString stringWithFormat:@"Time :%i",theTimer]];
    if (theTimer==0) {
        
        theTimer=30;
        
        [self unschedule:@selector(updateTimeDisplay)];
        [self showGameOver];
    }
}

-(void) soundButtonTapped: (id) sender
{
    if ((self.soundToggleItem.selectedIndex==0)) {
        NSLog(@"Sound button tapped!");
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"bgm.mp3" loop:YES];
        
        
    }else{
        [[SimpleAudioEngine sharedEngine]stopBackgroundMusic];
        
    }
    
}


//start run action - readyGoClipAction after replaceScene finished

-(void)pauseAction:(id)sender{
    
//    [viewHost1 removeFromSuperview];
    
    
    self.transValue = NO;
    gameResume *obj = [[[gameResume alloc] init] autorelease];
    [[CCDirector sharedDirector] pushScene:obj];
    
}

-(void) onEnterTransitionDidFinish {
    
    self.readyGoClipIsFinished=NO;
    [super onEnterTransitionDidFinish];
    
    if (self.transValue==YES) {
        [self.readyGoClip runAction:self.readyGoClipAction];
        
    }
    else{
        self.readyGoClipIsFinished=YES;
    }
    
    [self schedule:@selector(updateTime) interval:1];
}


//start run action - readyGoClipAction after replaceScene finished


//update runTimeCoinText text
-(void) updateScore{
    
    [self.runTimeCoinText setString:[NSString stringWithFormat:@"%i",self.pf.coinsNum]];
    //NSLog(@"coin text==== %d",self.pf.coinsNum);
    
}

-(void) updateLives:(int)cnt{
    
    NSInteger myLife=[[NSUserDefaults standardUserDefaults] integerForKey:@"live"];
    [self.livesText setString:[NSString stringWithFormat:@"%i",myLife]];
    //self.pf.lives...
    
    if(myLife==0)
    {
        NSDate* now = [NSDate date];
        NSDateFormatter *formate = [[NSDateFormatter alloc] init];
        [formate setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
        NSString *dateStr = [formate stringFromDate:now];
        [[NSUserDefaults standardUserDefaults] setObject:dateStr forKey:@"strtdate"];
        
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }
    
}

-(void)updateLevel:(int)cnt{
    
    [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"update"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self.levelText1 setString:[NSString stringWithFormat:@"%i",cnt]];
}

//start game
-(void) startGame{
    self.readyGoClipIsFinished=YES;
    self.dis=0;
    self.disCMC.visible=YES;
    self.player.state=0;
    self.pf.lives=3;
    [self.player gotoAndStop:@"run" val:0];
    [self schedule:@selector(loop:)];
}

#pragma mark
#pragma mark Show Game over
#pragma mark =============================
//show game over image and update some texts..
-(void) showGameOver{
//    BOOL netwrok_status=[[NSUserDefaults standardUserDefaults] boolForKey:CurrentNetworkStatus];
//    
//    
//    if (netwrok_status == YES) {
//        AdMobFullScreenViewController *adf= [[AdMobFullScreenViewController alloc]init];
//    }
    BOOL netwrok_status=[[NSUserDefaults standardUserDefaults] boolForKey:CurrentNetworkStatus];

    [self setIsTouchEnabled:NO];
    [self removeChild:self.player cleanup:YES];
    self.gameOverScreen.visible=YES;
    self.disCMC.visible=NO;
    //added now
    [pause setVisible:NO];
    
    [bottomMenu setVisible:NO];
    
    coinText1=self.runTimeCoinText.string;
    
    
    distextcount=(int) (self.dis*0.01);
    
    int curentLevel = [GameState sharedState].levelNumber;
    
    if ([GameState sharedState].next) {
        score=self.pf.coinsNum*30+sec*10+curentLevel*500;
        if (netwrok_status == YES) {
           // AdMobFullScreenViewController *adf= [[AdMobFullScreenViewController alloc]init];
        }
    }else{
         score=self.pf.coinsNum*30+curentLevel*500;
    }
    
    NSLog(@"self.dis is..... %d",score);
    
    // prev delay 3.0
    double delayInSeconds = 2.0;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        //code to be executed on the main queue after delay
        GameOverScene *obj = [GameOverScene alloc];
        obj.coinText1=self.coinText1;
        obj.distextcount = self.distextcount;
        obj.dis = (self.dis*0.01);
        obj.scoree = self.score;
        obj.levelBonus=self.levelBonus;
        [obj init];
        
        [self addChild:obj];
        
        self.disCMC.visible=NO;
        
        [self unschedule:@selector(loop:)];
    });
    
}
#pragma mark
#pragma mark Parse code
#pragma mark =============================

-(void) saveScoreToParse:(NSInteger)score1 forLevel:(NSInteger)level1{
    
    NSString *fbID = [[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID];
    
    if (fbID) {
        PFObject *object = [PFObject objectWithClassName:ParseScoreTableName];
        object[@"PlayerFacebookID"] = fbID;
        object[@"Level"] = [NSString stringWithFormat:@"%d",level1];
        object[@"Score"] = [NSNumber numberWithInteger:score1];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [object saveEventually:^(BOOL succeed, NSError *error){
                
                if (succeed) {
                    NSLog(@"Save to Parse");
                    
                    
                    [self retriveFriendsScore:level1 andScore:score1];
                    
                }
                if (error) {
                    NSLog(@"Error to Save == %@",error.localizedDescription);
                }
            }];
        });
    }
    else{
        [self retriveFriendsScore:level1 andScore:score1];
    }
}

//retrieve facebook friends....

-(void) retriveFriendsScore:(NSInteger)level1 andScore:(NSInteger)score1{
    
    NSMutableArray *mutArr = [[NSMutableArray alloc]init];
    
    mutArr =[[NSUserDefaults standardUserDefaults] objectForKey:FacebookGameFrindes];
    
    
    NSMutableArray *arrMutableCopy = [mutArr mutableCopy];
    
    NSString *strUserFbId = [[NSUserDefaults standardUserDefaults]objectForKey:ConnectedFacebookUserID];
    NSNumber *numFbIdUser =  [NSNumber numberWithLongLong:[strUserFbId longLongValue]];
    
    if (![arrMutableCopy containsObject:strUserFbId]) {
        [arrMutableCopy addObject:strUserFbId];
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        self.currentLevel = level1;
        
        NSString *strLevel = [NSString stringWithFormat:@"%d",level1];
        
        
        PFQuery *query = [PFQuery queryWithClassName:ParseScoreTableName];
        
        [query whereKey:@"Level" equalTo:strLevel];
        
        [query whereKey:@"PlayerFacebookID" containedIn:arrMutableCopy];
        
        [query orderByDescending:@"Score"];
        NSLog(@"query count %d",[query countObjects]);
        NSArray *ary = [query findObjects];
        
        if (ary.count<1) {
            isNewHighScore = YES;
            NSLog(@"New High Score");
            NSLog(@"Not contain any Object");
            return;
        }
        
        else{
            self.mutArrScores = [[NSMutableArray alloc] init];
            
            isNewHighScore = NO;
            for (int i =0; i<ary.count; i++) {
                
                PFObject *obj = [ary objectAtIndex:i];
                NSLog(@"PFOBJEct -==- %@",obj);
                NSNumber *scoreOld = obj[@"Score"];
                NSNumber *fbId = obj[@"PlayerFacebookID"];
                //            NSLog(@"Score Old -==- %@",scoreOld);
                
                int storeScore = [scoreOld intValue];
                
                if (score<storeScore) {
                    [self.mutArrScores addObject:scoreOld];
                }
                else{
                    
                    if (self.mutArrScores.count==0) {
                        isNewHighScore = YES;
                        NSLog(@"You create new high Score.");
                    }
                    else{
                        
                        if ([fbId longLongValue]== [numFbIdUser longLongValue]) {
                            
                        }
                        else{
                            NSString *urlString = [NSString   stringWithFormat:@"https://graph.facebook.com/%@",fbId];
                            NSLog(@"url String=-=- %@",urlString);
                            
                            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
                            [request setURL:[NSURL URLWithString:urlString]];
                            [request setHTTPMethod:@"GET"];
                            [request setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
                            NSURLResponse* response;
                            NSError* error = nil;
                            
                            //Capturing server response
                            NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
                            
                            NSString *str1 = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
                            NSLog(@"Data =-= %@",str1);
                            if (str1) {
                                
                                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:0 error:NULL];
                                self.lblFbFirstName = [dict objectForKey:@"first_name"];
                                
                                self.lblFbLastName = [dict objectForKey:@"last_name"];
                                
                                //  [activityInd stopAnimating];
                            }
                            return;
                        }
                    }
                }
            }
            secondHighScore = [ary objectAtIndex:0];
        }
    });
}
//}

//the main loop

-(void) loop:(ccTime) delta{
    if(self.stopGame){
        return;
    }
    if(self.player.state==-1){
        
        
    }
    else {
        [self.player update:delta];
        
        [self moveStage:self.player.speed delta:delta];
        
        self.dis+=(self.player.speed*0.05);
        
    }
    
}

//move background and Platform

-(void) moveStage:(float)sp delta:(ccTime)de{
    [self.bg moveWithSpeed:sp/60/7];
//    NSLog(@"sp = %f",sp);
    if ((self.soundToggleItem.selectedIndex==0)) {
        [self.pf move:sp/60 val:1] ;
    }else{
        [self.pf move:sp/60 val:0] ;
    }
}
#pragma mark
#pragma mark Touch events
#pragma mark =============================

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.test==1) {
        
    }
    
    if(self.player.state==-1){
        return;
        
    }
    if(self.player.state==0&&self.readyGoClipIsFinished){
        [self.player jump];
    }
    self.transValue = YES;
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if ((self.player.state=1)) {
        
        [self.player gotoAndStop:@"run" val:1];
        
        
    }
    
    [self removeChild:gameOverSprite cleanup:YES];
    self.gameOverScreen.visible=NO;
    
    if(self.stopGame){
        self.gameOverSprite.visible=NO;
        [self newGame];
        
        [self onEnterTransitionDidFinish];
        
        return;
    }
    
    if(self.stopGame==NO){
        
        if(self.player.state==1){
            self.player.state=2;
            
            if ((self.soundToggleItem.selectedIndex==0)){
                [self.player gotoAndStop:@"fall" val:1];
            }else{
                [self.player gotoAndStop:@"fall" val:0];
            }
        }
        
    }
    
}
//ready for a new game
#pragma mark
#pragma mark New Game
#pragma mark =============================
-(void) newGame{
    [self.pf removeAll];
    
    self.stopGame=NO;
    [self.shareButtons setVisible:NO];
    
    [self.pf createForNewGame];
    
    [self.player readyForNewGame];
    
    [self.runTimeCoinText setString:@"0"];
    
    self.player.position=ccp(self.player.position.x,self.pf.getSafeY);
    
}

-(void) newGame1{
    
    
    self.stopGame=NO;
    [self.shareButtons setVisible:NO];
    
    [self.pf createForNewGame];
    
    [self.player readyForNewGame];
    
    self.player.position=ccp(self.player.position.x,self.pf.getSafeY);
    [self schedule:@selector(loop:)];
    
    
}

// on "dealloc" you need to release all your retained objects
#pragma mark
#pragma mark Timer for collecting coin
#pragma mark =============================
-(void)updateTime
{
    int level1 = [GameState sharedState].levelNumber,coins;
    if(level1<=10)
    {
        coins=25;//25
    }
    else if(level1>=11&&level1<=20)
    {
        coins=35;//35
    }
    else if(level1>=21&&level1<=30)
    {
        coins=40;//40
    }
    else if(level1>=31&&level1<=40)
    {
        coins=45;//45
    }
    else if(level1>=41&&level1<=50)
    {
        coins=50;//50
    }
    else{
        NSLog(@"Unknown Level");
    }
    //--------------code to unschedule------------
    
    if(level1<=10&&self.pf.coinsNum==25)//25
    {
        remaining_time=sec;
        [self unschedule:@selector(updateTime)];
    }
    if(level1>=11&&level1<=20&&self.pf.coinsNum==35)//35
    {
        remaining_time=sec;
        [self unschedule:@selector(updateTime)];
    }
    if(level1>=21&&level1<=30&&self.pf.coinsNum==40)//40
    {
        remaining_time=sec;
        [self unschedule:@selector(updateTime)];
    }
    if(level1>=31&&level1<=40&&self.pf.coinsNum==45)//45
    {
        remaining_time=sec;
        [self unschedule:@selector(updateTime)];
    }
    if(level1>=41&&level1<=50&&self.pf.coinsNum==50)//50
    {
        remaining_time=sec;
        [self unschedule:@selector(updateTime)];
    }
    
    
    if(sec==0&&self.pf.coinsNum<coins)
    {
        
        sec=0;
        
        self.levelfail.visible=YES;
        self.levelfail.opacity=255;
        
        id delay = [CCDelayTime actionWithDuration:0.5];
        id fadeAlphaTo0=[CCFadeTo actionWithDuration:1 opacity:0];
        // id func=[CCCallFunc actionWithTarget:self selector:@selector(hideLevelUp)];
        id action = [CCSequence actions:delay,fadeAlphaTo0,nil];
        [self.levelfail runAction:action];
        [self.bg setColorWithRBG];
        self.stopGame=YES;
        
        NSInteger mylife=[[NSUserDefaults standardUserDefaults]integerForKey:@"live"];
        mylife=mylife-1;
        if(mylife<=0)
        {
            [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"live"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        else{
            [[NSUserDefaults standardUserDefaults]setInteger:mylife forKey:@"live"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        NSString * startdate=[[NSUserDefaults standardUserDefaults]objectForKey:@"strtdate"];
        
        if (mylife==0&&[startdate isEqualToString:@"0"]) {
            
            NSDate* now = [NSDate date];
            NSDateFormatter *formate = [[NSDateFormatter alloc] init];
            [formate setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
            NSString *dateStr = [formate stringFromDate:now];
            [[NSUserDefaults standardUserDefaults] setObject:dateStr forKey:@"strtdate"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        [self updateLives:(int)mylife];
        if(mylife<=0)
        {
            self.stopGame=YES;
            [self showGameOver];
            // [self getDate];
        }else{
            
            [self.bg setColorWithRBG];
            self.stopGame=YES;
            
            [self removeChild:self.player cleanup:YES];
            [self unschedule:@selector(updateTime)];
            [self showGameOver];
        }
        return;
        
    }
    
    sec=sec-1;
    [self.timer setString:[NSString stringWithFormat:@"%d",sec]];
    
}

- (void) dealloc
{
    // in case you have something to dealloc, do it in this method
    // in this particular example nothing needs to be released.
    // cocos2d will automatically release all the children (Label)
    
    // don't forget to call "super dealloc"
    
    [self.pf release];
    
    [self.player release];
    [self.readyGoClip release];
    [self.readyGoClipAction release];
    [super dealloc];
}
@end
