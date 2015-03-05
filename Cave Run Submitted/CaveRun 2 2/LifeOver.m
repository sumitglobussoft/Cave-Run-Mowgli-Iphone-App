//
//  LifeOver.m
//  BowHunting
//
//  Created by Sumit Ghosh on 26/03/14.
//  Copyright (c) 2014 tang. All rights reserved.
//

#import "LifeOver.h"
#import "Clouds.h"
#import "GameIntro.h"
#import "AppDelegate.h"
#import "SBJson.h"
#import <RevMobAds/RevMobAds.h>

#define RequestTOFacebook @"LifeRequest"

@implementation LifeOver
@synthesize lblNextLifeTime,timeText,menuAskFrnd,lblMoreLifeNow,menuMoreLife,menuBack;

CGSize ws;

-(id) init
{
	if( (self=[super init])) {
        
        ws=[[CCDirector sharedDirector]winSize];
        
        //create sky etc..
        
        
        RevMobFullscreen *ad = [[RevMobAds session] fullscreen]; // you must retain this object
        [ad loadWithSuccessHandler:^(RevMobFullscreen *fs) {
            [fs showAd];
            NSLog(@"Ad loaded Revmob");
            [[CCDirector sharedDirector] pause];
        } andLoadFailHandler:^(RevMobFullscreen *fs, NSError *error) {
            NSLog(@"Ad error Revmob: %@",error);
        } onClickHandler:^{
            NSLog(@"Ad clicked Revmob");
        } onCloseHandler:^{
            NSLog(@"Ad closed Revmob");
            [[CCDirector sharedDirector] resume];
        }];

        
        CCSprite *sky=[CCSprite spriteWithFile:@"gameOverSky.png"];
        sky.position=ccp(ws.width/2,ws.height/2);
        [self addChild:sky];
        
        Clouds *c=[[Clouds alloc]init];
        c.position=ccp(0,ws.height);
        [self addChild:c];
        
        CCMenuItemImage *imageNomorelives = [CCMenuItemImage itemWithNormalImage:@"no more lives button.png" selectedImage:@"no more lives button.png"];
        imageNomorelives.position=ccp(ws.width/2,ws.height/2+110);
        [self addChild:imageNomorelives];
        
        self.lblNextLifeTime=[CCLabelBMFont labelWithString:@"Time to next life" fntFile:@"BerlinSansFBDemiGOSFFFFFF.fnt"];
        self.lblNextLifeTime.position=ccp(ws.width/2-20,ws.height/2+50);
        [self addChild:self.lblNextLifeTime];
        
       userDefault = [NSUserDefaults standardUserDefaults];
       remTime = [userDefault integerForKey:@"timeRem"];
        
        if (remTime) {
            
            min=remTime/60;
            sec=remTime%60;
            
            if (sec<10) {
                self.timeText=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%i: 0%i",min,sec] fntFile:@"BerlinSansFBDemiGOSFFFFFF.fnt"];
            }
            else{
                self.timeText=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%i: %i",min,sec] fntFile:@"BerlinSansFBDemiGOSFFFFFF.fnt"];
            }
            self.timeText.position=ccp(ws.width/2,ws.height/2+20);
            [self addChild:self.timeText];
            
            [self schedule:@selector(update) interval:1];
        }
        
        CCMenuItem *menuItemAskFrnds = [CCMenuItemImage itemWithNormalImage:@"ask friends.png" selectedImage:@"ask friends.png" target:self selector:@selector(askFrndsButtonClicked:)];
        
        menuAskFrnd = [CCMenu menuWithItems: menuItemAskFrnds, nil];
        menuAskFrnd.position = ccp(ws.width/2, 120);
        [menuAskFrnd alignItemsHorizontally];
        [self addChild:menuAskFrnd z:100];
        
        CCMenuItem *menuItemMoreLife = [CCMenuItemImage itemWithNormalImage:@"more lives now.png" selectedImage:@"more lives now.png" target:self selector:@selector(moreLivesButtonClicked:)];
        
        menuMoreLife = [CCMenu menuWithItems: menuItemMoreLife, nil];
        menuMoreLife.position = ccp(ws.width/2, 50);
        [menuMoreLife alignItemsHorizontally];
        [self addChild:menuMoreLife z:100];
        
        CCMenuItem *menuItemBack = [CCMenuItemImage itemWithNormalImage:@"back.png" selectedImage:@"back.png" target:self selector:@selector(back:)];
        
        menuBack = [CCMenu menuWithItems: menuItemBack, nil];
        menuBack.position = ccp(40, ws.height-35);
        [menuBack alignItemsHorizontally];
        [self addChild:menuBack z:100];
    }
    return self;
}
- (void)update {
    
    remTime--;
    
    int minute = remTime/60;
    int second = remTime%60;
    
    if (second<10) {
        [self.timeText setString:[NSString stringWithFormat:@"%i:0%i",minute,second]];
    }
    else{
        [self.timeText setString:[NSString stringWithFormat:@"%i:%i",minute,second]];
    }
    
    if (remTime==0) {
        [self unschedule:@selector(update)];
        
        int life = [userDefault integerForKey:@"life"];
        
        life++;
        
        [userDefault setInteger:life forKey:@"life"];
        [userDefault setObject:@"0" forKey:@"currentDate"];
        [userDefault synchronize];
        
        remTime=1800;
        
        [self.timeText setString:[NSString stringWithFormat:@"30:00"]];
        
        [self schedule:@selector(update) interval:1];
        
        NSString *str =[userDefault objectForKey:@"currentDate"];
        
        if (life<5 && [str isEqualToString:@"0"]) {
         
            NSDate* now = [NSDate date];
            NSLog(@"%@ seconds since recevedData was called last", now);
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
            NSString *dateStr = [df stringFromDate:now];
            
            [userDefault setObject:dateStr forKey:@"currentDate"];
        }
    }
}

