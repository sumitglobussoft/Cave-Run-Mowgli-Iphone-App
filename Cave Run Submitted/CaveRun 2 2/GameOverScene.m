//
//  GameOverScene.m
//  CaveRun
//
//  Created by Sumit on 17/06/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

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
#import "Reachability.h"
#define RequestTOFacebook @"LifeRequest"
#import <Chartboost/Chartboost.h>
#import <Chartboost/CBNewsfeed.h>

@implementation GameOverScene

#define ShareToFacebook @"FacebookShare"
@synthesize gameOverSprite,coinCount,shareText,gameMain,gameOverScreen,coinText1,dis,scoree,strPostMessage,levelBonus,timer,numsec,timerTextCnt,gm,mutscoreArray,backgroundView,cancelButton,playButton,levellabel,beatlabel,pos,scoreCheck,facebookShare,highScoreLabel,yourScore;
CGSize ws;
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameOverScene *layer = [GameOverScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
    
       if (self=[super init]) {

            CGSize winSize = [CCDirector sharedDirector].winSize;
           [[NSNotificationCenter defaultCenter] postNotificationName: kReachabilityChangedNotification object: nil];
           
           BOOL network_status=[[NSUserDefaults standardUserDefaults] boolForKey:CurrentNetworkStatus];
           
             rootViewController = (UIViewController*)[(AppDelegate*)[[UIApplication sharedApplication] delegate] getRootViewController];
           
           if (network_status==YES) {
               if (adm) {
                   adm=nil;
               }
               [GameState sharedState].bottomBanner=NO;
               adm = [[AdMobViewController alloc]init];
               [GameState sharedState].bannerView= adm.view;
//               [[[CCDirector sharedDirector] openGLView] addSubview:[GameState sharedState].bannerView];
               
        }
           
//           [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideBannerView) name:@"hideBanner" object:nil];

           //testing id .
          
//           [Chartboost startWithAppId:@"54cb98010d602505e20248d2"
//                         appSignature:@"0657de2558cf69704baa2f2b406013fc4cbfe36c"
//                             delegate:self];
           //Live Id.
           
           [Chartboost startWithAppId:@"54859c09c909a6309833a2c4"
                         appSignature:@"6b5efdfe6e15db9fd3948e8e7d21c23a1ad59efc"
                             delegate:self];
         

        userDefaults = [NSUserDefaults standardUserDefaults];
           
       
        
           ws=[[CCDirector sharedDirector]winSize];

           if([UIScreen mainScreen].bounds.size.height<500)
           {
               self.gameOverSprite=[CCSprite spriteWithFile:@"gameover-4.png"];
               self.gameOverSprite.visible=YES;
               gameOverSprite.anchorPoint=ccp(0,0);
               gameOverSprite.position=ccp(0,30);

           }
           else
           {
               self.gameOverSprite=[CCSprite spriteWithFile:@"gameovernew1-hd.png"];
               self.gameOverSprite.visible=YES;
               gameOverSprite.anchorPoint=ccp(0,0);
                              gameOverSprite.position=ccp(0,-5);
               
           }
        self.gameOverSprite.visible=YES;
        [self addChild:self.gameOverSprite];

           
           //--------------------retry button and next button------------------
           
           CCMenuItem *menuMainMenu = [CCMenuItemImage itemFromNormalImage:@"Retry2.png" selectedImage:@"Retry2.png" target:self selector:@selector(retryAction:)];
           
           CCMenu  *menu1 = [CCMenu menuWithItems: menuMainMenu, nil];
           if([UIScreen mainScreen].bounds.size.height<500)
           {
               menu1.position = ccp(winSize.width/2+110, winSize.height/2-120);
           }
           else{
               menu1.position = ccp(winSize.width/2+110, winSize.height/2-130);
           }
           [menu1 alignItemsHorizontally];
           [menu1 setVisible:true];
           [self addChild:menu1 z:100];
           
           CCMenuItem *menuMainMenunex = [CCMenuItemImage itemFromNormalImage:@"next-2.png" selectedImage:@"next-2.png" target:self selector:@selector(nextAction:)];
           
           menu1nex = [CCMenu menuWithItems: menuMainMenunex, nil];
           if([UIScreen mainScreen].bounds.size.height<500)
           {
               menu1nex.position = ccp(winSize.width/2+135, winSize.height/2-120);
           }
           else{
               menu1nex.position = ccp(winSize.width/2+135, winSize.height/2-130);
           }
           [menu1nex alignItemsHorizontally];
           [menu1nex setVisible:FALSE];
           [self addChild:menu1nex z:100];
           
           if([GameState sharedState].clear)
           {
               [menu1 setVisible:TRUE];
               [menu1nex setVisible:FALSE];
           }
           
           if([GameState sharedState].next)
           {    [menu1 setVisible:FALSE];
               [menu1nex setVisible:TRUE];
           }
           
           //label 1 for coint text
           
           CCLabelTTF *label1 = [CCLabelTTF labelWithString:self.coinText1 fontName:@"Arial Rounded MT Bold" fontSize:24];
           if([UIScreen mainScreen].bounds.size.height>500){
           label1.position = ccp(430,196);
               
           }else{
           label1.position = ccp(370,194);
           }
           label1.color = ccc3(255, 255, 255);
           
           [self addChild: label1];
           
        
           //label 2 score text
           
           NSString * scoretext = [NSString stringWithFormat:@"%i", self.scoree];
           
           CCLabelTTF *label2 = [CCLabelTTF labelWithString:scoretext fontName:@"Arial Rounded MT Bold" fontSize:24];
           if([UIScreen mainScreen].bounds.size.height>500){
           label2.position = ccp(430,100);
           }else{
           label2.position = ccp(370,118);
           }
           label2.color = ccc3(255, 255, 255);
           
           [self addChild: label2];
           
           
           //label 3 distance text
             NSString * distance = [NSString stringWithFormat:@"%i", self.dis];
           
           CCLabelTTF *label3 = [CCLabelTTF labelWithString:distance fontName:@"Arial Rounded MT Bold" fontSize:24];
             if([UIScreen mainScreen].bounds.size.height>500){
               label3.position = ccp(430,236);
                 
             }else{
           label3.position = ccp(370,224);
             }
           label3.color = ccc3(255, 255, 252);
           
           [self addChild: label3];
           
           
           //label for level bonus.
           
           NSString * bonus = [NSString stringWithFormat:@"%i", self.levelBonus];
           
           CCLabelTTF *label4 = [CCLabelTTF labelWithString:bonus fontName:@"Arial Rounded MT Bold" fontSize:24];
           if([UIScreen mainScreen].bounds.size.height>500){
               label4.position = ccp(430,156);
               
           }else{
               label4.position = ccp(370,158);
           }
           label4.color = ccc3(255, 255, 255);
           
           [self addChild: label4];
           //label for current level
           int level_No=[GameState sharedState].levelNumber;
            NSString * level = [NSString stringWithFormat:@"Level -%i",level_No];
           CCLabelTTF *level_gm = [CCLabelTTF labelWithString:level fontName:@"JFRocSol.TTF" fontSize:24];
           if([UIScreen mainScreen].bounds.size.height>500){
               level_gm.position = ccp(ws.width/2,ws.height/2+115);
               
           }else{
               level_gm.position = ccp(ws.width/2,ws.height/2+115);
           }
           
           if ([UIScreen mainScreen].bounds.size.width>[UIScreen mainScreen].bounds.size.height) {
               level_gm.position = ccp(ws.width/2-30,ws.height/2+115);

           }

           level_gm.color = ccc3(255, 255, 255);
           
           [self addChild: level_gm];
           
           if([GameState sharedState].next){

           
           BOOL fbconnect=[[NSUserDefaults standardUserDefaults]boolForKey:FacebookConnected];
           BOOL netWorkCheck=[[NSUserDefaults standardUserDefaults]boolForKey:CurrentNetworkStatus];
               
           NSString * connectFBId=[[NSUserDefaults standardUserDefaults]objectForKey:ConnectedFacebookUserID];
           if (netWorkCheck) {
               if(fbconnect)
               {
                   [self saveScoreToParse:scoree forLevel:[GameState sharedState].levelNumber];
               }
               
               else  if(!connectFBId)
               {
                   [self retriveScoreSqlite:scoree withLevel:[GameState sharedState].levelNumber];
               }
               else{
                   [self saveScoreToParse:scoree forLevel:[GameState sharedState].levelNumber];
               }
           }
           else{
               [self retriveScoreSqlite:scoree withLevel:[GameState sharedState].levelNumber];
           }
 }
           
            NSInteger mylife=[[NSUserDefaults standardUserDefaults]integerForKey:@"live"];
           NSInteger test = [[NSUserDefaults standardUserDefaults]integerForKey:@"check"];
           if(test==0){
               
               if(mylife==0)
               {
                  
               }
           }
           
           
        }
    return self;
}


