//
//  AppDelegate.m
//  CaveRun
//
//  Created by tang on 12-6-4.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "GameConfig.h"
#import "GameMain.h"
#import "MainMenu.h"
#import "RootViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import "Reachability.h"
#import <Chartboost/Chartboost.h>
#import <Chartboost/CBNewsfeed.h>
#import "Flurry.h"
#import "GAI.h"



@implementation AppDelegate

#define APP_HANDLED_URL @"App_Handel_Url"
#define ShareToFacebook @"FacebookShare"
#define RequestTOFacebook @"LifeRequest"
#define ReceiveNotification @"REceiveNotification"


@synthesize window;
@synthesize friendPickerController = _friendPickerController;


-(UIViewController *) getRootViewController{
    
//    return viewController;
    return self.window.rootViewController;
}

- (void) removeStartupFlicker
{
	//
	// THIS CODE REMOVES THE STARTUP FLICKER
	//
	// Uncomment the following code if you Application only supports landscape mode
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController

//	CC_ENABLE_DEFAULT_GL_STATES();
//	CCDirector *director = [CCDirector sharedDirector];
//	CGSize size = [director winSize];
//	CCSprite *sprite = [CCSprite spriteWithFile:@"Default.png"];
//	sprite.position = ccp(size.width/2, size.height/2);
//	sprite.rotation = -90;
//	[sprite visit];
//	[[director openGLView] swapBuffers];
//	CC_ENABLE_DEFAULT_GL_STATES();
	
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController	
}

//to test the push notifications in parse...


#pragma mark -
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //FB App Events.
//    [FBAppEvents activateApp];
    
     [Flurry startSession:@"YRYJWPMH9QP8K7XH5KMS"];
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    NSString *FirstRun = [[NSUserDefaults standardUserDefaults] objectForKey:@"firstrun"];
    NSLog(@"%@",FirstRun);
    
    if (!FirstRun) {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"strtdate"];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"firstrun"];
        [[NSUserDefaults standardUserDefaults] setInteger:5 forKey:@"live"];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"GainLife"];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"levelClear"];
        [[NSUserDefaults standardUserDefaults] synchronize];
//         [FBAppEvents logEvent:FBAppEventNameActivatedApp];
        [self saveinSqlite];
    }
       // Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //[Parse setApplicationId:@"A6MDRE3AD1IRK6M6oVTKEqWnstDFZOkLx8sHMBmU" clientKey:@"HNv2Th5NPzhcZ0S2NYmzj4s0Xdz4OTHsBJnb3Z5F"];
         [Parse setApplicationId:@"m40o8awGX22IP2eTEkgjpMiP44SOPGUJ1LXhGAUl" clientKey:@"WB3YZs0brRLlpnbKcdYejc5Pj0y8NJXVLqCsb60m"];
         [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
        
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        [currentInstallation saveInBackground];

    });
    
    //google analytics.
    
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-58722207-3"];

    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];

    
    [self reacheability];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reacheability) name:kReachabilityChangedNotification object:nil];
    
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	
	CCDirector *director = [CCDirector sharedDirector];
	
	// Init the View Controller
	viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	//viewController.wantsFullScreenLayout = YES;
    viewController.extendedLayoutIncludesOpaqueBars = YES;
	
	//
	// Create the EAGLView manually
	//  1. Create a RGB565 format. Alternative: RGBA8
	//	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
	//
	//
	EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						];
	
	// attach the openglView to the director
	[director setOpenGLView:glView];
	
    //    FBSession *sesseion;
    //    FBAccessTokenData *access;
    
    //	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director enableRetinaDisplay:YES] ) CCLOG(@"Retina Display Not supported");
	
	//
	// VERY IMPORTANT:
	// If the rotation is going to be controlled by a UIViewController
	// then the device orientation should be "Portrait".
	//
	// IMPORTANT:
	// By default, this template only supports Landscape orientations.
	// Edit the RootViewController.m file to edit the supported orientations.
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
#else
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
#endif
	
	[director setAnimationInterval:1.0/60.0];
	[director setDisplayFPS:NO];
	
	
	// make the OpenGLView a child of the view controller
	[viewController setView:glView];
	
	// make the View Controller a child of the main window
	//[window addSubview: viewController.view];
    window.rootViewController = viewController;
	
	[window makeKeyAndVisible];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
	
	// Removes the startup flicker
	[self removeStartupFlicker];
	
    //激活多点触摸
    [viewController.view setMultipleTouchEnabled:YES];
    
	// Run the intro Scene
	[[CCDirector sharedDirector] runWithScene: [MainMenu scene]];
    return YES;
}

#pragma mark Sqlite DB and Retrive--
-(void)saveinSqlite
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSLog(@"%@",paths);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:@"GameScoreDb.sqlite"];
    //NSLog(@"%@",paths);
    // Check to see if the database file already exists
    
    
    /*if (databaseAlreadyExists == YES) {
     return;
     }*/
    
    // Open the database and store the handle as a data member
    if (sqlite3_open([databasePath UTF8String], &_databaseHandle) == SQLITE_OK)
    {
        // Create the database if it doesn't yet exists in the file system
        
        
        // Create the PERSON table
        const char *sqlStatement = "CREATE TABLE  GameScoreFinal (ID INTEGER PRIMARY KEY AUTOINCREMENT, Level TEXT, Score TEXT,PlayerFbId TEXT,Name TEXT)";
        /*NSString *insert=[NSString stringWithFormat:@"insert into person(id,firsrtname) VALUES(\"%@\",\"%@\")",1,"hunny"];*/
        /*  const char *insert="INSERT INTO PERSON (FIRSTNAME, LASTNAME, BIRTHDAY) VALUES ('""1'""'hunny'""'singh'""'1992-08-14')";*/
        char *error;
        if (sqlite3_exec(_databaseHandle, sqlStatement, NULL, NULL, &error) == SQLITE_OK)
        {
            NSLog(@"table created");
            // Create the ADDRESS table with foreign key to the PERSON table
            
            NSLog(@"Database and tables created.");
        }
        else
        {
            NSLog(@"````Error: %s", error);
        }
    }
    
    
}

