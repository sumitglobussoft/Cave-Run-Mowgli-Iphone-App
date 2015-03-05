//
//  Player.m
//  CaveRun
//
//  Created by tang on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Player.h"
#import "CCAnimate+SequenceLoader.h"
#import "Platform.h"
#import "GameMain.h"
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "GameState.h"
#import "LifeOver.h"
#import "LevelSelectionScene.h"

//#import "CDAudioManager.h"
@implementation Player
@synthesize mc,gm;
@synthesize loopStand, loopJump,loopRun,loopFall,loopFire,oneTimeHit,oneTimeIce;;
@synthesize state,_playerJump,_playerJumpPower,lives1,flag,pcheck,flag1;
@synthesize initSpeed,currentSpeed,speed,maxSpeed,currentLevel,isDead,soundValue1,man,platformAcc,minY,acceleration;

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
      
        lives = [NSUserDefaults standardUserDefaults];
     
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey: @"downloaded"];
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notification) name:@"adpost" object:nil];
        
        //testing id.
        
//       
//        [Chartboost startWithAppId:@"54cb98010d602505e20248d2"
//                      appSignature:@"0657de2558cf69704baa2f2b406013fc4cbfe36c"
//                          delegate:self];
        //Live Id.
   
        [Chartboost startWithAppId:@"54859c09c909a6309833a2c4"
                      appSignature:@"6b5efdfe6e15db9fd3948e8e7d21c23a1ad59efc"
                          delegate:self];
      
        BOOL netwrok_status=[[NSUserDefaults standardUserDefaults] boolForKey:CurrentNetworkStatus];
        if (netwrok_status==YES) {
            [Chartboost cacheRewardedVideo:CBLocationStartup];
        }
        isChartBoostFail = NO;
        
        self.isDead=NO;
        // self.initSpeed=200.0f;
        
#pragma mark---- set speed of game. 
        
        self.maxSpeed=400.0f;
        
        if ([GameState sharedState].levelNumber<=10) {
            self.initSpeed=100.0f;
             self.maxSpeed=150.0f;
        }
        
        if ([GameState sharedState].levelNumber>10 && [GameState sharedState].levelNumber <=20) {
            self.initSpeed=120.0f;
            self.maxSpeed=180.0f;
        }
        
        if ([GameState sharedState].levelNumber>20 && [GameState sharedState].levelNumber <=30) {
            self.initSpeed=180.0f;
            self.maxSpeed=220.0f;
        }
        
        if ([GameState sharedState].levelNumber>30 && [GameState sharedState].levelNumber <=40) {
            self.initSpeed=200.0f;
            self.maxSpeed=250.0f;
        }
        
        
        if ([GameState sharedState].levelNumber>40 && [GameState sharedState].levelNumber <=50) {
            self.initSpeed=300.0f;
            self.maxSpeed=400.0f;

        }
        // self.maxSpeed=400.0f;
        pcheck=7;
        self.speed=self.initSpeed;
        self.state=0;
        self._playerJump=0;
        self._playerJumpPower=11;
        
        self.minY=50;
        
        self.currentLevel=1;
        
       
        
        self.acceleration=1;
        
        
        
        self.loopStand=[CCRepeatForever actionWithAction:[CCAnimate actionWithSpriteSequence:@"idle%04d.png"
                                                    
                                                                             numFrames:16 
                                                                             delay:0.03f 
                                                                             restoreOriginalFrame:NO]];
        

        self.loopJump= [CCAnimate actionWithSpriteSequence:@"jump%04d.png"     
                        
                                                 numFrames:8
                                                 delay:0.05f 
                                                 restoreOriginalFrame:NO];
        
        
        self.loopRun=[CCRepeatForever actionWithAction:[CCAnimate actionWithSpriteSequence:@"run%04d.png"
                                                   
                                                                            numFrames:36 
                                                                            delay:0.014f 
                                                                            restoreOriginalFrame:NO]];
        
        
        
        self.loopFall=[CCRepeatForever actionWithAction:[CCSequence actions:[CCAnimate actionWithSpriteSequence:@"fall%04d.png"
                                                        
                                                                                 numFrames:6 
                                                                                     delay:0.03f 
                                                                       restoreOriginalFrame:NO],
                       [CCCallFunc actionWithTarget:self selector:@selector(callSnd)],nil]];
        
        
        self.loopFire=[CCRepeatForever actionWithAction:[CCAnimate actionWithSpriteSequence:@"hitFire%04d.png"
                                                         
                                                                                  numFrames:7 
                                                                                      delay:0.05f 
                                                                       restoreOriginalFrame:NO]];
        
        
        self.oneTimeHit=[CCSequence actions:[CCAnimate actionWithSpriteSequence:@"hit%04d.png"
                                                                             
                                                                                                      numFrames:24 
                                                                                                          delay:0.03f 
                                                                                           restoreOriginalFrame:NO],
                                                         [CCCallFunc actionWithTarget:self selector:@selector(goStand)],nil];
        
        self.oneTimeIce=[CCSequence actions:[CCAnimate actionWithSpriteSequence:@"hitIce%04d.png"
                                             
                                                                      numFrames:16 
                                                                          delay:0.03f 
                                                           restoreOriginalFrame:NO],
                         [CCCallFunc actionWithTarget:self selector:@selector(goStand)],nil];


        self.mc=[CCSprite node];
       
        self.mc.anchorPoint=ccp(0.5,0);
        
        [self addChild:self.mc];
        
        
    }
	return self;
}

