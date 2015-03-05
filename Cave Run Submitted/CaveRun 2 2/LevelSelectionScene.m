//
//  LevelSelectionScene.m
//  BowHunting
//
//  Created by Sumit Ghosh on 03/05/14.
//  Copyright (c) 2014 tang. All rights reserved.
//

#import "LevelSelectionScene.h"
#import "AppDelegate.h"
#import "GameMain.h"
#import "MainMenu.h"
#import "cocos2d.h"
#import "GameState.h"
#import "RootViewController.h"
#import "FriendsLevel.h"

@implementation LevelSelectionScene
@synthesize loopRun;
@synthesize man,lives,player,playButton,cancelButton1,backgroundView,imgView,namelabel,scorelabel,levellabel,targetlabel,target,mutArray,cancelBtn;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	LevelSelectionScene *layer = [LevelSelectionScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id)init {
    
    if (self=[super init]) {
        
        [self compareDate];
        
//        [[GameState sharedState].bannerView removeFromSuperview];

        
        BOOL netwrok_status=[[NSUserDefaults standardUserDefaults] boolForKey:CurrentNetworkStatus];
        if (netwrok_status==YES) {
            rootViewController = (UIViewController*)[(AppDelegate*)[[UIApplication sharedApplication] delegate] getRootViewController];
            CGSize winSize=[CCDirector sharedDirector].winSize;
            
            if (adm) {
                adm=nil;
            }
            [GameState sharedState].bottomBanner=YES;
            adm = [[AdMobViewController alloc]init];
            viewHost1 = adm.view;
            [[[CCDirector sharedDirector] openGLView] addSubview:viewHost1];
        }

        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"clips.plist"];
        
        CGSize ws=[[CCDirector sharedDirector]winSize];
        
        spriteBackground=[CCSprite spriteWithFile:@"background_1-1.png"];
        spriteBackground.position=ccp(ws.width/2,ws.height/2);
        
        if ([UIScreen mainScreen].bounds.size.height<500) {
            [self resizeSprite:spriteBackground toWidth:500 toHeight:350];
        }else{
            [self resizeSprite:spriteBackground toWidth:600 toHeight:350];
        }
        [self addChild:spriteBackground];
        
        rootViewController = (UIViewController*)[(AppDelegate*)[[UIApplication sharedApplication] delegate] getRootViewController];
        
        CCMenuItemImage *menuItemImageBack = [CCMenuItemImage  itemFromNormalImage:@"backLevel.png" selectedImage:@"backLevel.png" target:self selector:@selector(backBtnAction:)];
        
        menuBack=[CCMenu menuWithItems:menuItemImageBack, nil];
        
        if([UIScreen mainScreen].bounds.size.height>500){
            scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(120, 70, 800, 200)];
            menuBack.position=ccp(120, ws.height-40);
            
            levelBackground=[CCSprite spriteWithFile:@"game-bg-1.png"];
            levelBackground.position=ccp(ws.width/2,ws.height/2);
            
            [self addChild:levelBackground];
            
            
            NSMutableArray *walkAnimFrames = [NSMutableArray array];
            for (int i=1; i<=35; i++) {
                [walkAnimFrames addObject:
                 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                  [NSString stringWithFormat:@"run%04d.png",i]]];
            }
            
            
            id animation = [CCAnimation animationWithFrames:walkAnimFrames delay:0.06];
            
            self.man = [CCSprite spriteWithSpriteFrameName:@"run0001.png"];
            walkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]];
            [self.man runAction:walkAction];
            man.position=ccp(150,ws.height-40);
            
            //added now
            
            id actionMove = [CCMoveTo actionWithDuration:5 position:ccp(450,ws.height-40)];
            
            [man runAction:actionMove];
            
            CCCallBlock *block = [CCCallBlock actionWithBlock:^{
                [man stopAllActions];
            }];
            
            CCDelayTime *time = [CCDelayTime actionWithDuration:5];
            
            
            [man runAction:[CCSequence actions:time, block, nil]];
            
            [self addChild:man];
            
            
        }
        else{
            scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(80, 70, 350, 200)];
            menuBack.position=ccp(70, ws.height-40);
            
            levelBackground=[CCSprite spriteWithFile:@"game-bg-1.png"];
            levelBackground.position=ccp(ws.width/2,ws.height/2);
            
            [self addChild:levelBackground];
            
            
            NSMutableArray *walkAnimFrames = [NSMutableArray array];
            for (int i=1; i<=35; i++) {
                [walkAnimFrames addObject:
                 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                  [NSString stringWithFormat:@"run%04d.png",i]]];
            }
            //test this.
            
