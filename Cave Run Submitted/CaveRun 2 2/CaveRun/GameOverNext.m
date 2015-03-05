//
//  GameOverNext.m
//  CaveRun
//
//  Created by Sumit on 29/07/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import "GameOverNext.h"
#import "GameOverScene.h"
#import "cocos2d.h"
#import "GameMain.h"
#import "MainMenu.h"
#import "AppDelegate.h"
#import "GameState.h"
#import <FacebookSDK/FacebookSDK.h>
#import "LevelSelectionScene.h"
#import <RevMobAds/RevMobAds.h>
#import "SBJson.h"

#define RequestTOFacebook @"LifeRequest"
#define ShareToFacebook @"FacebookShare"

@implementation GameOverNext
@synthesize score1, gameOverSprite, menu1nex,bname,new_high,score,bg1,backgroundView,cancelButton,playButton,levellabel,beatlabel;
CGSize ws;

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

-(id) init
{
    if (self=[super init]) {
        
       
        
        NSLog(@"score in game over next is %d",score1);
        
        CGSize ws = [CCDirector sharedDirector].winSize;
        // NSLog(@"coin count==== %d",coinCount);
        ws=[[CCDirector sharedDirector]winSize];
        //create game over sprite
        self.gameOverSprite=[CCSprite spriteWithFile:@"blank_bg.png"];
        self.gameOverSprite.visible=NO;
        gameOverSprite.anchorPoint=ccp(0,0);
        gameOverSprite.position=ccp(ws.width==568?0:-(568-480)/2,0);
        self.gameOverSprite.visible=YES;
        [self addChild:self.gameOverSprite];
        [self createUI:[GameState sharedState].levelNumber];
        
        self.bg1=[CCSprite spriteWithFile:@"beaten_friends_score.png"];
        // bg1.anchorPoint=ccp(0,0);
        if([UIScreen mainScreen].bounds.size.height<500)
        {
        bg1.position=ccp(230,170);
        }else{
          bg1.position=ccp(270,170);
        }
       // [self addChild:self.bg1];
        
        score=[GameState sharedState].score_gn;
           NSString * pr_scoreh=[NSString stringWithFormat:@"New high Score !"];
        self.levelDisplay=[CCLabelTTF labelWithString:pr_scoreh fontName:@"Tumbleweed" fontSize:25];
        self.levelDisplay.anchorPoint=ccp(0,0);
        if([UIScreen mainScreen].bounds.size.height<500)
        {
        self.levelDisplay.position=ccp(85,200);
        }
        else{
            self.levelDisplay.position=ccp(122,200);
        }
        self.levelDisplay.color=ccRED;
        
        NSString * scoreFont1=[NSString stringWithFormat:@"%i",score1];
       CCLabelTTF * scoreFont=[CCLabelTTF labelWithString:scoreFont1 fontName:@"JFRocSol.TTF" fontSize:20];
        if ([UIScreen mainScreen].bounds.size.height<500) {
             scoreFont.position=ccp(ws.width/2+100,213);
        }
        else{
             scoreFont.position=ccp(ws.width/2+100,213);
        }
        scoreFont.color=ccRED;
        
        
        //normal score
        NSString * pr_scoren=[NSString stringWithFormat:@"Your Score "];
        self.for_score=[CCLabelTTF labelWithString:pr_scoren fontName:@"Tumbleweed" fontSize:25];
        
        self.for_score.anchorPoint=ccp(0,0);
        if ([UIScreen mainScreen].bounds.size.height<500) {
            self.for_score.position=ccp(110,210);
        }else{
             self.for_score.position=ccp(120,210);
        }
        
        self.for_score.color=ccRED;
        
        //NSString * scoreFont2=[NSString stringWithFormat:@"%i",score1];
        CCLabelTTF * scoreFont2lbl=[CCLabelTTF labelWithString:scoreFont1 fontName:@"JFRocSol.TTF" fontSize:20];
        scoreFont2lbl.anchorPoint=ccp(0,0);
        if ([UIScreen mainScreen].bounds.size.height<500) {
             scoreFont2lbl.position=ccp(ws.width/2+20,213);
        }
        else{
             scoreFont2lbl.position=ccp(ws.width/2+40,213);
        }
        
        scoreFont2lbl.color=ccRED;
        
            if(new_high)
        {
            [self addChild:scoreFont];

            [self addChild:self.levelDisplay];
  
        }
            else
            {
            [self addChild:self.for_score];
            [self addChild:scoreFont2lbl];

            }
        
        NSString *bprint = [NSString stringWithFormat:@"You beat %@ ",self.bname];
        self.levelDisplay1=[CCLabelTTF labelWithString:bprint fontName:@"Tumbleweed" fontSize:25];
        
        self.levelDisplay1.anchorPoint=ccp(0,0);
        if ([UIScreen mainScreen].bounds.size.height<500) {
           self.levelDisplay1.position=ccp(80,170);
        }
        else{
           self.levelDisplay1.position=ccp(120,170);
        }
        self.levelDisplay1.color=ccRED;
        //self.levelDisplay1.visible = YES;
        NSLog(@"self.bname is %@",self.bname);
        
        if (self.bname == NULL) {
            self.levelDisplay1.visible = NO;
            
        }else{
            self.levelDisplay1.visible = YES;
        }
        
        [self addChild:self.levelDisplay1];
        
        //Level number display
        NSString *level = [NSString stringWithFormat:@" Level %d ",[GameState sharedState].levelNumber];
        self.levelDisplay=[CCLabelTTF labelWithString:level fontName:@"RioGrandeStriped-Bold" fontSize:20];
        self.levelDisplay.color=ccRED ;
        [self addChild:self.levelDisplay];
        //self.levelDisplay.color=ccRED;
        self.levelDisplay.anchorPoint=ccp(0,0);
        if ([UIScreen mainScreen].bounds.size.height <500) {
             self.levelDisplay.position=ccp(ws.width/2-50,240);
        }else{
             self.levelDisplay.position=ccp(ws.width/2-50,240);
        }
       
        
        CCMenuItem *menuMainMenunex = [CCMenuItemImage itemFromNormalImage:@"next-2.png" selectedImage:@"next-2.png" target:self selector:@selector(nextAction:)];
        
       menu1nex = [CCMenu menuWithItems: menuMainMenunex, nil];
        if([UIScreen mainScreen].bounds.size.height<500)
        {
            menu1nex.position = ccp(ws.width/2+135, ws.height/2-130);
        }
        else{
            menu1nex.position = ccp(ws.width/2+135, ws.height/2-130);
        }
        [menu1nex alignItemsHorizontally];
        [menu1nex setVisible:true];
        [self addChild:menu1nex z:100];
        
        
        NSString *fbID = [[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID];
        
        int checkLevelClear = [[NSUserDefaults standardUserDefaults]integerForKey:@"LevelClear"];
        
        NSLog(@"fbid is %@",fbID);
        NSLog(@"checkLevelClear ====== %d",checkLevelClear);
        
        //facebook added now
        
        self.shareOnFb=[CCMenuItemImage itemFromNormalImage:@"share1.png" selectedImage:@"share1.png" target:self selector:@selector(facebookBtnClick)];
        
        self.shareButtons=[CCMenu menuWithItems:self.shareOnFb, nil];
        if([UIScreen mainScreen].bounds.size.height<500)
        {
            self.shareButtons.position=ccp(ws.width/2-70, 30);
        }
        else
        {
            self.shareButtons.position=ccp(ws.width/2-70, 30);
        }
        [self.shareButtons alignItemsHorizontally];
        
        [self addChild:self.shareButtons z:200];
        [self.shareButtons setVisible:YES];
        
        
        NSLog(@"score in gameover next is %d",score1);
        
        if (fbID ) {
           
            //if (checkLevelClear) {
               // [self saveScoreToParse:score1 forLevel:[GameState sharedState].levelNumber];
            //}
        }
        
    }
     return self;
}


#pragma mark-
#pragma mark-
- (void) createUI:(int)level{
    
    NSLog(@"level is %d",level);
    
    CGRect frame = [UIScreen mainScreen].bounds;
    if (self.backgroundView == nil) {
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.width)];
        //self.backgroundView.backgroundColor = [UIColor colorWithRed:(CGFloat)155/255 green:(CGFloat)155/255 blue:(CGFloat)155/255 alpha:1];
        self.backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"popupbg.png"]];
        [rootViewController.view addSubview:backgroundView];
        
        
        firstView = [[UIView alloc]initWithFrame:CGRectMake(170, 20, 245, 290)];
       // firstView.backgroundColor=[UIColor redColor];
        
        [firstView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"popup.png"]]];
        
        
        secondView = [[UIView alloc]initWithFrame:CGRectMake(10, 20, 180, 280)];
       [secondView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"highscore.png"]]];
       // secondView.backgroundColor=[UIColor redColor];
        [backgroundView addSubview:secondView];
        [backgroundView addSubview:firstView];
        
        
        self.cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(345, 13, 100, 50)];
        UIImage *cancelImage = [UIImage imageNamed:@"close.png"];
        [cancelButton setImage:cancelImage forState:UIControlStateNormal];
        [backgroundView addSubview:cancelButton];
        [cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.playButton = [[UIButton alloc]initWithFrame:CGRectMake(250, 200, 100, 50)];
        UIImage *btnImage = [UIImage imageNamed:@"play.png"];
        [playButton setImage:btnImage forState:UIControlStateNormal];
        
        [backgroundView addSubview:playButton];
        [playButton addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        levellabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 50, 100, 35)];
        levellabel.backgroundColor = [UIColor clearColor];
        levellabel.font = [UIFont systemFontOfSize:20];
        levellabel.numberOfLines = 0;
        levellabel.lineBreakMode = NSLineBreakByCharWrapping;
        levellabel.text = [NSString stringWithFormat:@"Level % d",level];
        [firstView addSubview:levellabel];
        
        beatlabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 80, 200, 35)];
        beatlabel.backgroundColor = [UIColor clearColor];
        beatlabel.font = [UIFont systemFontOfSize:20];
        beatlabel.numberOfLines = 0;
        beatlabel.lineBreakMode = NSLineBreakByCharWrapping;
        beatlabel.text = [NSString stringWithFormat:@"You beat %@",self.bname];
        [firstView addSubview:beatlabel];

        }
    else{
        self.backgroundView.hidden = NO;
        [rootViewController.view addSubview:backgroundView];
        levellabel.text = [NSString stringWithFormat:@"Level % d",level];
    }
}