//test
#pragma mark -
#pragma mark Save To Parse

-(void) saveScoreToParse:(NSInteger)score forLevel:(NSInteger)level{
    
    yourScore = [[UILabel alloc] initWithFrame:CGRectMake(60, 80, 200, 35)];
    yourScore.backgroundColor = [UIColor clearColor];
    yourScore.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:20];
    yourScore.numberOfLines = 0;
    yourScore.lineBreakMode = NSLineBreakByCharWrapping;
    yourScore.text = [NSString stringWithFormat:@"Score : %d",(int)score];
    
    NSString *fbID = [[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID];
    
    NSString *strCheckFirstRun = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"levelFirstRun%d",[GameState sharedState].levelNumber ]];
    //  strCheckFirstRun=nil;
    NSLog(@"%@",strCheckFirstRun);
    
    NSString *name =[[NSUserDefaults standardUserDefaults] objectForKey:@"ConnectedFacebookUserName"];
    
    NSLog(@"connected FB name is %@",name);
    NSLog(@"fbID is %@",fbID);
    
    if (fbID && ![fbID isEqualToString:@"Master"]) {
        
        BOOL isUpdateScore = NO;
        
        NSArray *ary = [GameState sharedState].friendsScoreArray;
        NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithArray:ary];
        
        for (int i = 0; i<mutableArray.count; i++) {
            
            PFObject *obj = [mutableArray objectAtIndex:i];
            NSString *store_fbID = obj[@"PlayerFacebookID"];
            if ([fbID isEqualToString:store_fbID]) {
                isUpdateScore = YES;
                break;
            }
        }// End For Loop
        
        if (isUpdateScore==NO) {//if3
//            [[NSUserDefaults standardUserDefaults] setObject:@"hello" forKey:[NSString stringWithFormat:@"levelFirstRun%d",[GameState sharedState].levelNumber ]];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            PFObject *object = [PFObject objectWithClassName:ParseScoreTableName];
            object[@"PlayerFacebookID"] = fbID;
            object[@"Level"] = [NSNumber numberWithInteger:level];
            object[@"Score"] = [NSNumber numberWithInteger:score];
            object[@"Name"] =  [[NSUserDefaults standardUserDefaults] objectForKey:@"ConnectedFacebookUserName"];
           NSString *name =[[NSUserDefaults standardUserDefaults] objectForKey:@"ConnectedFacebookUserName"];
            //object[@"Levels"] = [NSNumber numberWithInteger:level];
           
            NSLog(@"connected FB name is %@",name);
            
            [mutableArray addObject:object];
            
            NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"Score" ascending:NO];
            NSArray* sortedArray = [mutableArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
            [GameState sharedState].friendsScoreArray = sortedArray;
            
            [self findBeatedFriend:object];
            
            NSLog(@"ConnectedFacebookUserName%@",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey: @"ConnectedFacebookUserName"]]);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                [object saveEventually:^(BOOL succeed, NSError *error){
                    
                    if (succeed) {
                        NSLog(@"Save to Parse");
                    }
                    if (error) {
                        NSLog(@"Error to Save == %@",error.localizedDescription);
                    }
                }];
            });
        }//if3
        else{
            NSLog(@"Update row................yes ");
            [self updateScoreOn:score level:level];
        }
    }//End FB check
    else{
        NSLog(@"Not connected with Facebook");
        [self retriveScoreSqlite:score withLevel:level];
    }

}