-(void)synchronize
{
    PFQuery * queryUser=[PFQuery queryWithClassName:ParseScoreTableName];
    NSLog(@"Connected fb user id %@",[[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID]);
    [queryUser whereKey:@"PlayerFacebookID" equalTo:[[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID]];
    [queryUser orderByDescending:@"Level"];
    dispatch_async(dispatch_get_global_queue(0,0),^{
        NSArray *temp=[queryUser findObjects];
        if([temp count]>0)
        {
            //if data is present
            for(int i=0;i<[temp count];i++)
            {
                PFObject * objUserData=[temp objectAtIndex:i];
                for(int j=0;j<[localData count];j++)
                {
                    
                    NSDictionary * localtemp=[localData objectAtIndex:j];
                    [localtemp objectForKey:@"Score"];
                    if([objUserData[@"Level"] integerValue]==[[localtemp objectForKey:@"Level"] integerValue])
                    {
                        if([objUserData[@"Score"] integerValue]<[[localtemp objectForKey:@"Score"] integerValue])
                        {
                            objUserData[@"Score"]=[NSNumber numberWithInt:[[localtemp objectForKey:@"Score"] intValue]];
                            
                            [objUserData saveInBackground];
                        }//if
                        [localData removeObjectAtIndex:j];
                    }//if
                    
                }//for
            }//for
            for (int i=0; i<[localData count]; i++) {
                NSDictionary * localtemp=[localData objectAtIndex:i];
                PFObject * objNewData=[PFObject objectWithClassName:ParseScoreTableName];
                objNewData[@"Level"]=[NSNumber numberWithInt:[[localtemp objectForKey:@"Level"] intValue]];
                objNewData[@"Score"]=[NSNumber numberWithInt:[[localtemp objectForKey:@"Score"] intValue]];
                objNewData[@"PlayerFacebookID"]=[[NSUserDefaults standardUserDefaults]objectForKey:ConnectedFacebookUserID];
                NSString * name=[localtemp objectForKey:@"Name"];
                objNewData[@"Name"]=name;
                
//                [objNewData saveEventually:^(BOOL succeed, NSError *error){
//                    
//                    if (succeed) {
//                        NSLog(@"Save to Parse");
//                    }else{
//                        NSLog(@"Error to Save == %@",error.localizedDescription);
//                    }
//                }];

               [objNewData saveInBackground];
            }
            //check highest level
            if([localData count]>0)
            {
                NSDictionary * localtemp=[localData objectAtIndex:0];
                PFObject * objUserData=[temp objectAtIndex:0];
                if([objUserData[@"Level"] integerValue]>
                   [[localtemp objectForKey:@"Level"] integerValue])
                {
                    [[NSUserDefaults standardUserDefaults] setInteger:([objUserData[@"Level"] intValue]+1)forKey:@"levelClear"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                }
                else
                {
                    [[NSUserDefaults standardUserDefaults] setInteger:([[localtemp objectForKey:@"Level"] integerValue]+1)forKey:@"levelClear"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                }
            }
            else
            {//if local data is not there make parse data highest.
                PFObject * objUserData=[temp objectAtIndex:0];
                [[NSUserDefaults standardUserDefaults] setInteger:([objUserData[@"Level"] intValue]+1)forKey:@"levelClear"];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
        }//if
        else
        {
            //if data is not there
            if(master)
            {
                for(int i=0;i<[localData count];i++)
                {
                    PFObject * objUserData=[PFObject objectWithClassName:ParseScoreTableName];
                    //-------------------
                    NSDictionary * localtemp=[localData objectAtIndex:i];
                    ;
                    [localtemp objectForKey:@"Score"];
                    objUserData[@"Level"]=[NSNumber numberWithInt:[[localtemp objectForKey:@"Level"] intValue]];
                    objUserData[@"Score"]=[NSNumber numberWithInt:[[localtemp objectForKey:@"Score"] intValue]];
                    objUserData[@"PlayerFacebookID"]=[[NSUserDefaults standardUserDefaults]objectForKey:ConnectedFacebookUserID];
                    NSString * name=[localtemp objectForKey:@"Name"];
                    if ([name  isEqualToString:@"(null)"]) {
                        objUserData[@"Name"]=[[NSUserDefaults standardUserDefaults]objectForKey:@"ConnectedFacebookUserName"];
                    }
                    else
                    {
                        objUserData[@"Name"]=[NSString stringWithFormat:@"%@",[localtemp objectForKey:@"Name"]];
                    }
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    //----------------------
                    BOOL result=[objUserData save];
                    NSLog(@"result %d",result);
                }
                [self deleteLocalDataBase];
            }
            else
            {
                //if not master
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"levelClear"];
            }
        }
        
    });
    [self deleteLocalDataBase];
    NSLog(@"Local Data %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"LocalScoredDictionary"]);
    
}


-(void)deleteLocalDataBase
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"-------%@",paths);
    sqlite3_stmt *stmt=nil;
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:@"GameScoreDb.sqlite"];
    
    const char *sql = "Delete from GameScoreFinal";
    
    
    if(sqlite3_open([databasePath UTF8String], &_databaseHandle)!=SQLITE_OK)
        NSLog(@"error to open");
    if(sqlite3_prepare_v2(_databaseHandle, sql, -1, &stmt, NULL)!=SQLITE_OK)
    {
        NSLog(@"error to prepare");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(_databaseHandle), sqlite3_errcode(_databaseHandle));
        
        
    }
    if(sqlite3_step(stmt)==SQLITE_DONE)
    {
        NSLog(@"Delete successfully");
    }
    else
    {
        NSLog(@"Delete not successfully");
        
    }
    sqlite3_finalize(stmt);
    sqlite3_close(_databaseHandle);
    
    
}

-(void)retriveFromSQL
{
    localData=[[NSMutableArray alloc]init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSLog(@"%@",paths);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:@"GameScoreDb.sqlite"];
    NSLog(@"Connected fb user id %@",[[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID]);
    
    // Check to see if the database file already exists
    NSString * connectedFBid=[[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID];
    NSString *query = [NSString stringWithFormat:@"select * from GameScoreFinal where PlayerFbId = \"%@\" ORDER BY Level Desc",connectedFBid];
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
            char *playerFbid = (char *) sqlite3_column_text(stmt,3);
            char *name = (char *)  sqlite3_column_text(stmt,4);
            NSString *strLevel= [NSString  stringWithUTF8String:level];
            
            NSString *strScore  = [NSString stringWithUTF8String:score];
            NSString *playerFBid  = [NSString stringWithUTF8String:playerFbid];
            NSString *Name = [NSString stringWithUTF8String:name];
            NSLog(@"player FB ID %@",playerFBid);
            if([playerFBid isEqualToString:@"Master"])
            {
                master=TRUE;
            }
            NSLog(@"Level %@ and Score %@ ",strLevel,strScore);
            NSString * keyLevel=strLevel;
            NSString * keyScore=strScore;
            NSMutableDictionary * temp=[[NSMutableDictionary alloc]init];
            [temp setObject:keyLevel forKey:@"Level"];
            [temp setObject:keyScore forKey:@"Score"];
            [temp setObject:playerFBid forKey:@"PlayerFbID"];
            [temp setObject:Name forKey:@"Name"];
            [localData addObject:temp];
        }
    }
    @catch(NSException *e)
    {
        NSLog(@"%@",e);
    }
    
    
}


- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

    if (application.applicationIconBadgeNumber != 0) {
        application.applicationIconBadgeNumber = 0;
    }

    // Store the deviceToken in the current Installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    
    BOOL fbCheck = [[NSUserDefaults standardUserDefaults] boolForKey:FacebookConnected];
     NSString *fbID = [[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID];
    
    if (fbCheck==YES ) {
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        [currentInstallation setObject:fbID forKey:@"facebookId"] ;
        [currentInstallation saveInBackground];

    }
    
    [currentInstallation saveInBackground];
}

- (void)applicationWillResignActive:(UIApplication *)application {
	
    [[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CheckTimeForLife" object:nil];
    
        [FBAppCall handleDidBecomeActive];

        [[CCDirector sharedDirector] resume];
    
    [self reacheability];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application
{
   [[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
    [self reacheability];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reacheability) name:kReachabilityChangedNotification object:nil];
    
   	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director openGLView] removeFromSuperview];
	
	[viewController release];
	
	[window release];
	
	[director end];	
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
}
#pragma mark -

- (void) closeSession {
    [FBSession.activeSession closeAndClearTokenInformation];
}

- (BOOL)openSessionWithAllowLoginUI:(NSInteger)isLoginReq{
    
    // FBOpenGraphActionParams *params = [[FBOpenGraphActionParams alloc] init];
    
    
    
    self.CurrentValue = isLoginReq;
    NSArray *permissions = [[NSArray alloc] initWithObjects:@"public_profile",@"user_friends",@"publish_actions", nil];

    
    FBSession *session = [[FBSession alloc] initWithPermissions:permissions];
    // Set the active session
    [FBSession setActiveSession:session];
    
    //imports an existing access token and opens a session with it.....
    
    [session openWithBehavior:FBSessionLoginBehaviorWithNoFallbackToWebView
            completionHandler:^(FBSession *session,
                                FBSessionState status,
                                NSError *error) {
                
                if (error==nil) {
                    
                    FBAccessTokenData *tokenData= session.accessTokenData;
                    
                    NSString *accessToken = tokenData.accessToken;
                    NSLog(@"AccessToken1==%@",accessToken);
                    
                    
                    if (!tokenData.accessToken) {
                        accessToken =[[NSUserDefaults standardUserDefaults]objectForKey:@"accessToken"];
                    }
                    else{
                        accessToken = tokenData.accessToken;
                    }

                    
                    [self fetchFacebookGameFriends:accessToken];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"accessToken"];
                    
                    /*    Simple method to make a graph API request for user friends (/me/friends), creates an <FBRequest>
                     then uses an <FBRequestConnection> object to start the connection with Facebook. The
                     request uses the active session represented by `[FBSession activeSession]`.*/
                    
                    [FBRequestConnection
                     startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                                       id<FBGraphUser> user,
                                                       NSError *error){
                         NSLog(@"User = %@", user);
                         BOOL fbconnect=[[NSUserDefaults standardUserDefaults]boolForKey:FacebookConnected];
                         if (fbconnect) {
                             [[NSUserDefaults standardUserDefaults] setBool:NO forKey :FacebookConnected];
                             [[NSUserDefaults standardUserDefaults]synchronize];
                         }
                         else{
                         NSString *userName = [NSString stringWithFormat:@"%@",[user objectForKey:@"first_name"]];
                         NSString *userID = [NSString stringWithFormat:@"%@",[user objectForKey:@"id"]];
                         
                             
                             
                         [[NSUserDefaults standardUserDefaults] setBool:YES forKey :FacebookConnected];
                         [[NSUserDefaults standardUserDefaults] setObject:userID forKey:ConnectedFacebookUserID];
                         [[NSUserDefaults standardUserDefaults] setObject:userName  forKey:@"ConnectedFacebookUserName"];
                         [[NSUserDefaults standardUserDefaults]synchronize];
                             
                             NSString *fbID = [[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID];
                             PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                             [currentInstallation setObject:fbID forKey:@"facebookId"] ;
                             [currentInstallation saveInBackground];

                         
                         }
                     }];
                }
                else{
                    
                    NSLog(@"Session not open==%@",error);
                }
                
                // Respond to session state changes,
                // ex: updating the view
            }];
    return YES;
}

//mine.

/*
-(void) fetchFacebookGameFriends:(NSString *)accessToken{
    NSString *query =
    @"SELECT uid, name, pic_small FROM user WHERE is_app_user = 1 and uid IN "
    @"(SELECT uid2 FROM friend WHERE uid1 = me() )";
    
    NSDictionary *queryParam = @{ @"q": query, @"access_token":accessToken };
    // Make the API request that uses FQL
    [FBRequestConnection startWithGraphPath:@"/fql"parameters:queryParam HTTPMethod:@"GET"completionHandler:^(FBRequestConnection *connection,id result,NSError *error) {
        if (error) {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
        else {
            // NSLog(@"Result: %@", result);
            
            NSArray *friendInfo = (NSArray *) result[@"data"];
            
//            NSLog(@"Array Count==%lu",(unsigned long)[friendInfo count]);
//            
//            NSLog(@"\n\nArray==%@",friendInfo);
            
            NSMutableArray *frndsarray = [[NSMutableArray alloc] init];
            NSMutableArray *frndNamearray=[[NSMutableArray alloc] init];
            for (int i =0; i<friendInfo.count; i++) {
                NSDictionary *dict = [friendInfo objectAtIndex:i];
                NSString *fbID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"uid"]];
                
                
                NSString *fbName =[NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
                [frndsarray addObject:fbID];
                [frndNamearray addObject:fbName];
                
            }//End For Loop
            [[NSUserDefaults standardUserDefaults] setObject:frndsarray forKey:FacebookGameFrindes];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [[NSUserDefaults standardUserDefaults]setObject:frndNamearray forKey:@"name1"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            
            
            FBRequest *friendRequest = [FBRequest requestForGraphPath:@"me/invitable_friends?fields=name,picture,id"];
            
            [friendRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                NSArray *invite_friendInfo = (NSArray *) result[@"data"];
                
//                NSLog(@"Array Count==%lu",(unsigned long)[invite_friendInfo count]);
//                NSLog(@"ARRAY = %@",invite_friendInfo);
                //========================
                NSMutableArray *inviteFrndsAry = [[NSMutableArray alloc] init];
                
                for (int i =0; i<invite_friendInfo.count; i++) {
                    NSDictionary *dict = [invite_friendInfo objectAtIndex:i];
                    NSMutableDictionary *aDict = [[NSMutableDictionary alloc] init];
                    
                    NSString *aid = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
                    //NSLog(@"aid = %@",aid);
                    [aDict setObject:aid forKey:@"uid"];
                    NSString *name = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
                    [aDict setObject:name forKey:@"name"];
                    NSDictionary *secDict = [[dict objectForKey:@"picture"] objectForKey:@"data"];
                    NSString *picUrl = [NSString stringWithFormat:@"%@",[secDict objectForKey:@"url"]];
                    [aDict setObject:picUrl forKey:@"pic_small"];
                    
                    [inviteFrndsAry addObject:aDict];
                }
                
                [[NSUserDefaults standardUserDefaults] setObject:inviteFrndsAry forKey:FacebookInviteFriends];
                
                NSArray *allFrndsArray = [friendInfo arrayByAddingObjectsFromArray:inviteFrndsAry];
//                NSLog(@"All Friends Array = %@",allFrndsArray);
                [[NSUserDefaults standardUserDefaults] setObject:allFrndsArray forKey:FacebookAllFriends];
                
                if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(displayFacebookFriendsList)]) {
                    
                    [self.delegate displayFacebookFriendsList];
                }
            }];
            
            
            
        }
       
    }];

}
*/
-(void) fetchAllFacebookFriends{
    
    FBRequest *friendRequest = [FBRequest requestForGraphPath:@"me/invitable_friends?fields=name,picture,id"];
    [friendRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        NSArray *friendInfo = (NSArray *) result[@"data"];
        
        NSLog(@"Array Count==%lu",(unsigned long)[friendInfo count]);
        NSLog(@"ARRAY = %@",friendInfo);
        //================================
        
    }];
    FBRequest *friendRequest1 = [FBRequest requestForGraphPath:@"me/friends?fields=name,picture,id"];
    [friendRequest1 startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        NSLog(@"Data == %@",result);
    }];
}

