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
@synthesize score1, gameOverSprite, menu1nex,bname ;
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
        self.gameOverSprite=[CCSprite spriteWithFile:@"background_1-1.png"];
        self.gameOverSprite.visible=NO;
        gameOverSprite.anchorPoint=ccp(0,0);
        gameOverSprite.position=ccp(ws.width==568?0:-(568-480)/2,0);
        self.gameOverSprite.visible=YES;
        [self addChild:self.gameOverSprite];
        
    //NSString *fname = [NSString stringWithFormat:@"in the Level %d",[GameState sharedState].levelNumber];
        
        self.levelDisplay=[CCLabelTTF labelWithString:@"You create new high score" fontName:@"JFRocSol.TTF" fontSize:20];
    
        self.levelDisplay.anchorPoint=ccp(0,0);
        self.levelDisplay.position=ccp(200,200);
        self.levelDisplay.visible=NO;
        [self addChild:self.levelDisplay];
        
      /*
        int bestscore1 = [[NSUserDefaults standardUserDefaults]integerForKey:@"bestScore"];
        NSString *bscore = [NSString stringWithFormat:@"Best Score is %d", bestscore1];
        self.bestScore=[CCLabelTTF labelWithString:bscore fontName:@"JFRocSol.TTF" fontSize:20];
        
        self.bestScore.anchorPoint=ccp(0,0);
        self.bestScore.position=ccp(100,100);
        self.bestScore.visible=YES;
        [self addChild:self.bestScore];
      */  
        
        NSString *bprint = [NSString stringWithFormat:@"You beat %@ ",self.bname];
        self.levelDisplay1=[CCLabelTTF labelWithString:bprint fontName:@"JFRocSol.TTF" fontSize:20];
       
        self.levelDisplay1.anchorPoint=ccp(0,0);
        self.levelDisplay1.position=ccp(50,160);
       // self.levelDisplay1.color=ccRED;
        // self.levelDisplay1.visible = YES;
        NSLog(@"self.bname is %@",self.bname);
        
        if (self.bname == NULL) {
             self.levelDisplay1.visible = NO;
           
        }else{
             self.levelDisplay1.visible = YES;
        }
       
        [self addChild:self.levelDisplay1];
        
        
        NSString *level = [NSString stringWithFormat:@"In the Level %d ",[GameState sharedState].levelNumber];
        self.levelDisplay=[CCLabelTTF labelWithString:level fontName:@"JFRocSol.TTF" fontSize:20];
       [self addChild:self.levelDisplay];
         //self.levelDisplay.color=ccRED;
        self.levelDisplay.anchorPoint=ccp(0,0);
        self.levelDisplay.position=ccp(100,200);
        
        CCMenuItem *menuMainMenunex = [CCMenuItemImage itemFromNormalImage:@"next.png" selectedImage:@"next.png" target:self selector:@selector(nextAction:)];
        
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
#pragma mark - parse code. 
#pragma mark=================