//            if (ws.width>ws.height) {
//                scrollV.frame = CGRectMake(100, 70, 350, 200);
//            }

           
            
            id animation = [CCAnimation animationWithFrames:walkAnimFrames delay:0.06];
            
            self.man = [CCSprite spriteWithSpriteFrameName:@"run0001.png"];
            walkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]];
            [self.man runAction:walkAction];
            man.position=ccp(100,ws.height-40);
            
//            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
////                 if([UIScreen mainScreen].bounds.size.width>660) {
//                scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(110, 70, 800, 200)];
//                menuBack.position=ccp(120, ws.height-40);
//                man.position=ccp(150,ws.height-40);
////                 }
//                //iphone 6
//            }
            
            //added now
            
            id actionMove = [CCMoveTo actionWithDuration:5 position:ccp(400,ws.height-40)];
            
            [man runAction:actionMove];
            
            
            CCCallBlock *block = [CCCallBlock actionWithBlock:^{
                [man stopAllActions];
            }];
            
            CCDelayTime *time = [CCDelayTime actionWithDuration:5];
            [man runAction:[CCSequence actions:time, block, nil]];
            
            [self addChild:man];
            
        }
        
        scrollV.contentSize=CGSizeMake(250,500);
        scrollV.scrollEnabled=YES;
        
        NSLog(@"[UIScreen mainScreen].bounds.size.width %f",[UIScreen mainScreen].bounds.size.width);
        NSLog(@"height = %f",[UIScreen mainScreen].bounds.size.height);

        if ([UIScreen mainScreen].bounds.size.width>[UIScreen mainScreen].bounds.size.height) {
              scrollV.frame = CGRectMake(110, 70, 350, 200);
        }
        
        [rootViewController.view addSubview:scrollV];
        
        
        [self addChild:menuBack];
        int levelNumbers = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"levelClear"];
        NSLog(@"level numbers is %d",levelNumbers);
        for (int i=0; i<5; i++) {
            
            for (int j=0; j<10; j++) {
                btnLevels = [UIButton buttonWithType:UIButtonTypeSystem];
                
                btnLevels.frame=CGRectMake(15+65*i, 50*j, 48, 48);
                unsigned buttonNumber = j*5+i+1;
                
                btnLevels.tag=buttonNumber;
                
                btnLevels.titleLabel.font=[UIFont
                                           fontWithName:@"NKOTB Fever" size:20];
                [btnLevels setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btnLevels addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
                [scrollV addSubview:btnLevels];
                
                
                
                if (levelNumbers==0) {
                    
                    if (buttonNumber==1) {
                        [btnLevels setBackgroundImage:[UIImage imageNamed:@"level.png"] forState:UIControlStateNormal];
                        NSString *str =[NSString stringWithFormat:@"%ld",(long)btnLevels.tag];
                        [btnLevels setTitle:str forState:UIControlStateNormal];
                    }
                    else{
                        [btnLevels setBackgroundImage:[UIImage imageNamed:@"unlock.png"] forState:UIControlStateNormal];
                    }
                }
                
                else {
                    
                    if (buttonNumber==levelNumbers) {
                        [btnLevels setBackgroundImage:[UIImage imageNamed:@"glowing.png"] forState:UIControlStateNormal];
                        NSString *str =[NSString stringWithFormat:@"%ld",(long)btnLevels.tag];
                        [btnLevels setTitle:str forState:UIControlStateNormal];
                    }
                    else if (buttonNumber>levelNumbers) {
                        [btnLevels setBackgroundImage:[UIImage imageNamed:@"unlock.png"] forState:UIControlStateNormal];
                    }
                    else {
                        [btnLevels setBackgroundImage:[UIImage imageNamed:@"level.png"] forState:UIControlStateNormal];
                        NSString *str =[NSString stringWithFormat:@"%ld",(long)btnLevels.tag];
                        [btnLevels setTitle:str forState:UIControlStateNormal];
                    }
                }
            }
        }
    }