-(void) updateScoreOn:(NSInteger) score level:(NSInteger) level{
  
    NSString *fbID = [[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID];
    PFQuery *query = [PFQuery queryWithClassName:ParseScoreTableName];
    if(fbID)
    {
        [query whereKey:@"PlayerFacebookID" equalTo:fbID];
        [query whereKey:@"Level" equalTo:[NSNumber numberWithInteger:level]];
        [query orderByDescending:@"Score"];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
           NSLog(@"objects = %@",objects);
            for (int a =0; a<objects.count;a++) {
                
                PFObject *object = [objects objectAtIndex:a];
                
                if (a==0) {
                    NSLog(@"PFOBJEct -==- %@",object);
                    NSNumber *scoreOld = object[@"Score"];
                    
                    if (score > [scoreOld integerValue]) {
                        
                        NSLog(@"Current Level == %d",(int)level);
                        NSLog(@"Level Score == %d",(int)score);
                        
                        object[@"Score"] = [NSNumber numberWithInteger:score];
                    
                        NSLog(@"%@",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey: @"ConnectedFacebookUserName"]]);
                        
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                            
                            [object saveEventually:^(BOOL succeed, NSError *error){
                                
                                if (succeed) {
                                    NSLog(@"Save to Parse");
                                    // [self retriveFriendsScore:level andScore:score];
                                }
                                else{
                                    NSLog(@"Error to Save == %@",error.localizedDescription);
                                }
                            }];
                        });// End dispatch Queue Save Data
                        
                        NSArray *ary = [GameState sharedState].friendsScoreArray;
                        NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithArray:ary];
                        
                        NSLog(@"mutable array is before====  %@",mutableArray);
                        
                        for (int a =0; a<mutableArray.count;a++){
                            
                            PFObject *obj=[mutableArray objectAtIndex:a];
                            
                            if([obj[@"PlayerFacebookID"] isEqualToString:fbID]){
                             // [mutableArray replaceObjectAtIndex:a withObject:object].;
                                [mutableArray removeObject:obj];
                                }
                            } //For end
                        [mutableArray addObject:object];
                        
                        NSLog(@"mutable array is after==== %@",mutableArray);
                        
                        NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"Score" ascending:NO];
                        NSArray* sortedArray = [mutableArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                        [GameState sharedState].friendsScoreArray = sortedArray;
                       // [mutableArray release];
                        
                        if (score > [scoreOld integerValue])
                        {
                            [self findBeatedFriend:object];
                        }
                        
                        [mutableArray release];
                    }//End if block Score check
                    
                }//End if Block a-0
                else{
                    [object deleteInBackground];
                }
                
            }//End of For loop
            
        }];
    }//// End if block fbID check
    
}

-(void)sendPushtoAll:(PFObject *)object{
    
    NSArray *ary = [GameState sharedState].friendsScoreArray;
    if (ary.count<1) {
        return;
    }
    
      NSString *curFBID = [[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID];
     NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithArray:ary];
     NSMutableArray * Id=[[NSMutableArray alloc]init];
     NSNumber *score = object[@"Score"];
    
    for (int i=0; i<ary.count; i++) {
         PFObject *beatedObject = [mutableArray objectAtIndex:i];
        NSString *beated_fbID = beatedObject[@"PlayerFacebookID"];
        NSNumber *check = beatedObject[@"Score"];
        
        if (![beated_fbID isEqualToString:curFBID]) {//1
            
            if (score > check) {
                [Id addObject:beatedObject[@"PlayerFacebookID"]];
            }
        }
    }//for loop
    
    NSLog(@"array is %@",Id);
    
    // push notification .
    
    
    NSString *connectedName = [[NSUserDefaults standardUserDefaults]objectForKey:@"ConnectedFacebookUserName"];
    
    // Create our Installation query
   
         PFQuery *pushQuery = [PFInstallation query];
        [pushQuery whereKey:@"facebookId" containedIn:Id];
        NSString *Message = [NSString stringWithFormat:@"%@ beat you in level %d",connectedName,[GameState sharedState].levelNumber];
    
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                           Message, @"alert",
                          @"Increment", @"badge",
                          @"cheering.caf",@"sound",
                          @"com.globussoft.caverunmowgli.UPDATE_STATUS",@"action",
                           Message,@"Message",
                          nil];
    
        PFPush *push = [[PFPush alloc] init];
        [push setQuery:pushQuery];
        [push setData:data];
        [push sendPushInBackground];
}