//khomesh

-(void) fetchFacebookGameFriends:(NSString *)accessToken{
    NSString *query =
    @"SELECT uid, name, pic_small FROM user WHERE is_app_user = 1 and uid IN "
    @"(SELECT uid2 FROM friend WHERE uid1 = me() )";
    
    NSDictionary *queryParam = @{ @"q": query, @"access_token":accessToken };
    // Make the API request that uses FQL
    [FBRequestConnection startWithGraphPath:@"/fql"parameters:queryParam HTTPMethod:@"GET"completionHandler:^(FBRequestConnection *connection,id result,NSError *error) {
        if (error) {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
        else {
            // NSLog(@"Result: %@", result);
            
            NSArray *friendInfo = (NSArray *) result[@"data"];
            
            NSLog(@"Array Count==%lu",(unsigned long)[friendInfo count]);
            
            NSLog(@"\n\nArray==%@",friendInfo);
            
            NSMutableArray *frndsarray = [[NSMutableArray alloc] init];
            NSMutableArray *frndNamearray=[[NSMutableArray alloc] init];
            for (int i =0; i<friendInfo.count; i++) {
                NSDictionary *dict = [friendInfo objectAtIndex:i];
                NSString *fbID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"uid"]];
                NSString *fbName =[NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
                [frndsarray addObject:fbID];
                [frndNamearray addObject:fbName];
                
            }//End For Loop
            
            [[NSUserDefaults standardUserDefaults] setObject:frndsarray forKey:FacebookGameFrindes];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [[NSUserDefaults standardUserDefaults]setObject:frndNamearray forKey:@"name"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            FBRequest *friendRequest = [FBRequest requestForGraphPath:@"me/invitable_friends?fields=name,picture,id"];
            
            [friendRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                NSArray *invite_friendInfo = (NSArray *) result[@"data"];
                
                //                NSLog(@"Array Count==%lu",(unsigned long)[invite_friendInfo count]);
                //                NSLog(@"ARRAY = %@",invite_friendInfo);
                //========================
                NSMutableArray *inviteFrndsAry = [[NSMutableArray alloc] init];
                
                for (int i =0; i<invite_friendInfo.count; i++) {
                    NSDictionary *dict = [invite_friendInfo objectAtIndex:i];
                    NSMutableDictionary *aDict = [[NSMutableDictionary alloc] init];
                    
                    NSString *aid = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
                    //NSLog(@"aid = %@",aid);
                    [aDict setObject:aid forKey:@"uid"];
                    NSString *name = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
                    [aDict setObject:name forKey:@"name"];
                    NSDictionary *secDict = [[dict objectForKey:@"picture"] objectForKey:@"data"];
                    NSString *picUrl = [NSString stringWithFormat:@"%@",[secDict objectForKey:@"url"]];
                    [aDict setObject:picUrl forKey:@"pic_small"];
                    
                    [inviteFrndsAry addObject:aDict];
                }
                
                [[NSUserDefaults standardUserDefaults] setObject:inviteFrndsAry forKey:FacebookInviteFriends];
                
                NSArray *allFrndsArray = [friendInfo arrayByAddingObjectsFromArray:inviteFrndsAry];
                NSLog(@"All Friends Array = %@",allFrndsArray);
                NSMutableArray *tagbl_FrndAry=[[NSMutableArray alloc] init];
                [FBRequestConnection startWithGraphPath:@"/me/taggable_friends"
                                             parameters:nil
                                             HTTPMethod:@"GET"
                                      completionHandler:^(
                                                          FBRequestConnection *connection,
                                                          id result,
                                                          NSError *error
                                                          ) {
                                          NSArray *arr=[result valueForKey:@"data"];
                                          
                                          for (NSDictionary *dict in arr) {
                                              
                                              NSMutableDictionary *aDict = [[NSMutableDictionary alloc] init];
                                              
                                              NSString *aid = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
                                              //NSLog(@"aid = %@",aid);
                                              [aDict setObject:aid forKey:@"uid"];
                                              NSString *name = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
                                              [aDict setObject:name forKey:@"name"];
                                              NSDictionary *secDict = [[dict objectForKey:@"picture"] objectForKey:@"data"];
                                              NSString *picUrl = [NSString stringWithFormat:@"%@",[secDict objectForKey:@"url"]];
                                              [aDict setObject:picUrl forKey:@"pic_small"];
                                              
                                              [tagbl_FrndAry addObject:aDict];
                                              
                                          }
                                          
                                          [[NSUserDefaults standardUserDefaults] setObject:tagbl_FrndAry forKey:FacebookAllFriends];
                                      }];
                
                [[NSUserDefaults standardUserDefaults] setObject:tagbl_FrndAry forKey:FacebookAllFriends];
                NSLog(@"All Friends Array = %@",tagbl_FrndAry);
                if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(displayFacebookFriendsList)]) {
                    
                    [self.delegate displayFacebookFriendsList];
                }
            }];
            
        }
    }];
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    //return [FBSession.activeSession handleOpenURL:url];

    NSLog(@"url is %@",url);
    NSString *check = [url absoluteString];
    
    NSString *substring = @"access_token";
    
    NSRange textRange = [check rangeOfString:substring];
    
    if(textRange.location != NSNotFound){
        //Does contain the substring
        NSLog(@"contains the string");
//         [[NSNotificationCenter defaultCenter] postNotificationName:@"hideaction" object:nil];
        }else{
        //Does not contain the substring
            NSLog(@"does not contain string");
    }
    
    [PFFacebookUtils handleOpenURL:url];
    
    [FBAppCall handleOpenURL:url sourceApplication:sourceApplication fallbackHandler:^(FBAppCall *call) {
        NSString *accessToken = call.accessTokenData.accessToken;
        [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"Facebook Access Token"];
        NSLog(@"Access Token = %@",call.accessTokenData.accessToken);
        NSLog(@"App Link Data = %@",call.appLinkData);
        NSLog(@"call == %@",call);
        
        if (call.appLinkData && call.appLinkData.targetURL) {
            
            //[self openSessionWithLoginUI:8 withParams:nil];
//            [[NSNotificationCenter defaultCenter] postNotificationName:FacebookRequestNotification object:call.appLinkData.targetURL];
        }
        
    }];
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    NSLog(@"Url== %@", url);
    return [FBSession.activeSession handleOpenURL:url];
}