//   [self displayFriendsListUI];
    return self;
}
-(void)onEnterTransitionDidFinish{
    NSLog(@"On Enter Transition");
    
    [self schedule:@selector(levelselectionAnimation) interval:.3] ;
    
}
-(void) levelselectionAnimation{
    [self unschedule:@selector(levelselectionAnimation)];
    int levelNumbers = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"levelClear"];
    CGFloat h = 0;
    if (levelNumbers>=15 && levelNumbers <= 24) {
        //[scrollV setContentOffset:CGPointMake(0, 150)];
        h = 100;
    }
    else if (levelNumbers >= 25 && levelNumbers < 34){
        // [scrollV setContentOffset:CGPointMake(0, 200)];
        h = 200;
    }
    else if (levelNumbers >= 35 && levelNumbers < 44){
        // [scrollV setContentOffset:CGPointMake(0, 200)];
        h = 300;
    }
    else if (levelNumbers >= 45){
        // [scrollV setContentOffset:CGPointMake(0, 250)];
        h = 350;
    }
    else{
        //[scrollV setContentOffset:CGPointZero];
        h = 0;
    }
    float time = levelNumbers/20;
    if (time<1) {
        time = 1;
    }
    [UIView animateWithDuration:time animations:^{
        [scrollV setContentOffset:CGPointMake(0, h)];
    }];
}
#pragma mark--------

- (void) createUI:(int)level{
//    scrollV.hidden =YES ;
//    btnLevels.hidden = YES;
    
    NSLog(@"level is %d",level);
    CGRect frame = [UIScreen mainScreen].bounds;
    if (self.backgroundView == nil) {
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.width)];
        self.backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"popupbg.png"]];
        [rootViewController.view addSubview:backgroundView];
        self.backgroundView.center = CGPointMake(frame.size.height/2, frame.size.width/2);
        
        firstView = [[UIView alloc]init];//WithFrame:CGRectMake(170, 20, 245, 295)];
        [firstView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"popup.png"]]];
        
        
        secondView = [[UIView alloc]init];//WithFrame:CGRectMake(10, 20, 180, 280)];
        [secondView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"highscore.png"]]];
        [backgroundView addSubview:secondView];
        [backgroundView addSubview:firstView];
        

        self.playButton = [[UIButton alloc]init];//WithFrame:CGRectMake(250, 200, 100, 50)];
        
        if (frame.size.height>500) {
            firstView.frame = CGRectMake(240, 20, 245, 295);
            secondView.frame = CGRectMake(70, 20, 180, 280);
//            self.cancelButton1.frame = CGRectMake(444, 13, 50, 50);
//            self.playButton.frame = CGRectMake(270, 200, 100, 50);
            self.playButton.frame = CGRectMake(310, 200, 100, 50);
        }
        else{
            firstView.frame = CGRectMake(170, 20, 245, 295);
            secondView.frame = CGRectMake(10, 20, 180, 280);
//            self.cancelButton1.frame = CGRectMake(345, 13, 100, 50);
            self.playButton.frame = CGRectMake(250, 200, 100, 50);
        }
        
        UIImage *canImg = [UIImage imageNamed:@"close1.png"];
        cancelBtn = [[UIButton alloc]init];
        
        if (frame.size.height>500){
            cancelBtn.frame=CGRectMake(frame.size.height-140,10,100,50);
        }else{
            cancelBtn.frame=CGRectMake(frame.size.height-120,10,100,50);
        }
        
        if ([UIScreen mainScreen].bounds.size.width>[UIScreen mainScreen].bounds.size.height) {
            cancelBtn.frame=CGRectMake(-30,10,100,50);
        }
        //cancelBtn.frame=CGRectMake(frame.size.height-120,10,100,50);