-(void)findBeatedFriend:(PFObject *)object{
    
    NSArray *ary = [GameState sharedState].friendsScoreArray;
    
    [self sendPushtoAll:object];
    
    NSString *urlString=nil;
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithArray:ary];
    if ([mutableArray containsObject:object]) {
        
        NSInteger position = [mutableArray indexOfObject:object];
        
        if (position<=mutableArray.count-2 && mutableArray.count>1) {
            
            NSString *curFBID = [[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID];
            
            PFObject *beatedObject = [mutableArray objectAtIndex:position+1];
            NSString *beated_fbID = beatedObject[@"PlayerFacebookID"];
            NSString *name = beatedObject[@"Name"];
            
            
            if ([beated_fbID isEqualToString:curFBID]) {
                NSLog(@"Set new Score in this level");
                if_beated = NO;
                [mutableArray removeObject:beatedObject];
            }
            else{
                if_beated = YES;
                urlString = [NSString stringWithFormat:@"https://graph.facebook.com/%@",beatedObject[@"PlayerFacebookID"]];
                BeatFbId = beatedObject[@"PlayerFacebookID"];
                NSLog(@"name%@",name);
                NSString * str = name;
                NSArray * arr = [str componentsSeparatedByString:@" "];
               // NSLog(@"Array values are : %@",arr);
                NSLog(@"Array [0] is :%@",arr[0]);
                
                [UIView animateWithDuration:0.6f animations:^(void) {
                    
                    beatlabel=[[UILabel alloc]initWithFrame:CGRectMake(45,150, 250, 30)];
                    beatlabel.backgroundColor = [UIColor clearColor];
                    beatlabel.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:15];
                    beatlabel.text = [NSString stringWithFormat:@"You Beat : %@",arr[0]];
                    
                    
                    beatlabel.alpha = .5;
                    beatlabel.transform = CGAffineTransformMakeScale(2.5, 2.5);
                    beatlabel.layer.shadowOpacity = .6f;
                    beatlabel.layer.shadowOffset = CGSizeMake(0.0, 0.0);
                    beatlabel.layer.shadowRadius = 1;
                    beatlabel.layer.shadowColor = [UIColor lightGrayColor].CGColor;
                    beatlabel.layer.shouldRasterize = YES;
                    beatlabel.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    beatlabel.alpha = 1;
                    
                }];
                [[NSUserDefaults standardUserDefaults]setObject:name forKey:@"beatFriend"];
               [[NSUserDefaults standardUserDefaults]setObject:BeatFbId forKey:@"beated_fbID"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                
                BOOL fbCheck = [[NSUserDefaults standardUserDefaults] boolForKey:FacebookConnected];
                BOOL networkStatus = [[NSUserDefaults standardUserDefaults]boolForKey:CurrentNetworkStatus];
                
               if (fbCheck==YES && networkStatus == YES) {
                [self beatFriendStoryPostOnWall];
               }
            }
        }
        
        if (position == 0) {
            NSLog(@"new high score");
            isNewHighScore = YES;
            
            [UIView animateWithDuration:0.6f animations:^(void) {
                
                highScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 115, 200, 35)];
                highScoreLabel.backgroundColor = [UIColor clearColor];
                highScoreLabel.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:15];
                highScoreLabel.numberOfLines = 0;
                highScoreLabel.lineBreakMode = NSLineBreakByCharWrapping;
                highScoreLabel.text = @"New High Score !";
                
                highScoreLabel.alpha = .5;
                highScoreLabel.transform = CGAffineTransformMakeScale(2.5, 2.5);
                highScoreLabel.layer.shadowOpacity = .6f;
                highScoreLabel.layer.shadowOffset = CGSizeMake(0.0, 0.0);
                highScoreLabel.layer.shadowRadius = 1;
                highScoreLabel.layer.shadowColor = [UIColor lightGrayColor].CGColor;
                highScoreLabel.layer.shouldRasterize = YES;
                highScoreLabel.transform = CGAffineTransformMakeScale(1.0, 1.0);
                highScoreLabel.alpha = 1;
            }];
        }
    }
}


-(void)cancelButtonAction:(id)sender{
    backgroundView.hidden=YES;
    backgroundView = nil;
    [[CCDirector sharedDirector]replaceScene:[CCTransitionFadeTR transitionWithDuration:0.5 scene:[LevelSelectionScene scene]]];
}
#pragma mark -
#pragma mark save score in Squilte.
#pragma mark==================

-(void)retriveScoreSqlite:(NSInteger)ascore withLevel:(NSInteger)alevel
{
    
    BOOL check_Update;
    check_Update=FALSE;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSLog(@"%@",paths);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:@"GameScoreDb.sqlite"];
    NSString * keyLevel=[NSString stringWithFormat:@"%d",(int)alevel];
    // Check to see if the database file already exists
    NSString * connectedFBid=[[NSUserDefaults standardUserDefaults]objectForKey:ConnectedFacebookUserID];
    NSString *query = [NSString stringWithFormat:@"select * from GameScoreFinal where PlayerFbId = \"%@\"",connectedFBid];
    sqlite3_stmt *stmt=nil;
    if(sqlite3_open([databasePath UTF8String], &_databaseHandle)!=SQLITE_OK)
        NSLog(@"error to open");
    
    if (sqlite3_prepare_v2(_databaseHandle, [query UTF8String], -1, &stmt, NULL)== SQLITE_OK)
    {
        NSLog(@"prepared");
    }
    else
        NSLog(@"error");
    // sqlite3_step(stmt);
    @try
    {
        while(sqlite3_step(stmt)==SQLITE_ROW)
        {
            
            char *level = (char *) sqlite3_column_text(stmt,1);
            char *score = (char *) sqlite3_column_text(stmt,2);
            NSString *strLevel= [NSString  stringWithUTF8String:level];
            
            NSString *strScore  = [NSString stringWithUTF8String:score];
            NSLog(@"Level %@ and Score %@ ",strLevel,strScore);
            if([strLevel isEqualToString:keyLevel])
            {
                check_Update=TRUE;
            }
            
        }
    }
    @catch(NSException *e)
    {
        NSLog(@"%@",e);
    }
    if(check_Update)
    {
        [self updateScoreSqlite:ascore withScore:alevel];
    }
    else
    {
        [self saveScoreSqlite:ascore withScore:alevel];
    }
    
}