//0:run
//1:jump
//2:fall
//-1:stand
//-2:hit
//-3:fire
//-4:ice
-(void) callSnd{
    if (self.soundValue1==1) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"fall.wav" pitch:0.5 pan:0 gain:1];
    }
}


//selector for hits
-(void) goStand{
    
    if(self.isDead){
        [self gotoAndStop:@"fall" val:0];
        self.state=2;
    }
    else {
        [self gotoAndStop:@"run" val:0];
        self.state=0;
    }
    
}


-(void)done{
    
    self.mc.opacity=255;
}

#pragma mark
#pragma mark Player Actions.
#pragma mark =============================

-(void) gotoAndStop:(NSString *) frame val:(int)soundValue{
    self.soundValue1=soundValue;
  //  NSLog(@"sound value in stop animatins=== %d",self.soundValue1);
    
    
    if([frame isEqualToString: @"stand"]){
         
        [self.mc stopAllActions];
        
        
        [self.mc runAction:self.loopStand];
    }
    else if([frame isEqualToString: @"run"]){
         
         [self.mc stopAllActions];
               [self.mc runAction:self.loopRun];
        
    }
    else if([frame isEqualToString: @"jump"]){
        
        //[self.mc setOpacity:1];
        
         [self.mc stopAllActions];
        
        [self.mc runAction:self.loopJump];
    }
    
    else if([frame isEqualToString: @"fall"]){
        [self.mc stopAllActions];
        //id ccf=[CCCallFunc actionWithTarget:self selector:@selector(callSnd)];
        self.mc.opacity = 255;
        [self.mc runAction:self.loopFall ];
       
    }
    
    else if([frame isEqualToString: @"fire"]){
        [self.mc stopAllActions];
        
        [self.mc runAction:self.loopFire]; 
        
    }
    
    else if([frame isEqualToString: @"hit"]){
        [self.mc stopAllActions];
        [self.mc runAction:self.oneTimeHit];
    }
    
    else if([frame isEqualToString: @"ice"]){
        [self.mc stopAllActions];
        [self.mc runAction:self.oneTimeIce];
    }
    else if([frame isEqualToString:@"fade"]){
                
        //working
        CCFadeIn *fadeIn = [CCFadeIn actionWithDuration:1.0 ];
        CCFadeOut *fadeOut = [CCFadeOut actionWithDuration:1.0 ];
       id action= [CCCallFunc actionWithTarget:self selector:@selector(done)];
        
        CCSequence *pulseSequence = [CCSequence actions:fadeOut,fadeIn,action,nil];
    
        [self.mc runAction:pulseSequence];
        
    }
    else if ([frame isEqualToString:@"stop"]){
        [self.mc stopAllActions];
       // GameMain *gameMain=(GameMain*)self.gm;
       // gameMain.stopGame=YES;
        
       //  [self.readyGoClip runAction:self.readyGoClipAction];
        
        
    }
    
}