-(void) saveScoreToParse:(NSInteger)score forLevel:(NSInteger)level{
    
    NSLog(@"score in parse is== %d",score);
    NSLog(@"level in parse is== %d",level);
    
    
  //  UINavigationController * rootViewController = (UINavigationController*)[(AppDelegate*)[[UIApplication sharedApplication] delegate] getRootViewController];
    
    NSString *fbID = [[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID];
    
    NSString *strCheckFirstRun = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"levelFirstRun%d",[GameState sharedState].levelNumber ]];
    //  strCheckFirstRun=nil;
    if (!strCheckFirstRun) {
        
        NSLog(@"First time in level................................yes");
        [[NSUserDefaults standardUserDefaults] setObject:@"hello" forKey:[NSString stringWithFormat:@"levelFirstRun%d",[GameState sharedState].levelNumber ]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (fbID) {//if3
            NSLog(@"Current Level == %d",(int)level);
            NSLog(@"Level Score == %d",(int)score);
            NSLog(@"score1 is %d",score1);
            
            PFObject *object = [PFObject objectWithClassName:ParseScoreTableName];
            object[@"PlayerFacebookID"] = fbID;
            object[@"Level"] = [NSString stringWithFormat:@"%d",(int)level];
            object[@"Score"] = [NSNumber numberWithInteger:score];
            object[@"Name"] =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey: @"ConnectedFacebookUserName"]];
           
            NSLog(@"%@",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey: @"ConnectedFacebookUserName"]]);
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [object saveEventually:^(BOOL succeed, NSError *error){
                    
                    if (succeed) {
                        NSLog(@"Save to Parse");
                        
                        [self retriveFriendsScore:level andScore:score1];
                    }
                    if (error) {
                        NSLog(@"Error to Save == %@",error.localizedDescription);
                    }
                }];
            });
        }//if3
        else{
            
            [self retriveFriendsScore:level andScore:score1];
            
        }
        
    }
    else{
        NSLog(@"delete row................yes ");
        [self deleteRow];
        if (self.score1 > self.a)  {
            NSLog(@"self.score1 is %d",self.score1);
             NSLog(@"self.a is %d",self.a);
            
        
        NSLog(@"delete row................yes ");
        // [self deleteRow];
        /*
        NSNumber *num =  [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"Score%d",[GameState sharedState].levelNumber ]];
        NSLog(@"delete old score that is %@",num);
        self.s = [self.str intValue];
        int levelScore = [num intValue];
        
        NSLog(@"self.score1 is =-=-=-= %d",self.score1);
        
        if (self.score1 > levelScore) {//if2
            NSLog(@"score is greater than old score %@",num);
            [self deleteRow];
*/
            if (fbID) {
                NSLog(@"Current Level == %d",(int)level);
                NSLog(@"Level Score == %d",(int)score);
                
                PFObject *object = [PFObject objectWithClassName:ParseScoreTableName];
                object[@"PlayerFacebookID"] = fbID;
                object[@"Level"] = [NSString stringWithFormat:@"%d",(int)level];
                object[@"Score"] = [NSNumber numberWithInteger:score];
                object[@"Name"] =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey: @"ConnectedFacebookUserName"]];
                
                NSLog(@"%@",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey: @"ConnectedFacebookUserName"]]);
                
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [object saveEventually:^(BOOL succeed, NSError *error){
                        
                        if (succeed) {
                           
                            NSLog(@"Save to Parse");
                            /*
                            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:score] forKey:[NSString stringWithFormat:@"Score%d",[GameState sharedState].levelNumber ]];
                            [[NSUserDefaults standardUserDefaults]synchronize];
                            */
                            [self retriveFriendsScore:level andScore:score1];
                        }
                        if (error) {
                            NSLog(@"Error to Save == %@",error.localizedDescription);
                        }
                    }];
                });
            }
            else{
                
                [self retriveFriendsScore:level andScore:score1];
                
                
            }
            
        }
      
        
    }
}