-(void)saveScoreSqlite:(NSInteger)ascore withScore:(NSInteger)alevel
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"%@",paths);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:@"GameScoreDb.sqlite"];
    sqlite3_stmt *inset_statement = NULL;
    NSString * keyLevel=[NSString stringWithFormat:@"%d",(int)alevel];
    NSString * keyScore=[NSString stringWithFormat:@"%d",(int)ascore];
    NSString * connectedFBid=[[NSUserDefaults standardUserDefaults]objectForKey:ConnectedFacebookUserID];
    if(!connectedFBid)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"Master" forKey:
         ConnectedFacebookUserID];
    }
    connectedFBid=[[NSUserDefaults standardUserDefaults]objectForKey:ConnectedFacebookUserID];
    NSString *insertSQL = [NSString stringWithFormat:
                           @"INSERT INTO GameScoreFinal (Level, Score,PlayerFbId,Name) VALUES (\"%@\", \"%@\",\"%@\",\"%@\")",
                           keyLevel,
                           keyScore,connectedFBid,[[NSUserDefaults standardUserDefaults]objectForKey:@"ConnectedFacebookUserName"]
                           ];
    
    const char *insert_stmt = [insertSQL UTF8String];
    if (sqlite3_open([databasePath UTF8String], &_databaseHandle)!=SQLITE_OK) {
        NSLog(@"Error to Open");
        return;
    }
    
    if (sqlite3_prepare_v2(_databaseHandle, insert_stmt , -1,&inset_statement, NULL) != SQLITE_OK ) {
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(_databaseHandle), sqlite3_errcode(_databaseHandle));
        NSLog(@"Error to Prepare");
        
    }
    
    if(sqlite3_step(inset_statement) == SQLITE_DONE) {
//        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@""
//                                                          message:@"Data Saved"
//                                                         delegate:nil
//                                                cancelButtonTitle:@"OK"
//                                                otherButtonTitles:nil];
//        [message show];
        NSLog(@"Success");
    }
}


-(void)updateScoreSqlite:(NSInteger)ascore withScore:(NSInteger)alevel
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"%@",paths);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:@"GameScoreDb.sqlite"];
    sqlite3_stmt *inset_statement = NULL;
    NSString * keyLevel=[NSString stringWithFormat:@"%d",(int)alevel];
    NSString * keyScore=[NSString stringWithFormat:@"%d",(int)ascore];
    NSString * connectedFBid=[[NSUserDefaults standardUserDefaults]objectForKey:ConnectedFacebookUserID];
    NSString * name=[[NSUserDefaults standardUserDefaults]objectForKey:@"ConnectedFacebookUserName"];
    
    NSLog(@"Exitsing data, Update Please");
    NSString *updateSQL = [NSString stringWithFormat:@"UPDATE GameScoreFinal set  Score = '%@', PlayerFbId = '%@' Name = '%@' WHERE Level =%@",keyScore,connectedFBid,name,keyLevel];
    
    const char *update_stmt = [updateSQL UTF8String];
    if (sqlite3_open([databasePath UTF8String], &_databaseHandle)!=SQLITE_OK) {
        NSLog(@"Error to Open");
        return;
    }
    
    if (sqlite3_prepare_v2(_databaseHandle, update_stmt , -1,&inset_statement, NULL) != SQLITE_OK )
    {
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(_databaseHandle), sqlite3_errcode(_databaseHandle));
        NSLog(@"Error to Prepare");
        
    }
    if(sqlite3_step(inset_statement) == SQLITE_DONE) {
        
        NSLog(@"Success");
    }
    //NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(_databaseHandle), sqlite3_errcode(_databaseHandle));
    sqlite3_finalize(inset_statement);
    sqlite3_close(_databaseHandle);
}


#pragma mark -
#pragma mark Display New UI
#pragma mark==================

-(void)nextAction:(id)sender
{

    [viewHost1 removeFromSuperview];
    viewHost1 = nil;
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideBanner" object:nil];
    BOOL netwrok_status=[[NSUserDefaults standardUserDefaults] boolForKey:CurrentNetworkStatus];
    
    if (netwrok_status==YES) {
        [Chartboost showInterstitial:CBLocationStartup];
    }
    
    int level=(int)[userDefaults integerForKey:@"levelClear"];
    
    if ([GameState sharedState].levelNumber > level) {
        [userDefaults setInteger:[GameState sharedState].levelNumber forKey:@"levelClear"];
        [userDefaults synchronize];
    }
    
    [GameState sharedState].next=FALSE;
    
    BOOL fbCheck = [[NSUserDefaults standardUserDefaults] boolForKey:FacebookConnected];
    BOOL networkStatus = [[NSUserDefaults standardUserDefaults]boolForKey:CurrentNetworkStatus];
    
    if (fbCheck==YES && networkStatus == YES) {
        [self createUI:[GameState sharedState].levelNumber];
        [self displayScore];
    }else{
        
         [[CCDirector sharedDirector]replaceScene:[CCTransitionFadeTR transitionWithDuration:0.8 scene:[LevelSelectionScene scene]]];
    }
    
    //230
   
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 65, 155, 230)];
    // self.scrollView.backgroundColor = [UIColor redColor];
    [self.backgroundView addSubview:self.scrollView];

}