-(void)hideLevelUp{
    
}
//update state and position

-(void) update:(ccTime) de{
      
    if(!flag){
        
        float de60=1;//de*60;
        
        int safeY=[self.platformAcc getSafeY];
        
        
        if(self.speed<self.maxSpeed&&!self.isDead){
            self.speed+=self.acceleration;
           // NSLog(@"self.speed %f",self.speed);
        }
        
        if(self.state==-2&&self.speed>0&&!self.isDead){
            self.speed-=self.acceleration*5;
        }
        
        
        
        if((self.state==0||self.state==-2||self.state==-4)&&safeY==-300){
            
            self._playerJump=0;
            self.state=2;
            [self gotoAndStop:@"fall" val:0];
            
            CCLOG(@"------------fall  ,when state is 0 (idle) -----------------");
        }
        
        if(self.state==1||self.state==2||self.state==-3){
            
            
            if(self.state==2&&self._playerJump>0){
                self._playerJump*=0.6*de60;
            }
            else if(self.state==1||self.state==-3){
                if(self._playerJump<=0){
                    self.state=2;
                    [self gotoAndStop:@"fall" val:0];
                }
                
            }
            
            if(self.state==2&&(self.position.y+self._playerJump<=safeY&&self.position.y>=safeY&&self.isDead==NO)){
                
                self.position=ccp(self.position.x,safeY);//0---10
                [self gotoAndStop:@"run" val:0];
                
                self.state=0;
                
                [((GameMain*)[self gm]).pf hitTestOB];
            }
            else{
                
                
                self.position=ccp(self.position.x,self.position.y+self._playerJump);
                
                if(self.isDead){
                    if(self.position.y<-300){
                        
                        
                        if(self.speed>0){
                            self.speed*=0.8;
                            if(self.speed<=0.2){
                                self.speed=0;
                            }
                        }else{
                            if([self.gm stopGame]==NO){
                                GameMain *gameMain=(GameMain*)self.gm;
                                
                                [self done];
                                
                                flag=YES;
                                
                           
                              NSInteger  myLife=[[NSUserDefaults standardUserDefaults] integerForKey:@"live"];
                                //NSLog(@"mylife in integer format is === %d",myLife);
                                
                                myLife=myLife-1;
                                
                                [[NSUserDefaults standardUserDefaults] setInteger:myLife forKey:@"live"];
                                [[NSUserDefaults standardUserDefaults]synchronize];
                                [self.gm updateLives:myLife];
                              //  NSLog(@"##################################");
                                
                                
                                [[CCDirector sharedDirector] pause];
                                  [self createUIforPopup];
                                
                                  if (isChartBoostFail == NO) {
                                      
                                   //   [self createUIforPopup];
                                   /*
                                  NSTimer *timer=[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(checkVideoState) userInfo:nil repeats:YES];
                                    */
                                      
                                     
                                      
                                    }else{
                                       
//                            [[AppDelegate sharedAppDelegate]showToastMessage:@"Sorry no video ads available at this time"];
                                        
//                                        [[CCDirector sharedDirector] resume];
//                                        GameMain *gameMain=(GameMain*)self.gm;
//                                        [gameMain showGameOver];
                                        
                                    }
                                }
                           }
                    }
                }
            }
            if((safeY!=300&&self.position.y<safeY&&self.state!=1)){
                self.isDead=YES;
            }
        }
        self._playerJump-=0.25*de60;
    }
}

-(void)notification{
    [self readyForNewGame1];
    [self update:0.1];
}


-(void)showVideoAd{
//    
//    UIAlertView *view = [[UIAlertView alloc]initWithTitle:@" Do you want to continue without loosing a life?" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
//    [view show];
}