-(void)dealloc {
	[[CCDirector sharedDirector] end];
	[window release];
	[super dealloc];
}


#pragma mark -
/*
-(BOOL) openSessionWithLoginUI:(NSInteger)value withParams: (NSDictionary *)dict{
   // NSArray *permissions = [[NSArray alloc] initWithObjects:@"public_profile",@"email",@"status_update",@"user_photos",@"user_birthday",@"user_about_me",@"user_friends",@"photo_upload",@"read_friendlists",@"publish_actions", nil];
    NSArray *permissions = [[NSArray alloc] initWithObjects:@"public_profile",@"user_friends",@"publish_actions", nil];
    
    FBSession *session = [[FBSession alloc] initWithPermissions:permissions];
    // Set the active session
    [FBSession setActiveSession:session];
    ms_friendCache = NULL;
    
    [session openWithBehavior:FBSessionLoginBehaviorWithNoFallbackToWebView
            completionHandler:^(FBSession *session,
                                FBSessionState status,
                                NSError *error) {
                
                if (error==nil) {
                    //[NSThread detachNewThreadSelector:@selector(fetchFacebookGameFriends) toTarget:self withObject:nil];
                    FBAccessTokenData *tokenData= session.accessTokenData;
                    
                    NSString *accessToken = tokenData.accessToken;
                    
                    if (!tokenData.accessToken) {
                       accessToken =[[NSUserDefaults standardUserDefaults]objectForKey:@"accessToken"];
                    }
                    else{
                        accessToken = tokenData.accessToken;
                    }
                    
                    NSLog(@"AccessToken==%@",accessToken);
                    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"accessToken"];
                    
                    [self fetchFacebookGameFriends:accessToken];
                    
                    if (value==1) {
                        
                        [self shareOnFacebookWithParams:dict];
                    }
                    else if (value == 2){
                        
                        [self shareBeatStoryWithParams:dict];
                    }
                    else if (value ==3 ){
                        //say thank you story post .
                        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                        [appDelegate storyPostwithDictionary:dict];

                    }
                    else if(value == 8){
                        
//                        [self fetchAllFacebookFriends];
//                       [self fetchFacebookGameFriends:accessToken];
                       
                
                    } else if(value == 9){
                         [self shareOnFacebookWithParamsForLives:dict];
                        
                    }
                    
                    else{
                        NSLog(@"Unknown Value");
                    }
                    
                    [FBRequestConnection
                     startForMeWithCompletionHandler:^(FBRequestConnection *connection,id<FBGraphUser> user,NSError *error){
                         NSLog(@"User = %@",user);
                         NSString *userName = [NSString stringWithFormat:@"%@",[user objectForKey:@"first_name"]];
                         NSString *userID = [NSString stringWithFormat:@"%@",[user objectForKey:@"id"]];
                         

                         [[NSUserDefaults standardUserDefaults] setBool:YES forKey :FacebookConnected];
                         [[NSUserDefaults standardUserDefaults] setObject:userID forKey:ConnectedFacebookUserID];
                         
                         NSString *fbID = [[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID];
                         
                      
                        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                        [currentInstallation setObject:fbID forKey:@"facebookId"] ;
                             [currentInstallation saveInBackground];
                         
                         [[NSUserDefaults standardUserDefaults] setObject:userName  forKey:@"ConnectedFacebookUserName"];
                         [[NSUserDefaults standardUserDefaults]synchronize];

                     }];
                    
                    // [self retriveAllfriends];
                }
                else{
                    
                    NSLog(@"Session not open==%@",error);
                }
                
                // Respond to session state changes,
                // ex: updating the view
            }];
    
    return YES;
}
*/