//                     WithFrame:CGRectMake(400, 20, 30, 30)];
        [cancelBtn setImage:canImg forState:UIControlStateNormal];
        [backgroundView addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        UIImage *btnImage = [UIImage imageNamed:@"play.png"];
        [playButton setImage:btnImage forState:UIControlStateNormal];
        
        [backgroundView addSubview:playButton];
        [playButton addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        levellabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 50, 100, 35)];
        levellabel.backgroundColor = [UIColor clearColor];
        //  levellabel.font = [UIFont systemFontOfSize:20];
        levellabel.numberOfLines = 0;
        levellabel.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:20];
        levellabel.lineBreakMode = NSLineBreakByCharWrapping;
        levellabel.text = [NSString stringWithFormat:@"Level % d",level];
        [firstView addSubview:levellabel];
        
        targetlabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 90, 200, 35)];
        targetlabel.backgroundColor = [UIColor clearColor];
        targetlabel.textColor = [UIColor orangeColor];
        targetlabel.font = [UIFont boldSystemFontOfSize:20];
        // targetlabel.font = [UIFont systemFontOfSize:20];
        
        if(level<=10)
        {
            target=25;
        }
        else if(level>=11&&level<=20)
        {
            target=35;
        }
        else if(level>=21&&level<=30)
        {
            target=40;
        }
        else if(level>=31&&level<=40)
        {
            target=45;
        }
        else if(level>=41&&level<=50)
        {
            target=50;
        }
        else{
            NSLog(@"Unknown Level");
        }
        targetlabel.text = [NSString stringWithFormat:@"Target %d coins",target];
        [firstView addSubview:targetlabel];
    }
    else{
        self.backgroundView.hidden = NO;
        [rootViewController.view addSubview:backgroundView];
        levellabel.text = [NSString stringWithFormat:@"Level % d",level];
        
        if(level<=10)
        {
            target=25;
        }
        else if(level>=11&&level<=20)
        {
            target=35;
        }
        else if(level>=21&&level<=30)
        {
            target=40;
        }
        else if(level>=31&&level<=40)
        {
            target=45;
        }
        else if(level>=41&&level<=50)
        {
            target=50;
        }
        else{
            NSLog(@"Unknown Level");
        }
        targetlabel.text = [NSString stringWithFormat:@"Target %d coins",target];
        
    }
}

//to animate the sprite

-(void)resizeSprite:(CCSprite*)sprite toWidth:(float)width toHeight:(float)height {
    sprite.scaleX = width / sprite.contentSize.width;
    sprite.scaleY = height / sprite.contentSize.height;
}
-(void)cancelBtnAction:(id)sender{
    [backgroundView removeFromSuperview];
}

-(void)backBtnAction:(id)sender {
    [viewHost1 removeFromSuperview];
    viewHost1 = nil;
    
    scrollV.hidden=YES;
    [self removeChild:spriteBackground cleanup:YES];
    [self removeChild:menuBack cleanup:YES];
    [self removeChild:levelBackground cleanup:YES];
    
    BOOL check = [[NSUserDefaults standardUserDefaults] boolForKey:FacebookConnected];
    
    if (check == YES) {
     [[CCDirector sharedDirector] replaceScene:[FriendsLevel node]];
    }else{
        [[CCDirector sharedDirector]replaceScene:[MainMenu node]];
    }
}