-(void)okButtonAction:(id)sender{
    NSLog(@"ok button action");
    secondView.hidden = YES;
    BOOL netwrok_status=[[NSUserDefaults standardUserDefaults] boolForKey:CurrentNetworkStatus];
    
    if (netwrok_status==YES && isChartBoostFail ==NO) {
        
          [Chartboost showRewardedVideo:CBLocationStartup];
          [self performSelector:@selector(checkVideoState) withObject:nil afterDelay:5];
    }
    else{
      
        
         [[AppDelegate sharedAppDelegate]showToastMessage:@"Sorry no video ads available at this time"];
        
        [[CCDirector sharedDirector] resume];
        GameMain *gameMain=(GameMain*)self.gm;
        
        [gameMain showGameOver];
        
        NSLog(@"=========Player Dead ,Game Over !===========");
    
    }
}

-(void)cancelButtonAction:(id)sender{
      secondView.hidden = YES;
       NSLog(@"cancel button action");
    BOOL netwrok_status=[[NSUserDefaults standardUserDefaults] boolForKey:CurrentNetworkStatus];
    
    if (netwrok_status==YES) {
        [Chartboost showInterstitial:CBLocationStartup];
    }
    [[CCDirector sharedDirector] resume];
    GameMain *gameMain=(GameMain*)self.gm;
    [gameMain showGameOver];
    NSLog(@"=========Player Dead ,Game Over !===========");
   

}

-(void)createUIforPopup{
    
    rootViewController = (UIViewController*)[(AppDelegate*)[[UIApplication sharedApplication] delegate] getRootViewController];

//    if (!secondView) {
    
    if ([UIScreen mainScreen].bounds.size.height<500) {
        secondView = [[UIView alloc]initWithFrame:CGRectMake(110, 20, 245, 295)];
    }else{
        secondView = [[UIView alloc]initWithFrame:CGRectMake(150, 20, 245, 295)];
    }
    
    [secondView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"popup.png"]]];
    [rootViewController.view addSubview:secondView];
    
    if ([UIScreen mainScreen].bounds.size.height<500) {
        friendsLevel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 200, 100)];
    }else{
        friendsLevel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 200, 100)];
    }
    friendsLevel.text=@"Do you want to continue without loosing a life?";
    friendsLevel.lineBreakMode = NSLineBreakByWordWrapping;
    friendsLevel.numberOfLines = 0;
    [secondView addSubview:friendsLevel];
    
    
    UIImage *btnImage = [UIImage imageNamed:@"cancel1.png"];
    okButton = [[UIButton alloc]init];
    okButton.frame = CGRectMake(10,220, 100, 50);
    [okButton setImage:btnImage forState:UIControlStateNormal];
    
     UIImage *backImage = [UIImage imageNamed:@"accept1.png"];
    cancelButton = [[UIButton alloc]init];
    cancelButton.frame = CGRectMake(120,220,100, 50);
    [cancelButton setImage:backImage forState:UIControlStateNormal];
    [okButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton addTarget:self action:@selector(okButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [secondView addSubview:okButton];
    [secondView addSubview:cancelButton];
    
    UIImage *playerImage = [UIImage imageNamed:@"hit0001.png"];
    player = [[UIButton alloc]init];
    player.frame = CGRectMake(50,100,100, 100);
    [player setImage:playerImage forState:UIControlStateNormal];
    [secondView addSubview:player];
//    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Ok"])
    {
        NSLog(@"Button 1 was selected.");
        /*
        BOOL netwrok_status=[[NSUserDefaults standardUserDefaults] boolForKey:CurrentNetworkStatus];
        if (netwrok_status==YES) {
//        [Chartboost cacheRewardedVideo:CBLocationStartup];
        [Chartboost showRewardedVideo:CBLocationStartup];
        }else{
            NSLog(@"Button 2 was selected.");
            [[CCDirector sharedDirector] resume];
            GameMain *gameMain=(GameMain*)self.gm;
//            [gameMain.viewHost1 removeFromSuperview];
            
            [gameMain showGameOver];
            
            NSLog(@"=========Player Dead ,Game Over !===========");
            
            */
            ////////////////////////////
        
         rootViewController = (UIViewController*)[(AppDelegate*)[[UIApplication sharedApplication] delegate] getRootViewController];
        
        secondView = [[UIView alloc]initWithFrame:CGRectMake(110, 20, 245, 295)];
        [secondView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"popup.png"]]];
        [rootViewController.view addSubview:secondView];
        
        if ([UIScreen mainScreen].bounds.size.height<500) {
            friendsLevel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 200, 100)];
        }else{
            friendsLevel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 200, 100)];
        }
        friendsLevel.text=@"Do you want to continue without loosing a life?";
        friendsLevel.lineBreakMode = NSLineBreakByWordWrapping;
        friendsLevel.numberOfLines = 0;
        [secondView addSubview:friendsLevel];
        
        
        UIImage *btnImage = [UIImage imageNamed:@"ok.png"];
        okButton = [[UIButton alloc]init];
        okButton.frame = CGRectMake(10,220, 100, 50);
        [okButton setImage:btnImage forState:UIControlStateNormal];
        
        
        
        UIImage *backImage = [UIImage imageNamed:@"cancel1.png"];
        cancelButton = [[UIButton alloc]init];
        cancelButton.frame = CGRectMake(120,220,100, 50);
        [cancelButton setImage:backImage forState:UIControlStateNormal];
        [okButton addTarget:self action:@selector(okButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [secondView addSubview:okButton];
        [secondView addSubview:cancelButton];

          UIImage *playerImage = [UIImage imageNamed:@"hit0001.png"];
        player = [[UIButton alloc]init];
        player.frame = CGRectMake(50,100,100, 100);
        [player setImage:playerImage forState:UIControlStateNormal];
        [secondView addSubview:player];

        
      //  }
    }
    else if([title isEqualToString:@"Cancel"])
    {
        NSLog(@"Button 2 was selected.");
        [[CCDirector sharedDirector] resume];
        GameMain *gameMain=(GameMain*)self.gm;
        [gameMain showGameOver];
        NSLog(@"=========Player Dead ,Game Over !===========");
    }
}