-(BOOL) openSessionWithLoginUI:(NSInteger)value withParams: (NSDictionary *)dict withString:(NSMutableString *)string{
    
    [self retriveFromSQL];
    
    NSArray *permissions = [[NSArray alloc] initWithObjects:@"public_profile",@"user_friends",@"publish_actions", nil];
    
    FBSession *session = [[FBSession alloc] initWithPermissions:permissions];
    // Set the active session
    [FBSession setActiveSession:session];
    ms_friendCache = NULL;
    
    [session openWithBehavior:FBSessionLoginBehaviorWithNoFallbackToWebView
            completionHandler:^(FBSession *session,
                                FBSessionState status,
                                NSError *error) {
                
                if (error==nil) {
//                  [[AppDelegate sharedAppDelegate]showHUDLoadingView:@"please wait"];
                    FBAccessTokenData *tokenData= session.accessTokenData;
                    
                    NSString *accessToken = tokenData.accessToken;
                    NSLog(@"AccessToken==%@",accessToken);
                    
                    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"accessToken"];
                    
                    
                    if (value==1) {
                        [[AppDelegate sharedAppDelegate]hideHUDLoadingView];
                        [self shareOnFacebookWithParamsForLives:dict];
//                        [self shareOnFacebookWithParams:dict];
                    }
                    else if (value == 2){
                          [[AppDelegate sharedAppDelegate]hideHUDLoadingView];
                        [self shareOnFacebookFeedDialog:dict];
                    }
                    else if(value == 8){
                        
                        
                    }
                    else if(value == 3){
                        [[AppDelegate sharedAppDelegate]hideHUDLoadingView];
                        [self storyPostwithDictionary:dict];
                    }
                    else if(value == 7){
                        [[AppDelegate sharedAppDelegate]hideHUDLoadingView];
                        [self sendRequestToFriends:string];
                    }
                    
                    else{
                        NSLog(@"Unknown Value");
                    }
                    
                    
                    if(value == 8){
                          [[AppDelegate sharedAppDelegate]hideHUDLoadingView];
                        [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection,id<FBGraphUser> user,NSError *error){
                            
                          
                            
                            NSLog(@"User = %@",user);
                            
                            
                            NSString *userName = [NSString stringWithFormat:@"%@",[user objectForKey:@"name"]];
                            NSString *userID = [NSString stringWithFormat:@"%@",[user objectForKey:@"id"]];
                            
                            if (accessToken) {
                                
                                 [[NSNotificationCenter defaultCenter] postNotificationName:@"success" object:nil];
                                  [self fetchFacebookGameFriends:accessToken];
//                                [self tag:accessToken];
                                
                                [[NSUserDefaults standardUserDefaults] setBool:YES forKey :FacebookConnected];
                                [[NSUserDefaults standardUserDefaults] setObject:userID forKey:ConnectedFacebookUserID];
                                [[NSUserDefaults standardUserDefaults] setObject:userName  forKey:@"ConnectedFacebookUserName"];
                                [[NSUserDefaults standardUserDefaults]synchronize];
                                
                                [self synchronize];
                                
                            }else{
                                [[NSUserDefaults standardUserDefaults] setBool:NO forKey :FacebookConnected];
//                                [[NSUserDefaults standardUserDefaults] removeObjectForKey:ConnectedFacebookUserID];
//                  [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"ConnectedFacebookUserName" ];
                                [[NSUserDefaults standardUserDefaults]synchronize];
                            
                            }
                            
//                           [self findPlayerLevel];
                            
                            PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                            
                            
                            BOOL fbCheck = [[NSUserDefaults standardUserDefaults] boolForKey:FacebookConnected];
                            NSString *fbID = [[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID];
                            
                            if (fbCheck==YES ) {
                                [currentInstallation setObject:fbID forKey:@"facebookId"] ;
                                
                            }
                            
                            [currentInstallation saveInBackground];
                            
                        }];
                        
                        
                    }
                }
                else{
                    
                    NSLog(@"Session not open==%@",error);
                    
                      [[NSNotificationCenter defaultCenter] postNotificationName:@"failure" object:nil];
                }
                
                // Respond to session state changes,
                // ex: updating the view
            }];
    
    return YES;
}