-(void)playButtonAction:(id)sender{
    
    scrollV.hidden=YES;
    scrollV = nil;
    backgroundView.hidden=YES;
    backgroundView = nil;
    
    //CCTransitionFadeTR
    
    
    
    [[CCDirector sharedDirector]replaceScene:[CCTransitionFadeTR transitionWithDuration:0.8 scene:[GameMain scene]]];
    
    //    GameMain *obj = [[GameMain alloc]init];
    //    [self addChild:obj];
    
    //  [[CCDirector sharedDirector]runWithScene:[CCTransitionFadeTR transitionWithDuration:1.0 scene:[GameMain scene]]];
    
    [self removeChild:spriteBackground cleanup:YES];
    [self removeChild:menuBack cleanup:YES];
    [self removeChild:levelBackground cleanup:YES];
    [self removeChild:man cleanup:YES];
}

-(void)findPlayerLevel{
    
    
    NSString *fbID = [[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID];
    
    if (fbID) {
        
        PFQuery * query=[PFQuery queryWithClassName:ParseScoreTableName];
        [query whereKey:@"PlayerFacebookID" equalTo:fbID];
        [query orderByDescending:@"Level"];
        
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            
           NSNumber *num=object[@"Level"];
            NSLog(@"[num intValue]+1 is %d",[num intValue]+1);
          
            
            [[NSUserDefaults standardUserDefaults] setInteger:[num intValue]+1 forKey:@"levelClear"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
        }];
    }
}
                   
-(void)btnAction:(id)sender {
    
    [viewHost1 removeFromSuperview];
    viewHost1 = nil;
    
    int levelNumbers = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"levelClear"];
    
    if (levelNumbers < [sender tag] && levelNumbers != 0) {
        return;
    }
    
    [GameState sharedState].levelNumber=(int)[sender tag];
    NSLog(@"level here is %d",[GameState sharedState].levelNumber);
    
    if ([sender isKindOfClass:[UIButton class]]) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        
        NSString *life = [userDefault objectForKey:@"live"];
        if (life.intValue>0) {
            
            [self createUI:[GameState sharedState].levelNumber];
            
            //NSString *connectedFBID = [userDefault objectForKey:ConnectedFacebookUserID];
           
            // full screen add.
           
         
            BOOL fbCheck = [[NSUserDefaults standardUserDefaults] boolForKey:FacebookConnected];
            BOOL networkStatus = [[NSUserDefaults standardUserDefaults]boolForKey:CurrentNetworkStatus];
                       
            if (fbCheck==YES && networkStatus == YES) {
                NSLog(@"Fetched score from parse and display play option");
                [self retriveFriendsScore:[sender tag]];
                NSLog(@"sender tag is %ld",(long)[sender tag]);
            }
            // if fb check
            else{
                NSLog(@"display Play option with selected level");
                
            }// else fb check
            
        }// if life check
        else{
            NSLog(@"Display game over Scene");
            scrollV.hidden=YES;
//            scrollV = nil;
//            backgroundView.hidden=YES;
//            backgroundView = nil;
            
            
            [self compareDate];
            
//            [[CCDirector sharedDirector]replaceScene:[CCTransitionFadeTR transitionWithDuration:0.8 scene:[LifeOver scene]]];//1.0
            
            [[CCDirector sharedDirector]replaceScene:[LifeOver scene]];
            
//            [self removeChild:spriteBackground cleanup:YES];
//            [self removeChild:menuBack cleanup:YES];
//            [self removeChild:levelBackground cleanup:YES];
//            [self removeChild:man cleanup:YES];
            
            
        }
    }
    
}