-(void)test{
    
    GameMain *gameMain=(GameMain*)self.gm;
    gameMain.stopGame=YES;
    
    [self.mc stopAllActions];
    
    [GameState sharedState].clear=TRUE;
   
    gameMain.stopGame=YES;
    
    [gameMain showGameOver];
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"crash.wav" pitch:1 pan:0 gain:1];
    NSLog(@"=========Player Dead ,Game Over !===========");
    
}


-(void)customGameOver{
     GameMain *gameMain=(GameMain*)self.gm;
      [gameMain showGameOver];
      self.isDead=YES;
      gameMain.stopGame=YES;
    
}

//-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//
//   [self fireUp];
//    
//    
//}
//
//-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//    //[self gotoAndStop:@"fall" val:1];
//    [self stopAllActions];
//    [self gotoAndStop:@"run" val:1];
//}


- (void) done1 {
    flag=NO;
  
}



-(int) currentY{
    return mc.position.y;
}

#pragma mark
#pragma mark Ready for new Game.
#pragma mark =============================
-(void) readyForNewGame{
    self.isDead=NO;
    self._playerJump=_playerJumpPower;
    self.speed=self.initSpeed;
    self.maxSpeed=400.0f;
    self.state=-1;
    [self gotoAndStop:@"stand" val:0];
    self.position=ccp([Player initX],[Player initY]);
     
}