-(void)playButtonAction:(id)sender{
    backgroundView.hidden=YES;
    backgroundView = nil;
    [[CCDirector sharedDirector]replaceScene:[CCTransitionFadeTR transitionWithDuration:1.0 scene:[GameMain scene]]];
    
}

-(void)cancelButtonAction:(id)sender{
    [backgroundView removeFromSuperview];
}


#pragma mark-next action .
#pragma mark======================

-(void)nextAction:(id)sender
{
    
    RevMobFullscreen *ad = [[RevMobAds session] fullscreen]; // you must retain this object
    [ad loadWithSuccessHandler:^(RevMobFullscreen *fs) {
        [fs showAd];
        //NSLog(@"Ad loaded Revmob");
        [[CCDirector sharedDirector] pause];
    } andLoadFailHandler:^(RevMobFullscreen *fs, NSError *error) {
        NSLog(@"Ad error Revmob: %@",error);
    } onClickHandler:^{
        //NSLog(@"Ad clicked Revmob");
    } onCloseHandler:^{
        //NSLog(@"Ad closed Revmob");
        [[CCDirector sharedDirector] resume];
    }];
    
    NSLog(@"level after clear -==-%i",[GameState sharedState].levelNumber);
    [GameState sharedState].levelNumber=[GameState sharedState].levelNumber+1;
    [[CCDirector sharedDirector]replaceScene:[CCTransitionFadeTR transitionWithDuration:0.5 scene:[GameMain scene]]];
    [userDefaults setInteger:[GameState sharedState].levelNumber forKey:@"level"];
    //NSLog(@"UserDefault Level After level Clear =-= %i",[userDefaults integerForKey:@"level"]);
    
    int level=(int)[userDefaults integerForKey:@"levelClear"];
    
    if ([GameState sharedState].levelNumber > level) {
        [userDefaults setInteger:[GameState sharedState].levelNumber forKey:@"levelClear"];
        [userDefaults synchronize];
    }
    
    [GameState sharedState].next=FALSE;
}