-(void)deleteRow{
    
    NSMutableArray *mt=[[NSMutableArray alloc] init];
    
    NSString *fbID = [[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID];
    PFQuery *query = [PFQuery queryWithClassName:ParseScoreTableName];
    [query whereKey:@"PlayerFacebookID" equalTo:fbID];
    [query whereKey:@"Level" equalTo:[NSString stringWithFormat:@"%d",[GameState sharedState].levelNumber]];
    NSArray *aryCount=[query findObjects];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int i =0; i<aryCount.count; i++) {
            
            PFObject *obj = [aryCount objectAtIndex:i];
            NSLog(@"PFOBJEct -==- %@",obj);
            
            NSNumber *scoreOld = obj[@"Score"];
            NSLog(@"score old is %@",scoreOld);
            
            [mt addObject:[NSString stringWithFormat:@"%d", [scoreOld intValue]]];
        }
    });
    
    NSLog(@"query count is =-=-=-=-=-=-=-=- %d",[query countObjects]);
  //  NSNumber * max1 = [mt valueForKeyPath:@"@max.intValue"];
    
    int max1 = [[mt valueForKeyPath:@"@max.intValue"] intValue];
    NSLog(@"max value in array is %d",max1);
    
    self.a=max1;
    NSLog(@"int a value %d",self.a);
    
    self.s=[self.str intValue];
    
    NSLog(@"int s value %d",self.s);
    if (self.score1 > self.a) {
        
        PFQuery *query1 = [PFQuery queryWithClassName:ParseScoreTableName];
        [query1 whereKey:@"PlayerFacebookID" equalTo:fbID];
        [query1 whereKey:@"Level" equalTo:[NSString stringWithFormat:@"%d",[GameState sharedState].levelNumber]];
        [query1 findObjects];
        [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded.
                NSLog(@"Successfully retrieved %d scores.", objects.count);
                // Do something with the found objects
                for (PFObject *object in objects) {
                    [object deleteInBackground];
                }
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
}



//delete row new......
/*

-(void)deleteRow{
    
    NSString *fbID = [[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID];
    
    NSLog(@"delete in background");
//
    if(fbID){
    
    NSLog(@"score is greater than old score ");
    PFQuery *query1 = [PFQuery queryWithClassName:ParseScoreTableName];
    [query1 whereKey:@"PlayerFacebookID" equalTo:fbID];
    [query1 whereKey:@"Level" equalTo:[NSString stringWithFormat:@"%d",[GameState sharedState].levelNumber]];
        [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                [object deleteInBackground];
                NSLog(@"deletd");
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}

}
*/

-(void) retriveFriendsScore:(NSInteger)level andScore:(NSInteger)score{
    
    NSLog(@"score in parse is== %d",score);
    
    NSLog(@"level in parse is== %d",level);

    
    NSMutableArray *mutArr = [[NSMutableArray alloc]init];
    
    mutArr =[[NSUserDefaults standardUserDefaults] objectForKey:FacebookGameFrindes];
    
    self.arrMutableCopy = [mutArr mutableCopy];
    
    NSString *strUserFbId = [[NSUserDefaults standardUserDefaults]objectForKey:ConnectedFacebookUserID];
    NSLog(@"-------------------strUserFbID %@----------------------",strUserFbId);
    
    NSNumber *numFbIdUser =  [NSNumber numberWithLongLong:[strUserFbId longLongValue]];
    NSLog(@"---------------------numFbIdUser %@ ----------------",numFbIdUser);
    
    
    if (![self.arrMutableCopy containsObject:strUserFbId]) {
        [self.arrMutableCopy addObject:strUserFbId];
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        self.currentLevel = level;
        
        NSString *strLevel = [NSString stringWithFormat:@"%d",level];
        NSLog(@"strlevel is %@",strLevel);
        
        
        PFQuery *query = [PFQuery queryWithClassName:ParseScoreTableName];
        
        [query whereKey:@"Level" equalTo:strLevel];
        
        [query whereKey:@"PlayerFacebookID" containedIn:self.arrMutableCopy];
        //[query whereKey:@"Score" lessThan:[NSNumber numberWithInteger:score]];
        //[query orderByAscending:@"Score"];
        
        NSArray *ary = [query findObjects];
        [query orderByDescending:@"Score"];
        NSLog(@"query count is **************** %d",[query countObjects]);
        
        
        if (ary.count < 1) {
            isNewHighScore = YES;
            NSLog(@"New High Score array count less than 1");
            NSLog(@"Not contain any Object");
            return;
        }
        
        else{
            NSLog(@"i am in else condition");
            self.mutArray=[[NSMutableArray alloc] init];
            
            //Commented by me at 16 july
            
            self.mutArrScores = [[NSMutableArray alloc] init];
            
            isNewHighScore = NO;
            for (int i =0; i<ary.count; i++) {
                //                NSLog(@"count %d",ary[i]);
                PFObject *obj = [ary objectAtIndex:i];
                NSLog(@"PFOBJEct -==- %@",obj);
                NSNumber *scoreOld = obj[@"Score"];
                
                NSLog(@"score is------------------%@",scoreOld);
                [self.mutArray addObject:scoreOld];
                
                NSLog(@"score here is %d",score);
                
                
                if (score==[self.mutArray[0] intValue]) {
                    isNewHighScore = YES;
                }
                NSNumber *fbId = obj[@"PlayerFacebookID"];
                
                NSLog(@"fbId is %@",fbId);
                
                NSString *name=obj[@"Name"];
                //            NSLog(@"Score Old -==- %@",scoreOld);
                
                int storeScore = [scoreOld intValue];
                NSLog(@"storescore is =-=-=-= %d",storeScore);
                
                if (score < storeScore) {
                    [self.mutArrScores addObject:scoreOld];
                }
                else{
                    
                    
                                       
                    if (self.mutArrScores.count == 0) {
                        isNewHighScore = YES;
                        NSLog(@"You create new high Score.");
                    
                        self.levelDisplay.visible=YES;
                        
                        if ([fbId longLongValue]== [numFbIdUser longLongValue]) {
                            
                            
                        }
                        else{
                            NSLog(@"Beated friend name is %@ ",name);
                            NSLog(@"fbid is =-=-=-=-=-=-=- %@ ",fbId);
                            break;
                        }

                   
                        }
                    
                    
            
                  else{
                      
                     
                        if ([fbId longLongValue]== [numFbIdUser longLongValue]) {
                            
                        }
                      
                        else{
                            
                            NSLog(@"Beated friend name is %@ ",name);
                            break;
                            }
                            return;
                        }
                    }
            }
          //  secondHighScore = [ary objectAtIndex:0];
        }      //close else
    });
    
    
    // ===============================================================================
    if (score==[self.mutArray[0] intValue] ) {
        NSLog(@"............................You got higest position.................................................");
    }
}