-(void) readyForNewGame1 {
    self.isDead=NO;
    self._playerJump=_playerJumpPower;
   // self._playerJump=10;
    self.speed=self.initSpeed;
    self.maxSpeed=400.0f;
     NSInteger myLife=[[NSUserDefaults standardUserDefaults] integerForKey:@"live"];
     NSString *myLife1 = [NSString stringWithFormat:@"%d",(int)myLife];
    
   
    // setup speed for game.
    
    self.maxSpeed=400.0f;
    
    if ([GameState sharedState].levelNumber<=10) {
        self.initSpeed=100.0f;
        self.maxSpeed=150.0f;
    }
    
    if ([GameState sharedState].levelNumber>10 && [GameState sharedState].levelNumber <=20) {
        self.initSpeed=120.0f;
        self.maxSpeed=180.0f;
    }
    
    if ([GameState sharedState].levelNumber>20 && [GameState sharedState].levelNumber <=30) {
        self.initSpeed=180.0f;
         self.maxSpeed=220.0f;
        
    }
    
    if ([GameState sharedState].levelNumber>30 && [GameState sharedState].levelNumber <=40) {
        self.initSpeed=200.0f;
         self.maxSpeed=250.0f;
    }
    
    
    if ([GameState sharedState].levelNumber>40 && [GameState sharedState].levelNumber <=50) {
        self.initSpeed=300.0f;
         self.maxSpeed=400.0f;
    }
    // self.maxSpeed=400.0f;
    pcheck=7;
    self.speed=self.initSpeed;
    self.state=0;
    self._playerJump=0;
    self._playerJumpPower=11;
    
    self.minY=50;
    
    self.currentLevel=1;
    self.acceleration=1;

    flag=NO;
    self.position=ccp(self.position.x,self.platformAcc.getSafeY);
    self.state=0;
    
   [self gotoAndStop:@"run" val:0];
    
}


-(void) callAfterSixtySecond:(NSTimer*) t
{
    
//    [self gotoAndStop:@"jump" val:0];
    self._playerJump=10;
    self._playerJumpPower=10;
//    NSLog(@"player jump is=== %f",self._playerJump);
//    NSLog(@"player jump power is === %f",self._playerJumpPower);
   // NSLog(@"############");
   self.position=ccp(self.position.x,self.platformAcc.getSafeY);
    
    //  self.position=ccp(self.position.x,self.position.y+self._playerJump);
    
   // [self update:1];
     // NSLog(@"called every second");
//    GameMain *gameMain=[GameMain alloc];
//    [gameMain loop:1];

}
#pragma mark ------ set jump power.

//jump
-(void) jump{
    NSLog(@"self.position.y= %f",self.position.y);
    [self gotoAndStop:@"jump" val:0];
    
    [self performSelector:@selector(done) withObject:nil afterDelay:0.5];
    
   // NSLog(@"self.position.y== %f",self.position.y);
    
    if (self.position.y <=20) {
                self._playerJump=11;
           }
            if (self.position.y > 20 && self.position.y <=40) {
                self._playerJump=10;
            }
            if (self.position.y >40 && self.position.y<=60) {
                self._playerJump=10;
            }
            if (self.position.y >60 && self.position.y<=80) {
                self._playerJump=9;
         }
          if (self.position.y >80 && self.position.y<=100) {
                self._playerJump=8;
            }
           if (self.position.y >100 && self.position.y<=120) {
               self._playerJump=8;
            }
            if (self.position.y >120 && self.position.y<=140) {
                self._playerJump=8;
            }
      if (self.position.y >140 && self.position.y<=160) {
              self._playerJump=7;
         }
    
         if (self.position.y >160) {
         self._playerJump=7;
           }
    self.state=1;
}

//spray up by fire
-(void) fireUp{
    [self gotoAndStop:@"fire" val:0];
   // self._playerJump=self._playerJumpPower*.65;
    
    self._playerJump=self._playerJumpPower*.50;
    
    if (self.position.y >140) {
        NSLog(@"self.position.y is %f",self.position.y);
         self._playerJump=self._playerJumpPower*.30;
    }
    NSLog(@" self._playerJump is %f", self._playerJump);
    NSLog(@" self._playerJumpPower is %f", self._playerJumpPower);
    self.state=-3;
    
}

-(void) fall{
    [self gotoAndStop:@"fall" val:0];
}

+(int) initX{
    return 100;
}

+(int) initY{
    return 40;
}