- (GADInterstitial *)createAndLoadInterstitial {
    GADInterstitial *interstitial = [[GADInterstitial alloc] init];
    interstitial.adUnitID = @"ca-app-pub-4722099521556590/4105472067";
    //   interstitial.adUnitID = @" ca-app-pub-7073257741073458/5784557896";
    
    interstitial.delegate = self;
    GADRequest *request = [GADRequest request];
    //    request.testDevices = [NSArray arrayWithObjects:GAD_SIMULATOR_ID,@"TheIDAppearingInLogs",nil];
    [interstitial loadRequest:request];
    return interstitial;
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial {
    NSLog(@"add received for full screen in level selection. ");
    
    if ([self.interstitial isReady]) {
        NSLog(@"inside");
        [self performSelector:@selector(doit) withObject:nil afterDelay:0];
    }
}
-(void)doit{
    [self.interstitial presentFromRootViewController:rootViewController];
}



#pragma mark
#pragma mark Compare date
#pragma mark =============================
-(void)compareDate {
    
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
        
        unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSSecondCalendarUnit;
        NSCalendar *gregorianCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        
        NSDateComponents *conversionInfo = [gregorianCal components:unitFlags fromDate:oldDate  toDate:currentDate  options:0];
        
        //int months = (int)[conversionInfo month];
        int days = (int)[conversionInfo day];
        int hours = (int)[conversionInfo hour];
        int minutes = (int)[conversionInfo minute];
        int seconds = (int)[conversionInfo second];
        
        [self getExtraLife:days andHour:hours andMin:minutes andSec:seconds];
    }
    
}


//==========================================
-(void)getExtraLife :(int)aday andHour:(int)ahour andMin:(int)amin andSec:(int)asec {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    int hoursInMin = ahour*60;
    hoursInMin=hoursInMin+amin;
    
    int extralife =amin/5;
    
    int totalTime = amin*60+asec;
    
    NSLog(@"Total Time = %d",totalTime);
    int rem =amin%5;
    
    int remTimeforLife = rem*60+asec;
    
    remTimeforLife=300-remTimeforLife;
     int life =(int)[[NSUserDefaults standardUserDefaults]integerForKey:@"live"];
    
    if (aday>0 || hoursInMin>=25) {
        
        [userDefault setInteger:5 forKey:@"live"];
        [userDefault setObject:@"0" forKey:@"strtdate"];
    }
    else if(totalTime>=300){
        
        if(extralife>=5){
            
            [userDefault setInteger:5 forKey:@"live"];
            [userDefault setObject:@"0" forKey:@"strtdate"];
            
        }
    }
    else{
        
        NSLog(@"extra life = %d",extralife);
        NSLog(@"life is = %d",life);
        
        if (extralife>0) {
            life= life+extralife;
            if (life>=5) {
                life=5;
            }
            [userDefault setInteger:life forKey:@"live"];
        }
        
        if ([GameState sharedState].shareOnFacebook == YES) {
             [userDefault setInteger:5 forKey:@"live"];
            [GameState sharedState].shareOnFacebook = NO;
        }
    }
    [userDefault synchronize];
}