#pragma mark-
- (void) createUI:(int)level{
    
    NSLog(@"level is %d",level);
    
    CGRect frame = [UIScreen mainScreen].bounds;
    if (!self.backgroundView) {
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.width)];
        
        self.backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"popupbg.png"]];
        [rootViewController.view addSubview:backgroundView];
        
        
        firstView = [[UIView alloc]initWithFrame:CGRectMake(175, 20, 245, 295)];
        [firstView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"popup.png"]]];
        
        
        secondView = [[UIView alloc]initWithFrame:CGRectMake(10, 20, 180, 280)];
        [secondView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"highscore.png"]]];
        [backgroundView addSubview:secondView];
        [backgroundView addSubview:firstView];
        
        UIImageView *run = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 50, 50)];
        run.image = [UIImage imageNamed:@"run0001.png"];
        [firstView addSubview:run];
        
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
        
        [UIView animateWithDuration:0.6f animations:^(void) {
            
            levellabel = [[UILabel alloc] initWithFrame:CGRectMake(85,30, 100, 35)];
            levellabel.backgroundColor = [UIColor clearColor];
            // levellabel.font = [UIFont systemFontOfSize:20];
            levellabel.numberOfLines = 0;
            levellabel.lineBreakMode = NSLineBreakByCharWrapping;
            levellabel.text = [NSString stringWithFormat:@"Level % d",level];
            levellabel.textColor = [UIColor blackColor];
            
            levellabel.alpha = .5;
            levellabel.transform = CGAffineTransformMakeScale(2.5, 2.5);
            levellabel.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:20];
            
            levellabel.layer.shadowOpacity = .6f;
            levellabel.layer.shadowOffset = CGSizeMake(0.0, 0.0);
            levellabel.layer.shadowRadius = 1;
            levellabel.layer.shadowColor = [UIColor lightGrayColor].CGColor;
            levellabel.layer.shouldRasterize = YES;
            levellabel.transform = CGAffineTransformMakeScale(1.0, 1.0);
            levellabel.alpha = 1;
            [firstView addSubview:levellabel];
            
        }];
        
        facebookShare = [[UIButton alloc]initWithFrame:CGRectMake(50, 225, 150, 50)];
        UIImage *facebookImage = [UIImage imageNamed:@"share1.png"];
        [facebookShare setImage:facebookImage forState:UIControlStateNormal];
        [facebookShare addTarget:self action:@selector(facebookBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [firstView addSubview: facebookShare];
        
        [firstView addSubview:beatlabel];
        
        [firstView addSubview:highScoreLabel];
        
        [firstView addSubview:yourScore];
        
    }
    else{
        self.backgroundView.hidden = NO;
        [rootViewController.view addSubview:backgroundView];
        levellabel.text = [NSString stringWithFormat:@"Level % d",level];
        
    }
    
    BOOL fbCheck = [[NSUserDefaults standardUserDefaults] boolForKey:FacebookConnected];
    BOOL networkStatus = [[NSUserDefaults standardUserDefaults]boolForKey:CurrentNetworkStatus];
    
       if (fbCheck==YES && networkStatus == YES) {
            [self automaticStoryPost];
       }
}

-(void)cancelBtnAction:(id)sender{
    
    NSLog(@"in cancel action");
}

-(void)playButtonAction:(id)sender{
   
    if ([GameState sharedState].levelNumber >= 50) {
        [self displayGameCompletionView];
        return;
    }
    
    backgroundView.hidden=YES;
    backgroundView = nil;
    
  //  [[CCDirector sharedDirector]replaceScene:[CCTransitionFadeTR transitionWithDuration:0.5 scene:[LevelSelectionScene scene]]];
    [[CCDirector sharedDirector]replaceScene:[LevelSelectionScene scene]];
 
}