-(void)retriveFriendName{
    NSNumber * max = [self.mutscoreArray valueForKeyPath:@"@max.intValue"];
    NSLog(@"max====== %@",max);
    NSString *name;
    if (self.mutscoreArray.count>0&&self.mutFBidArray.count>0) {
        
        NSNumber * max = self.mutscoreArray[0] ;
        for (int i=0; i<self.mutscoreArray.count; i++) {
            if (self.mutscoreArray[i]>max) {
                max = self.mutscoreArray[i];
                
                name=self.mutFBidArray[i];
            }
        }
        self.levelDisplay=[CCLabelTTF labelWithString:name fontName:@"JFRocSol.TTF" fontSize:30];
        
        NSLog(@"you beat name is=== %@",name);
        //        NSLog(@"You beat to the %@ at level  %d",name,[GameState sharedState].levelNumber);
        //
    }
}

#pragma mark-next action . 
#pragma mark======================

-(void)nextAction:(id)sender
{
    
    NSLog(@"level after clear -==-%i",[GameState sharedState].levelNumber);
    [GameState sharedState].levelNumber=[GameState sharedState].levelNumber+1;
    [[CCDirector sharedDirector]replaceScene:[CCTransitionFadeTR transitionWithDuration:0.5 scene:[GameMain scene]]];
    [userDefaults setInteger:[GameState sharedState].levelNumber forKey:@"level"];
    NSLog(@"UserDefault Level After level Clear =-= %i",[userDefaults integerForKey:@"level"]);
    
    int level=[userDefaults integerForKey:@"levelClear"];
    
    if ([GameState sharedState].levelNumber > level) {
        [userDefaults setInteger:[GameState sharedState].levelNumber forKey:@"levelClear"];
        [userDefaults synchronize];
    }
    
    [GameState sharedState].next=FALSE;
}

#pragma mark - facebook action . 
#pragma mark =================

-(void)facebookBtnClick {
    
    [self retriveFriendName];
    NSLog(@"Facebook share Button Clicked...");
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //  appDelegate.delegate=self;
    
    if (FBSession.activeSession.isOpen) {
        
        [self shareOnFacebook];
    }
    else{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareOnFacebook) name:ShareToFacebook object:nil];
        [appDelegate openSessionWithAllowLoginUI:1];
    }
    
}

//method 2
-(void) shareOnFacebook{
    //---------------------------------------
    //  [GameState sharedState].levelNumber=[GameState sharedState].levelNumber+1;
    [GameState sharedState].levelNumber=1;
    self.strPostMessage = [NSString stringWithFormat:@"I cleared Level %i  and scored %d points.",[GameState sharedState].levelNumber,self.score1];
    
    //    self.strPostMessage=[NSString stringWithFormat:@"i have scored %@ points.",self.totalScoreText];
    
    NSLog(@"Message == %@",self.strPostMessage);
    NSString *strLife = [NSString stringWithFormat:@"Level %d",[GameState sharedState].levelNumber];
    
    NSMutableDictionary *params =
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     self.strPostMessage, @"description", strLife, @"caption",
     @"http://www.globussoft.com/", @"link",@"Cave Run",@"name",
     nil];
    //provides webdialog for apprequest.
    //
    [FBWebDialogs presentFeedDialogModallyWithSession:nil parameters:params handler:^(FBWebDialogResult result, NSURL *resultUrl, NSError *error){
        
        if (error) {
            NSLog(@"Error to post on facebook = %@", [error localizedDescription]);
        }
        else{
            
            [[NSNotificationCenter defaultCenter] removeObserver:self name:ShareToFacebook object:nil];
            
            NSLog(@"result==%u",result);
            NSLog(@"Url==%@",resultUrl);
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
            }//End Else Block Result Check
        }
    }];
}




@end