-(void)postTabbaleDictionary:(NSDictionary *)dict{
    
    NSString *description = [NSString stringWithFormat:@"%@",[dict objectForKey:FacebookDescription]];
    NSString *title = [NSString stringWithFormat:@"%@",[dict objectForKey:FacebookTitle]];
    
    NSString *type = [NSString stringWithFormat:@"%@",[dict objectForKey:FacebookType]];
    
    NSString *actionType = [NSString stringWithFormat:@"/me/caverunapp:%@",[dict objectForKey:FacebookActionType]];
    NSLog(@"Type = %@", type);
    NSLog(@"Action  =%@",actionType);
    
    
    //fbstaging://graph.facebook.com/staging_resources/MDExNDQyNjIzMzQyNjc3NjM2OjUxMDY4MTkwNg==
    
    id<FBGraphObject> object =
    [FBGraphObject openGraphObjectForPostWithType:[NSString stringWithFormat:@"caverunapp:%@",type] title:title image:@"fbstaging://graph.facebook.com/staging_resources/MDExNDUzNzA0ODM4MjM2MTUzOjMwMDU2ODE2Mg==" url:@"https://itunes.apple.com/app/id903886678" description:description];
    
    id<FBOpenGraphAction> action = (id<FBOpenGraphAction>)[FBGraphObject graphObject];
    [action setObject:object forKey:type];
    
    // create action referencing user owned object
    [FBRequestConnection startForPostWithGraphPath:actionType graphObject:action completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if(!error) {
            NSLog(@"OG story posted, story id: %@", [result objectForKey:@"id"]);
            //            [[[UIAlertView alloc] initWithTitle:@"OG story posted" message:@"Check your Facebook profile or activity log to see the story."
            //                                       delegate:self
            //                              cancelButtonTitle:@"OK!"
            //                              otherButtonTitles:nil] show];
        } else {
            // An error occurred
            NSLog(@"Encountered an error posting to Open Graph: %@", error);
        }
    }];

    
}