-(void) retriveFriendsScore:(NSInteger)levelSelected {

    NSMutableArray *mutArr = [[NSMutableArray alloc]init];
    mutArr =[[NSUserDefaults standardUserDefaults] objectForKey:FacebookGameFrindes];
    // self.arrMutableCopy = [mutArr mutableCopy];
    if (mutArr.count<1) {
//        [GameState sharedState].friendsScoreArray = nil;
        return;
    }
    // NSLog(@"level%d",levelSelected);
    NSString *fbID = [[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID];
    NSArray *allAry = [mutArr arrayByAddingObject:[NSString stringWithFormat:@"%@",fbID]];
    PFQuery *query = [PFQuery queryWithClassName:ParseScoreTableName];
    [query whereKey:@"Level" equalTo:[NSNumber numberWithInteger:levelSelected]];
    [query whereKey:@"PlayerFacebookID" containedIn:allAry];
    [query orderByDescending:@"Score"];
    
    for (UIView *subView in [secondView subviews]){
        subView.hidden = YES;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSArray *ary = [query findObjects];
        
        [GameState sharedState].friendsScoreArray = [NSArray arrayWithArray:ary];
        
        // NSLog(@"Ary == %@",ary);
        
        CGFloat y = 60;
        for (int i =0; i<ary.count; i++) {
            if (i == 3) {
                break;
            }
            PFObject *obj = [ary objectAtIndex:i];
            //  NSLog(@"PFOBJEct -==- %@",obj);
            
            NSNumber *score_saved = obj[@"Score"];
            NSString *name = obj[@"Name"];
            NSString *player1 = obj[@"PlayerFacebookID"];
            NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",player1]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImageView *aimgeView = (UIImageView*)[secondView viewWithTag:100+i];
                UILabel *label = (UILabel*)[secondView viewWithTag:300+i];
                UILabel *positinLabel = (UILabel*)[secondView viewWithTag:3000+i];
                
                if (aimgeView == nil) {
                    UIImageView *profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, y+(i*40), 35, 35)];
                    profileImageView.tag = 100+i;
                    [profileImageView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
                    [profileImageView.layer setBorderWidth: 2.0];
                    
                    [secondView addSubview:profileImageView];
                    [profileImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"58.png"]];
                }
                else{
                    aimgeView.hidden = NO;
                    [aimgeView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"58.png"]];
                }
                
                if (label==nil) {
                    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(48, y+(i*40), 125, 35)];
                    infoLabel.tag = 300+i;
                    infoLabel.backgroundColor = [UIColor clearColor];
                    infoLabel.font = [UIFont systemFontOfSize:10];
                    infoLabel.numberOfLines = 0;
                    infoLabel.text = [NSString stringWithFormat:@"%@\n%@",name,score_saved];
                    [secondView addSubview:infoLabel];
                    
                }
                else{
                    label.hidden = NO;
                    label.text = [NSString stringWithFormat:@"%@\n%@",name,score_saved];
                    
                }
                
                if (positinLabel==nil) {
                    UILabel *position = [[UILabel alloc] initWithFrame:CGRectMake(140, y+(i*40), 30, 45)];
                    position.tag = 3000+i;
                    position.backgroundColor = [UIColor clearColor];
                    position.font = [UIFont boldSystemFontOfSize:13];
                    position.numberOfLines = 0;
                    position.textColor = [UIColor blueColor];
                    positinLabel.textAlignment = NSTextAlignmentRight;
                    position.lineBreakMode = NSLineBreakByCharWrapping;
                    position.text = [NSString stringWithFormat:@"%d",i+1];
                    [secondView addSubview:position];
                }
                else{
                    positinLabel.hidden = NO;
                    positinLabel.text = [NSString stringWithFormat:@"%d",i+1];
                }
                
            });
            
        }
        
    });
}

#pragma mark- find friends current level

-(void)displayFriendsListUI{
    
    NSMutableArray *mutArr1 = [[NSMutableArray alloc]init];
    mutArr1 =[[NSUserDefaults standardUserDefaults] objectForKey:FacebookGameFrindes];
    if(!self.friendsView)
    {
        self.friendsView=[[UIView alloc]init];
        if([UIScreen mainScreen].bounds.size.height<500)
        {
            self.friendsView.frame=CGRectMake(10, 320, 295, 160);
        }
        else{
            self.friendsView.frame=CGRectMake(10, 400, 295, 160);
        }
        //self.friendsView.backgroundColor=[UIColor colorWithRed:(CGFloat)183/255 green:(CGFloat)222/255 blue:(CGFloat)243/255 alpha:0.7];
        self.friendsView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"friends_level.png"]];
        self.friendsView.layer.cornerRadius=4;
        self.friendsView.clipsToBounds=YES;
        [rootViewController.view addSubview:self.friendsView];
    }
    self.friendsView.hidden=NO;
    if(!self.bottomScroll)
    {
        self.bottomScroll=[[UIScrollView alloc]init];
        self.bottomScroll.frame=CGRectMake(0, 10, self.friendsView.frame.size.width,self.friendsView.frame.size.height);
        self.bottomScroll.backgroundColor=[UIColor clearColor];
        [self.friendsView addSubview:self.bottomScroll];
    }
    self.bottomScroll.hidden=NO;
    
    self.bottomScroll.contentSize=CGSizeMake(mutArr1.count*80, self.bottomScroll.frame.size.height);
}