- (void) dealloc
{
    self.mc = nil;
    self.loopStand = nil;
    self.loopJump = nil;
    self.loopRun = nil;
    self.platformAcc=nil;
    self.loopFall=nil;
    self.loopFire=nil;
    [super dealloc];
}

#pragma mark --- chartboost delegate methods.
-(void)checkVideoState{
    
    if (checkAdState == NO) {
        BOOL netwrok_status=[[NSUserDefaults standardUserDefaults] boolForKey:CurrentNetworkStatus];
        
        if (netwrok_status==YES) {
//            [Chartboost showInterstitial:CBLocationStartup];
        }
        
        
        [[AppDelegate sharedAppDelegate]showToastMessage:@"Sorry no video ads available at this time"];
        
        [[CCDirector sharedDirector] resume];
        GameMain *gameMain=(GameMain*)self.gm;
        [gameMain showGameOver];
    }
}

- (BOOL)shouldDisplayRewardedVideo:(CBLocation)location{
    checkAdState = YES;
    NSLog(@"shouldDisplayRewardedVideo");
    [[SimpleAudioEngine sharedEngine]stopBackgroundMusic];
    
    
    return YES;
}

- (void)didDisplayRewardedVideo:(CBLocation)location{
    NSLog(@"didDisplayRewardedVideo");
}

- (void)didCacheRewardedVideo:(CBLocation)location{
    NSLog(@"didCacheRewardedVideo");
    
}

- (void)didFailToLoadRewardedVideo:(CBLocation)location
                         withError:(CBLoadError)error{
    NSLog(@"error to load %u",error);
    isChartBoostFail = YES;
}

- (void)didDismissRewardedVideo:(CBLocation)location{
    NSLog(@"entered here when dismissed after video pop up");
     [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"bgm.mp3" loop:YES];

}
- (void)didCompleteRewardedVideo:(CBLocation)location
                      withReward:(int)reward{
    NSLog(@"didCompleteRewardedVideo");
    [GameState sharedState].checkAd = YES ;
   
  [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"bgm.mp3" loop:YES];
   
    
    int life=(int)[[NSUserDefaults standardUserDefaults] integerForKey:@"live"];
    if (life<=5)
    {
        life=life+reward;
        NSLog(@"life is %d",life);
        NSLog(@"Added One life");
    }
    
    [[NSUserDefaults standardUserDefaults]setInteger:life forKey:@"live"];
    [[NSUserDefaults standardUserDefaults]synchronize];
     [self.gm updateLives:life];
    
    
    
}
- (void)didCloseRewardedVideo:(CBLocation)location{
    NSLog(@"didCloseRewardedVideo");
    secondView.hidden = YES;
    
   [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"bgm.mp3" loop:YES];
   BOOL check =  [GameState sharedState].checkAd ;
    if (check) {
        [[CCDirector sharedDirector] resume];
        [self readyForNewGame1];
        [self update:0.01];
         [GameState sharedState].checkAd = NO;
    }
    else{
        BOOL netwrok_status=[[NSUserDefaults standardUserDefaults] boolForKey:CurrentNetworkStatus];
        
        if (netwrok_status==YES) {
            [Chartboost showInterstitial:CBLocationStartup];
        }

        
        [[CCDirector sharedDirector] resume];
        GameMain *gameMain=(GameMain*)self.gm;
        gameMain.stopGame=YES;
        
        [self.mc stopAllActions];
        
        [GameState sharedState].clear=TRUE;
        
        gameMain.stopGame=YES;
        [gameMain showGameOver];
        [[SimpleAudioEngine sharedEngine] playEffect:@"crash.wav" pitch:1 pan:0 gain:1];
    }
    checkAdState = NO;
    
}

- (void)didClickRewardedVideo:(CBLocation)location{
    NSLog(@"here");
}

- (void)didCacheInPlay:(CBLocation)location{
    NSLog(@"here");
}

- (void)didFailToLoadInPlay:(CBLocation)location
                  withError:(CBLoadError)error{
    NSLog(@"error is %u",error);
    
}


- (void)willDisplayVideo:(CBLocation)location{
    NSLog(@"here");
}

@end