-(void) storyPostwithDictionary{
    
    //http://www.screencast.com/t/S0YR7HvL4L
     if ((FBSession.activeSession.isOpen)) {
    NSString *description = @"Enjoying a new exciting game NOW!";
         
    NSString *title = @"Playing Cave run";
    NSString *type = @"cave_run";
    NSString *actionType = @"me/caverunapp_:play";
    NSLog(@"Type = %@", type);
    NSLog(@"Action  =%@",actionType);
    
    
    id<FBGraphObject> object =
    [FBGraphObject openGraphObjectForPostWithType:[NSString stringWithFormat:@"caverunapp_:%@",type] title:title image:@"fbstaging://graph.facebook.com/staging_resources/MDExNDQyNjIzMzQyNjc3NjM2OjUxMDY4MTkwNg==" url:@"http://www.globusgames.com/" description:description];
    
    id<FBOpenGraphAction> action = (id<FBOpenGraphAction>)[FBGraphObject graphObject];
    [action setObject:object forKey:type];
    
    // create action referencing user owned object
    [FBRequestConnection startForPostWithGraphPath:actionType graphObject:action completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if(!error) {
            NSLog(@"OG story posted, story id: %@", [result objectForKey:@"id"]);
            [[[UIAlertView alloc] initWithTitle:@"OG story posted" message:@"Check your Facebook profile or activity log to see the story." delegate:self cancelButtonTitle:@"OK!"otherButtonTitles:nil] show];
            
        } else {
            // An error occurred
            NSLog(@"Encountered an error posting to Open Graph: %@", error);
        }
    }];
    
     }
}