-(void)findFriendsLevel{
    NSMutableArray *mutArr = [[NSMutableArray alloc]init];
    mutArr =[[NSUserDefaults standardUserDefaults] objectForKey:FacebookGameFrindes];
   // NSLog(@"MutArray %@",mutArr);
    if (mutArr.count<1) {
        return;
    }
    
    
    NSMutableArray * level=[[NSMutableArray alloc]init];
    NSMutableArray * name=[[NSMutableArray alloc]init];
    NSMutableArray * Id=[[NSMutableArray alloc]init];
    
    PFQuery * query=[PFQuery queryWithClassName:ParseScoreTableName];
    [query whereKey:@"PlayerFacebookID" containedIn:mutArr];
    [query orderByDescending:@"Level"];
//    NSArray * arr=[query findObjects];
//    NSLog(@"array ====== %@",arr);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray * arr=[query findObjects];
//        NSLog(@"detail of friends %@",arr);
        if (arr.count<1) {
            return ;
        }
        for (int j=0; j<arr.count; j++) {
            PFObject * obj=[arr objectAtIndex:j];
            for(int k=0;k<mutArr.count;k++)
            {
                if(![Id containsObject:obj[@"PlayerFacebookID"]])
                {
                    [level addObject:obj[@"Level"]];
                    [name addObject:obj[@"Name"]];
                    [Id addObject:obj[@"PlayerFacebookID"]];
                }
            }
        }
        
        NSLog(@"Level %@",level);
        NSLog(@"name is %@",name);
        NSLog(@"id is %@",Id);
        
        for(int i=0;i<level.count;i++)
        {
            NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",Id[i]]];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                UIImageView *aimgeView = (UIImageView*)[self.friendsView viewWithTag:100+i];
                UILabel *label = (UILabel*)[self.friendsView viewWithTag:300+i];
                UILabel *positionLabel=(UILabel*)[self.friendsView viewWithTag:3000+i];
                if (aimgeView == nil) {
                    UIImageView *profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+(i*90), 60, 35, 35)];
                    profileImageView.tag = 100+i;
                    profileImageView.tag = 100+i;
                    profileImageView.layer.borderWidth=2;
                    profileImageView.layer.borderColor=[[UIColor orangeColor]CGColor];
                    
                    [self.bottomScroll addSubview:profileImageView];
                    [profileImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"58x58.png"]];
                }
                else{
                    aimgeView.hidden = NO;
                    [aimgeView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"58x58.png"]];
                }
                if (label==nil) {
                    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10+(i*90), 100, 90, 35)];
                    infoLabel.tag = 300+i;
                    infoLabel.backgroundColor = [UIColor clearColor];
                    infoLabel.font = [UIFont systemFontOfSize:10];
                    infoLabel.numberOfLines = 0;
                    infoLabel.lineBreakMode = NSLineBreakByCharWrapping;
                    infoLabel.text = [NSString stringWithFormat:@"%@",name[i]];
                    [self.bottomScroll addSubview:infoLabel];
                    
                    [infoLabel sizeToFit];
                }
                else{
                    label.hidden = NO;
                    label.text = [NSString stringWithFormat:@"%@",name[i]];
                    [label sizeToFit];
                }
                
                
                if(positionLabel==nil)
                {
                    
                    
                    UILabel * position=[[UILabel alloc] initWithFrame:CGRectMake(35+(i*90), 30, 30, 45)];
                    position.tag = 3000+i;
                    position.textColor = [UIColor orangeColor];
                    position.backgroundColor=[UIColor clearColor];
                    [position setFont:[UIFont fontWithName:@"ShallowGraveBB" size:20]];
                    position.numberOfLines = 0;
                    position.lineBreakMode = NSLineBreakByCharWrapping;
                    position.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@", level[i]]];
                    [self.bottomScroll addSubview:position];
                    
                }
                else
                {
                    positionLabel.hidden=NO;
                    positionLabel.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@", level[i]]];
                    
                    
                }
                
                
            });
        }
    });
    
    
}

-(void) dealloc{
    
    [super dealloc];
}


@end