-(void) displayGameCompletionView{
    CGRect frame = [UIScreen mainScreen].bounds;
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.width)];
    backView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"popupbg2.png"]];
    backView.backgroundColor = [UIColor whiteColor];
    [rootViewController.view addSubview:backView];
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.width+10, frame.size.height, frame.size.width)];
    containerView.backgroundColor = [UIColor clearColor];
    [backView addSubview:containerView];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, frame.size.height-20, 60)];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:20];
    headerLabel.textColor = [UIColor redColor];
    headerLabel.text = @"Congratulations!";
    [containerView addSubview:headerLabel];
    //--------
    NSString *updatedText = @"You finished all 40 levels in the game. Please rate us and give detailed feedback here .GlobusGames invites you to play our other exciting games in various genres.Visit www.globusgames.com for more.";
    
    UIFont *font = [UIFont systemFontOfSize:17];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:updatedText attributes:dict];
    
    [attributedString addAttribute:NSLinkAttributeName value:@"http://www.globusgames.com" range:[[attributedString string] rangeOfString:@"www.globusgames.com"]];
    [attributedString addAttribute:NSLinkAttributeName value:@"http://www.globusgames.com" range:[[attributedString string] rangeOfString:@"here"]];
    
    UIColor *linkColor = [UIColor colorWithRed:(CGFloat)77/255 green:(CGFloat)161/255 blue:(CGFloat)253/255 alpha:1];
    
    NSDictionary *linkAttributes = @{NSForegroundColorAttributeName:linkColor,NSUnderlineColorAttributeName: linkColor,NSUnderlineStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};
    UITextView *txtView = [[UITextView alloc] initWithFrame:CGRectMake(20, 110, frame.size.height-40, 100)];
    txtView.linkTextAttributes = linkAttributes;
    //txtView.selectable = NO;
    txtView.editable = NO;
    txtView.backgroundColor = [UIColor clearColor];
    txtView.delegate = self;
    [txtView setAttributedText:attributedString];
    [containerView addSubview:txtView];
    
    UIButton *playBtn =[UIButton buttonWithType: UIButtonTypeCustom];
    [playBtn setImage:[UIImage imageNamed:@"click1.png"] forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(playRestart) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:playBtn];
    playBtn.frame = CGRectMake(frame.size.height/2-100, 230, 200, 37);
    [UIView animateWithDuration:3 animations:^{
        containerView.frame = CGRectMake(0, 0, frame.size.height, frame.size.width);
    }completion:^(BOOL completed){
        
    }];
}
-(void) playRestart{
    backView.hidden = YES;
    self.backgroundView.hidden=YES;
    [self.backgroundView release];
    [backView release];
    [self.backgroundView removeFromSuperview];

    [[CCDirector sharedDirector]replaceScene:[CCTransitionFadeTR transitionWithDuration:0.5 scene:[LevelSelectionScene scene]]];
}
#pragma mark-
-(void) displayScore{
    
    for (UIView *subView in [self.scrollView subviews]){
        subView.hidden = YES;
    }
    
    NSArray *scoreDataAry = [GameState sharedState].friendsScoreArray;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        CGFloat y = 5;
        for (int i =0; i<scoreDataAry.count; i++) {
            
            PFObject *obj = [scoreDataAry objectAtIndex:i];
            NSLog(@"PFOBJEct -==- %@",obj);
            
            NSNumber *score_saved = obj[@"Score"];
            NSString *player1 = nil;
            NSURL *url = nil;
            NSString * name=nil;
            
            player1 = obj[@"PlayerFacebookID"];
            name = obj[@"Name"];
            
            url=[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",player1]];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIImageView *aimgeView = (UIImageView*)[self.scrollView viewWithTag:100+i];
                UILabel *label = (UILabel*)[self.scrollView viewWithTag:300+i];
                UILabel *positinLabel = (UILabel*)[secondView viewWithTag:3000+i];
                
                if (aimgeView == nil) {
                    UIImageView *profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, y+(i*40), 35, 35)];
                    profileImageView.tag = 100+i;
                    [profileImageView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
                    [profileImageView.layer setBorderWidth: 2.0];
                    [self.scrollView addSubview:profileImageView];
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
                    infoLabel.lineBreakMode = NSLineBreakByCharWrapping;
                    infoLabel.text = [NSString stringWithFormat:@"%@\n%@",name,score_saved];
                    [self.scrollView addSubview:infoLabel];
                }
                else{
                    label.hidden = NO;
                    label.text = [NSString stringWithFormat:@"%@\n%@",name,score_saved];
                }
                
                if (positinLabel==nil) {
                    UILabel *position = [[UILabel alloc] initWithFrame:CGRectMake(140, y+(i*40)+5, 30, 35)];
                    position.tag = 3000+i;
                    position.backgroundColor = [UIColor clearColor];
                    position.font = [UIFont boldSystemFontOfSize:13];
                    position.numberOfLines = 0;
                    position.textColor = [UIColor blueColor];
                    positinLabel.textAlignment = NSTextAlignmentRight;
                    position.lineBreakMode = NSLineBreakByCharWrapping;
                    position.text = [NSString stringWithFormat:@"%d",i+1];
                    [self.scrollView addSubview:position];
                }
                else{
                    positinLabel.hidden = NO;
                    positinLabel.text = [NSString stringWithFormat:@"%d",i+1];
                }
            });
            
        }
        NSInteger ct = scoreDataAry.count;
        CGFloat h = ct*36+80;
        self.scrollView.contentSize = CGSizeMake(150, h);
    });
    
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
        NSLog(@"you beat name is=== %@",name);
    }
}

#pragma mark -
#pragma mark send request to friends.
#pragma mark =====================

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

#pragma retry and next action

-(void)retryAction:(id)sender {

    [viewHost1 removeFromSuperview];
    viewHost1 = nil;
  
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideBanner" object:nil];
    NSLog(@"in retry action");
    int life = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"live"];
    
    if(life>0){
        
//        [[CCDirector sharedDirector]replaceScene:[CCTransitionFadeTR transitionWithDuration:1.0 scene:[GameMain scene]]];
       //  [[CCDirector sharedDirector]replaceScene:[CCTransitionFadeTR transitionWithDuration:0.5 scene:[LevelSelectionScene scene]]];
         [[CCDirector sharedDirector]replaceScene:[LevelSelectionScene scene]];
        
    }else{
        
        [[CCDirector sharedDirector]replaceScene:[CCTransitionFadeTR transitionWithDuration:1.0 scene:[LifeOver scene]]];
    }
    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"checkLivesNotification"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}


#pragma mark
#pragma mark Facebook Click
#pragma mark ========================

-(void)facebookBtnClick:(id)sender {
    
    BOOL networkStatus = [[NSUserDefaults standardUserDefaults] objectForKey:CurrentNetworkStatus];
    
    if(networkStatus==NO)
    {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"internet connection required for this process  " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        return;
    }else{
        
        BOOL netwrok_status=[[NSUserDefaults standardUserDefaults] boolForKey:CurrentNetworkStatus];
        
        if (netwrok_status==YES) {
            [Chartboost showInterstitial:CBLocationStartup];
        }
    }
    
    self.strPostMessage = [NSString stringWithFormat:@"Completed Level %i  with score %i.     CaveRunMowgli is an adventurous game which takes you on a voyage with Mowgli.Play multiple levels of fun packed adventurous routes of Mowgli.",[GameState sharedState].levelNumber,self.scoree];
    NSLog(@"Message == %@",self.strPostMessage);
    NSString *strLife = [NSString stringWithFormat:@"Level %d",[GameState sharedState].levelNumber];
    
    NSMutableDictionary *params =
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     self.strPostMessage, @"description", strLife, @"caption",
     @"https://itunes.apple.com/app/id903886678", @"link",@"Cave Run Mowgli",@"name",
     @"i.imgur.com/1612f7A.png?1",@"picture",
     nil];
 
    
    if (FBSession.activeSession.isOpen) {
        
        [appDelegate shareOnFacebookFeedDialog:params];
    }
    else{
        [appDelegate openSessionWithLoginUI:2 withParams:params withString:nil];
    }
    
}