#pragma mark - facebook action . 
#pragma mark =================

-(void)facebookBtnClick {
        
    self.strPostMessage = [NSString stringWithFormat:@"Completed Level %i  with a of scored %i!",[GameState sharedState].levelNumber,score1];
        NSLog(@"Message == %@",self.strPostMessage);
    NSString *strLife = [NSString stringWithFormat:@"Level %d",[GameState sharedState].levelNumber];
        
        NSMutableDictionary *params =
        [NSMutableDictionary dictionaryWithObjectsAndKeys:
         self.strPostMessage, @"description", strLife, @"caption",
         @"https://globussoft.com", @"link",@"Cave Run Mowgli",@"name",
           @"http://www.screencast.com/t/p1RVahoirtCR",@"picture",
         nil];
        
        NSDictionary *storyDict = [NSDictionary dictionaryWithObjectsAndKeys:@"level",FacebookType,[NSString stringWithFormat:@"Completed %@",strLife],FacebookTitle,self.strPostMessage,FacebookDescription,@"complete",FacebookActionType, nil];
        
        appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDelegate.delegate = nil;
        appDelegate.openGraphDict = storyDict;
    
    
        if (FBSession.activeSession.isOpen) {
            
            [appDelegate shareOnFacebookWithParams:params];
        }
        else{
            [appDelegate openSessionWithLoginUI:1 withParams:params];
        }
    
    if (bname.length>1 && bname != NULL) {
        [self schedule:@selector(beatFriendStoryPost) interval:1.2];
    }
    if (new_high) {
         [self schedule:@selector(newHighScoreStoryPost) interval:1.2];
    }
        
}
    
-(void) newHighScoreStoryPost{
        [self unschedule:@selector(newHighScoreStoryPost)];
        NSString *title = [NSString stringWithFormat:@"new highscore %d",score1];
        NSString *description = [NSString stringWithFormat:@"Hey i got new highscore %d in level %d",score1,[GameState sharedState].levelNumber];
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"highscore",FacebookType,title,FacebookTitle,description,FacebookDescription,@"set",FacebookActionType, nil];
        
        appDelegate.openGraphDict = dict;
        
        [appDelegate storyPostwithDictionary:dict];
    }

-(void) beatFriendStoryPost{
        
        [self unschedule:@selector(beatFriendStoryPost)];
        NSString *title = [NSString stringWithFormat:@"beat %@",bname];
        
        NSString *description = [NSString stringWithFormat:@"%@ at level %d and made score %d!",title,[GameState sharedState].levelNumber,score1];
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"friend",FacebookType,title,FacebookTitle,description,FacebookDescription,@"beat",FacebookActionType, nil];
        
        appDelegate.openGraphDict = dict;
        [appDelegate storyPostwithDictionary:dict];
    
}

//method 2
-(void) shareOnFacebook{
    
    self.strPostMessage = [NSString stringWithFormat:@"I cleared Level %i  and scored %d points.",[GameState sharedState].levelNumber,self.score1];
    
    
    NSLog(@"Message == %@",self.strPostMessage);
    NSString *strLife = [NSString stringWithFormat:@"Level %d",[GameState sharedState].levelNumber];
    
    NSMutableDictionary *params =
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     self.strPostMessage, @"description", strLife, @"caption",
     @"http://www.globussoft.com/", @"link",@"Cave Run",@"name",
     nil];
    //provides webdialog for apprequest.
        [FBWebDialogs presentFeedDialogModallyWithSession:nil parameters:params handler:^(FBWebDialogResult result, NSURL *resultUrl, NSError *error){
        
        if (error) {
            NSLog(@"Error to post on facebook = %@", [error localizedDescription]);
        }
        else{
            
            [[NSNotificationCenter defaultCenter] removeObserver:self name:ShareToFacebook object:nil];
            

            if (result == FBWebDialogResultDialogNotCompleted) {
                NSLog(@"Error to post on facebook = %@", [error localizedDescription]);
                NSLog(@"User cancel Request");
            }//End Result Check
            else{
                NSString *sss= [NSString stringWithFormat:@"%@",resultUrl];
                if ([sss rangeOfString:@"post_id"].location == NSNotFound) {
                    NSLog(@"User Cancel Share");
                }
                else{
                    NSLog(@"posted on wall");
                }
            }
        }
    }];
}




@end