-(void)findPlayerLevel{
    
    
    NSString *fbID = [[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID];
    
    if (fbID) {
        
        PFQuery * query=[PFQuery queryWithClassName:ParseScoreTableName];
        [query whereKey:@"PlayerFacebookID" equalTo:fbID];
        [query orderByDescending:@"Level"];
        
        //       NSArray *num= [query getFirstObject];
        
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            
            NSNumber *num=object[@"Level"];
            int num1 = [num intValue]+1;
            [[NSUserDefaults standardUserDefaults] setInteger:num1  forKey:@"levelClear"];
            //[[NSUserDefaults standardUserDefaults] setInteger:50 forKey:@"levelClear"];
            [GameState sharedState].levelNumber=num1;
//             [[AppDelegate sharedAppDelegate]hideHUDLoadingView];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
        }];
    }
}



-(void) shareOnFacebookFeedDialog:(NSDictionary *)params{
    
    [FBWebDialogs presentFeedDialogModallyWithSession:nil parameters:params handler:^(FBWebDialogResult result, NSURL *resultUrl, NSError *error){
        
        if (error) {
            NSLog(@"Error to post on facebook = %@", [error localizedDescription]);
        }
        else{
            
            
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

-(void) shareBeatStoryWithParams:(NSDictionary *)params{
    
    
    [FBWebDialogs presentFeedDialogModallyWithSession:nil parameters:params handler:^(FBWebDialogResult result,NSURL *resultUrl, NSError *error){
        
        if (error) {
            NSLog(@"Error to post on facebook = %@", [error localizedDescription]);
        }
        else{
            
            
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

-(void) shareOnFacebookWithParams:(NSDictionary *)params{
    
    if (self.openGraphDict != nil) {
        [self storyPostwithDictionary:self.openGraphDict];
    }
 }

-(void) shareOnFacebookWithParamsForLives:(NSDictionary *)params{
    

    NSString * strMessge = @" Please join me friends in Cave Run Mowgli game. ";
     NSMutableDictionary *params1 =[NSMutableDictionary dictionaryWithObjectsAndKeys:
     strMessge, @"description",
     @"https://itunes.apple.com/app/id903886678", @"link",@"Cave Run Mowgli",@"name",
     @"i.imgur.com/1612f7A.png?1",@"picture",
     nil];

    [FBWebDialogs presentFeedDialogModallyWithSession:nil parameters:params handler:^(FBWebDialogResult result, NSURL *resultUrl, NSError *error){
        
        if (error) {
            NSLog(@"Error to post on facebook = %@", [error localizedDescription]);
        }
        else{
            
            
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
                    
                    NSLog(@"here");
                    
                    int life=(int)[[NSUserDefaults standardUserDefaults] integerForKey:@"live"];
                    NSLog(@"life is %d",life);
                    if (life<=0)
                    {
                        life=life+5;
                        NSLog(@"Added One life");
                    }
                    
                    [[NSUserDefaults standardUserDefaults]setInteger:life forKey:@"live"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                    [GameState sharedState].shareOnFacebook=YES;
                    
                   [[NSNotificationCenter defaultCenter] postNotificationName:@"backaction" object:nil];
                    
                    UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"You got 5 Lives! Enjoy the game" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [view show];

                }
            }//End Else Block Result Check
        }
    }];
}

-(void) sendRequestToFriends:(NSMutableString *)params{
    
      [[AppDelegate sharedAppDelegate]showHUDLoadingView:@""];
    
    NSMutableDictionary<FBGraphObject> *object =
    [FBGraphObject openGraphObjectForPostWithType:@"caverunapp:life"
                                            title:@""
                                            image:@"fbstaging://graph.facebook.com/staging_resources/MDExNDUzNzA0ODM4MjM2MTUzOjMwMDU2ODE2Mg=="
                                              url:@"https://itunes.apple.com/app/id903886678"
                                      description:@"Hi Friends, Please join me in Cave Run Mowgli and help Mowgli clear the various levels of his jungle, collect coins and save himself from monsters."];
    
    NSMutableDictionary<FBGraphObject> *action = [FBGraphObject openGraphActionForPost];
    action[@"tags"]=params;
    action[@"life"]=object;
    
    
    [FBRequestConnection startForPostWithGraphPath:@"me/caverunapp:request"
                                       graphObject:action
                                 completionHandler:^(FBRequestConnection *connection,
                                                     id result,
                                                     NSError *error) {
                                     
                                     [[AppDelegate sharedAppDelegate]hideHUDLoadingView];
                                     
                                     if (!error) {
                                         NSLog(@"self.friends count is ======= %d",self.friendsCount);
                                         [[NSUserDefaults standardUserDefaults]setInteger:self.friendsCount/5 forKey:@"live"];
                                         [[NSUserDefaults standardUserDefaults]synchronize];
                                         
                                         [[NSNotificationCenter defaultCenter] postNotificationName:@"showui" object:nil];

                                     }else{
                                         NSLog(@"error %@",error.description);
                                         [[AppDelegate sharedAppDelegate]showToastMessage:@"Error on posting to facebook, please try again later . "];;
                                         
                                     }
                                     // handle the result
                                 }];
                [[NSUserDefaults standardUserDefaults]synchronize];
}


-(void) storyPostwithDictionary:(NSDictionary *)dict{
    
    //http://www.screencast.com/t/S0YR7HvL4L
    
    NSString *description = [NSString stringWithFormat:@"%@",[dict objectForKey:FacebookDescription]];
    NSString *title = [NSString stringWithFormat:@"%@",[dict objectForKey:FacebookTitle]];
    
    NSString *type = [NSString stringWithFormat:@"%@",[dict objectForKey:FacebookType]];
    
    NSString *actionType = [NSString stringWithFormat:@"/me/caverunapp:%@",[dict objectForKey:FacebookActionType]];
    NSLog(@"Type = %@", type);
    NSLog(@"Action  =%@",actionType);
    
    
    //fbstaging://graph.facebook.com/staging_resources/MDExNDQyNjIzMzQyNjc3NjM2OjUxMDY4MTkwNg==
    
    id<FBGraphObject> object =
    [FBGraphObject openGraphObjectForPostWithType:[NSString stringWithFormat:@"caverunapp:%@",type] title:title image:@"fbstaging://graph.facebook.com/staging_resources/MDExNDUzNzA0ODM4MjM2MTUzOjMwMDU2ODE2Mg==" url:@"https://itunes.apple.com/app/id903886678" description:description];
    
    id<FBOpenGraphAction> action = (id<FBOpenGraphAction>)[FBGraphObject graphObject];
    [action setObject:object forKey:type];
    
    // create action referencing user owned object
    [FBRequestConnection startForPostWithGraphPath:actionType graphObject:action completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if(!error) {
            NSLog(@"OG story posted, story id: %@", [result objectForKey:@"id"]);
//            [[[UIAlertView alloc] initWithTitle:@"OG story posted" message:@"Check your Facebook profile or activity log to see the story."
//                                       delegate:self
//                              cancelButtonTitle:@"OK!"
//                              otherButtonTitles:nil] show];
        } else {
            // An error occurred
            NSLog(@"Encountered an error posting to Open Graph: %@", error);
        }
    }];
}

#pragma Reacheability

-(void)reacheability
{
   // NSLog(@"Rechability");
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    BOOL networkStatus = NO;
    
    if(status == NotReachable)
    {
       // NSLog(@"stringgk////");
        networkStatus = NO;
    }
    else if (status == ReachableViaWiFi)
    {
       // NSLog(@"reachable");
        networkStatus = YES;
        
    }
    else if (status == ReachableViaWWAN)
    {
        //3G
        networkStatus = YES;
    }
    else
    {
        networkStatus = NO;
    }
    // Do any additional setup after loading the view.
    
    [[NSUserDefaults standardUserDefaults] setBool:networkStatus forKey:CurrentNetworkStatus];
}

#pragma mark-
- (IBAction)pickFriendsButtonClick:(id)sender {
    // FBSample logic
    // if the session is open, then load the data for our view controller
    
    if (self.friendPickerController == nil) {
        // Create friend picker, and get data loaded into it.
        self.friendPickerController = [[FBFriendPickerViewController alloc] init];
        self.friendPickerController.title = @"Pick Friends";
        self.friendPickerController.delegate = self;
    }
    
    [self.friendPickerController loadData];
    [self.friendPickerController clearSelection];
    
    [viewController presentViewController:self.friendPickerController animated:YES completion:nil];
}

#pragma mark --- chartboost delegate methods. 

- (BOOL)shouldDisplayRewardedVideo:(CBLocation)location{
    
    NSLog(@"here");
    return YES;
}

- (void)didDisplayRewardedVideo:(CBLocation)location{
    NSLog(@"here");
}

- (void)didCacheRewardedVideo:(CBLocation)location{
    NSLog(@"here");
    
}

- (void)didFailToLoadRewardedVideo:(CBLocation)location
                         withError:(CBLoadError)error{
    NSLog(@"here");
}

- (void)didDismissRewardedVideo:(CBLocation)location{
    NSLog(@"here");
//    [GameState sharedState].checkAd = YES ;
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"adpost" object:nil];

//    [[CCDirector sharedDirector]replaceScene:[CCTransitionFadeTR transitionWithDuration:0.1 scene:[LifeOver scene]]];
}

- (void)didCloseRewardedVideo:(CBLocation)location{
    NSLog(@"here");
//    [GameState sharedState].checkAd = YES ;
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"adpost" object:nil];

//    [[CCDirector sharedDirector]replaceScene:[CCTransitionFadeTR transitionWithDuration:0.1 scene:[LifeOver scene]]];
}

- (void)didClickRewardedVideo:(CBLocation)location{
    NSLog(@"here");
}

- (void)didCompleteRewardedVideo:(CBLocation)location
                      withReward:(int)reward{
    NSLog(@"here");
    
    int life=(int)[[NSUserDefaults standardUserDefaults] integerForKey:@"live"];
    if (life<=0)
    {
        life=life+reward;
        NSLog(@"Added One life");
    }
    [[NSUserDefaults standardUserDefaults]setInteger:life forKey:@"live"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
//     [[NSNotificationCenter defaultCenter]postNotificationName:@"adpost" object:nil];
//     Player *player=(Player*)self.pl;
//    [player readyForNewGame1];
//    ccTime *de;
//    [player update:*de];
    
    
}

- (void)didCacheInPlay:(CBLocation)location{
    NSLog(@"here");
}

- (void)didFailToLoadInPlay:(CBLocation)location
                  withError:(CBLoadError)error{
    NSLog(@"here");
}

- (void)willDisplayVideo:(CBLocation)location{
    NSLog(@"here");
}

#pragma mark -
#pragma mark - Loading View

-(void) showHUDLoadingView:(NSString *)strTitle
{
    HUD = [[MBProgressHUD alloc] initWithView:self.window];
    [self.window addSubview:HUD];
    //HUD.delegate = self;
    //HUD.labelText = [strTitle isEqualToString:@""] ? @"Loading...":strTitle;
    HUD.detailsLabelText=[strTitle isEqualToString:@""] ? @"Loading...":strTitle;
    [HUD show:YES];
}

-(void)showBannerAdd{
   

    
    if ([GameState sharedState].bottomBanner==YES)  {
//        NSLog(@"self.window.frame.size.width is %@",)
        self.frame1 = CGRectMake(self.window.frame.size.width-50,0,50,self.window.frame.size.height);
    }else{
         self.frame1 = CGRectMake(0,self.window.frame.size.width-50,self.window.frame.size.height,50);
    }
    bannerView = [[GADBannerView alloc]initWithFrame:self.frame1];
//    bannerView.window.frame = self.frame1;
   
    //    bannerView = [[GADBannerView alloc]initWithAdSize:GADAdSizeFullWidthLandscapeWithHeight(35) origin:0.0];
//    bannerView = [[GADBannerView alloc]initWithAdSize:GADAdSizeFromCGSize(<#CGSize size#>)];
   
    //Live Admob Code
    //    self.bannerView.adUnitID = @"ca-app-pub-7881880964352996/1647673665";
    
    // Test Admob Code
    bannerView.adUnitID =@"ca-app-pub-8909749042921180/1973833957";
    
   bannerView.rootViewController = self.window.rootViewController;
    bannerView.delegate = self ;
    [self.window addSubview:bannerView];
    
    GADRequest *request = [GADRequest alloc] ;
    //    request.testDevices = [NSArray arrayWithObjects:GAD_SIMULATOR_ID,@"TheIDAppearingInLogs",nil];//
    [bannerView loadRequest:request];
//    bannerView.hidden = NO;

}

-(void)hideBannerAd{

    bannerView.hidden = YES;

}

-(void) hideHUDLoadingView
{
    [HUD removeFromSuperview];
}

-(void)showToastMessage:(NSString *)message
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window
                                              animated:YES];
        // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = message;
    hud.margin = 10.f;
    hud.yOffset = 130.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2.0];
}

+(AppDelegate *)sharedAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


@end