-(void)automaticStoryPost{
     appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    BOOL networkStatus = [[NSUserDefaults standardUserDefaults] objectForKey:CurrentNetworkStatus];
    
    if(networkStatus==NO)
    {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Internet connection required for this process  " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        return;
    }
    
    self.strPostMessage = [NSString stringWithFormat:@"Completed Level %i  with score %i! CaveRunMowgli is an adventurous game which takes you on a voyage with Mowgli.Play multiple levels of fun packed adventurous routes of Mowgli.",[GameState sharedState].levelNumber,self.scoree];
    NSLog(@"Message == %@",self.strPostMessage);
    NSString *strLife = [NSString stringWithFormat:@"Level %d",[GameState sharedState].levelNumber];
    
   NSMutableDictionary *params =
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     self.strPostMessage, @"description", strLife, @"caption",
     @"https://www.facebook.com/games/caverunapp", @"link",@"Cave Run Mowgli",@"name",
     @"i.imgur.com/1612f7A.png?1",@"picture",
     nil];
   

//    NSDictionary *storyDict = [NSDictionary dictionaryWithObjectsAndKeys:@"level",FacebookType,[NSString stringWithFormat:@"Completed %@",strLife],FacebookTitle,self.strPostMessage,FacebookDescription,@"complete",FacebookActionType, nil];
     NSDictionary *storyDict = [NSDictionary dictionaryWithObjectsAndKeys:@"level",FacebookType,@"",FacebookTitle,self.strPostMessage,FacebookDescription,@"complete",FacebookActionType, nil];
    
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.delegate = nil;
    appDelegate.openGraphDict = storyDict;
    
    if (FBSession.activeSession.isOpen) {
        
        [appDelegate storyPostwithDictionary:storyDict];
    }
    else{
        [appDelegate openSessionWithLoginUI:3 withParams:storyDict withString:nil];
    }
    
    if (FBSession.activeSession.isOpen){
    
        if (if_beated==YES) {
         [self schedule:@selector(beatFriendStoryPost) interval:1.2];
        }
    }
    
    if (FBSession.activeSession.isOpen){
        
        if ( isNewHighScore) {
        [self schedule:@selector(newHighScoreStoryPost) interval:1.2];
        }
    }
    
}
-(void)beatFriendStoryPostOnWall{
    
   appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSString *fbID = [[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID];
    
    NSString *str = [NSString stringWithFormat:@"I beat you in Level %d with  score  %d . CaveRunMowgli is an adventurous game which takes you on a voyage with Mowgli.Play multiple levels of fun packed adventurous routes of Mowgli",[GameState sharedState].levelNumber,self.scoree];
    /*
    NSMutableDictionary *params =
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     str, @"description", @"Beated", @"caption",
     @"https://www.facebook.com/games/caverunapp", @"link",@"Cave Run Mowgli",@"name",
     @"i.imgur.com/1612f7A.png?1",@"picture",@"1512807592288561",@"to",@"274637962742755",@"from",
     nil];
    */
    NSMutableDictionary *params =
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     str, @"description", @"", @"caption",
     @"https://itunes.apple.com/app/id903886678", @"link",@"Cave Run Mowgli",@"name",
     @"i.imgur.com/1612f7A.png?1",@"picture",BeatFbId,@"to",fbID,@"from",
     nil];
    
    if (FBSession.activeSession.isOpen) {
        [appDelegate shareOnFacebookFeedDialog:params ];
    }
    else{
        [appDelegate openSessionWithLoginUI:2 withParams:params withString:nil ];
    }
}



-(void) newHighScoreStoryPost{
    
    [self unschedule:@selector(newHighScoreStoryPost)];
    NSString *title = [NSString stringWithFormat:@"New highscore %d",self.scoree];
    NSString *description = [NSString stringWithFormat:@"I got new highscore %d in level %d. CaveRunMowgli is an adventurous game which takes you on a voyage with Mowgli.Play multiple levels of fun packed adventurous routes of Mowgli.",self.scoree,[GameState sharedState].levelNumber];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"highscore",FacebookType,title,FacebookTitle,description,FacebookDescription,@"set",FacebookActionType, nil];
    
    appDelegate.openGraphDict = dict;
    if (FBSession.activeSession.isOpen) {
        

        [appDelegate storyPostwithDictionary:dict];
    }else{
        
            [appDelegate openSessionWithLoginUI:3 withParams:dict withString:nil];
        }
}


-(void) beatFriendStoryPost{
    
    [self unschedule:@selector(beatFriendStoryPost)];
    
    NSString *beatFriend = [[NSUserDefaults standardUserDefaults]objectForKey:@"beatFriend"];
    
//    NSString *title = [NSString stringWithFormat:@"Beat %@ ",beatFriend];
    NSString *title1 = [NSString stringWithFormat:@"I Beat %@ ",beatFriend];

    NSString *title =@"";
    
    NSString *description = [NSString stringWithFormat:@"%@ at level %d and made score %d!. CaveRunMowgli is an adventurous game which takes you on a voyage with Mowgli.Play multiple levels of fun packed adventurous routes of Mowgli.",title1,[GameState sharedState].levelNumber,self.scoree];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"friend",FacebookType,title,FacebookTitle,description,FacebookDescription,@"beat",FacebookActionType, nil];
    if (FBSession.activeSession.isOpen) {

       appDelegate.openGraphDict = dict;
        [appDelegate storyPostwithDictionary:dict];
    
    }else{
        
            [appDelegate openSessionWithLoginUI:3 withParams:dict withString:nil];
        }
}

-(void) dealloc{
    [super dealloc];
}

@end