#pragma mark
#pragma mark Button methods
#pragma mark ==============================================

-(void)back:(id)sender {
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameIntro scene]]];
}

-(void)askFrndsButtonClicked:(id)sender {
    NSLog(@"Ask Friends Button Click");
    AppController * appDelegate = (AppController *)[UIApplication sharedApplication].delegate;
    
    if (FBSession.activeSession.isOpen) {
        
        [self sendRequestToFrnds];
    }
    else{
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendRequestToFrnds) name:RequestTOFacebook object:nil];
        [appDelegate openSessionWithAllowLoginUI:2];
    }
}

-(void)moreLivesButtonClicked:(id)sender {
    
    
    self.menuAskFrnd.visible=NO;
    self.menuMoreLife.visible=NO;
    self.menuBack.visible=NO;
    
    if(!self.storeLayer){
        self.storeLayer=[[Store alloc]init];
        [self addChild:self.storeLayer];
    }
    else{
        ((Store*)self.storeLayer).visible=YES;
    }
    
    NSLog(@"More Lives Button Click");
}

#pragma mark
#pragma mark Send REquest to friends method
#pragma mark ==============================================

-(void) sendRequestToFrnds{
    
//    int level = [userDefault integerForKey:@"level"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSDictionary *challenge =  [NSDictionary dictionaryWithObjectsAndKeys: [NSString stringWithFormat:@"Life Request"], @"message", nil];
    NSString *lifeReq = [jsonWriter stringWithObject:challenge];
    
    
    // Create a dictionary of key/value pairs which are the parameters of the dialog
    
    // 1. No additional parameters provided - enables generic Multi-friend selector
    NSMutableDictionary* params =   [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     // 2. Optionally provide a 'to' param to direct the request at a specific user
                                     //@"286400088", @"to", // Ali
                                     // 3. Suggest friends the user may want to request, could be game context specific?
                                     //[suggestedFriends componentsJoinedByString:@","], @"suggestions",
                                     lifeReq, @"data",
                                     nil];
    
    [FBWebDialogs presentRequestsDialogModallyWithSession:nil message:@"Request for Life" title:@"Live Request" parameters:params handler:^(FBWebDialogResult result, NSURL *resultUrl, NSError *error){
        
        if (error) {
            // Case A: Error launching the dialog or sending request.
            NSLog(@"Error sending request.==%@",[error localizedDescription]);
        } else {
            
            [[NSNotificationCenter defaultCenter] removeObserver:self name:RequestTOFacebook object:nil];
            NSLog(@"Result url==%@",resultUrl);
            //==========================================================
            
            //On Cancel
            // Result url==fbconnect://success?error_code=4201&error_message=User+canceled+the+Dialog+flow
            
            //On Send
            //Result url==fbconnect://success?request=532786970172029&to%5B0%5D=100004995941963
            //===========================================================
            if (result == FBWebDialogResultDialogNotCompleted) {
                // Case B: User clicked the "x" icon
                NSLog(@"User canceled request.");
            } else {
                
                NSLog(@"Request Sent.");
            }//End Else Block
        }//End else block error check
    }];// end FBWebDialogs
}

-(void)dealloc {

    [super dealloc];
}
@end
