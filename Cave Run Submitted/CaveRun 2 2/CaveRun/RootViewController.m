//
//  RootViewController.m
//  CaveRun
//
//  Created by tang on 12-6-4.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

//
// RootViewController + iAd
// If you want to support iAd, use this class as the controller of your iAd
//

#import "cocos2d.h"
#import "SBJson.h"
#import "RootViewController.h"
#import "GameConfig.h"
#import "AppDelegate.h"
#import "GameState.h"
#import "GADRequest.h"


@implementation RootViewController


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showbanner) name:@"showbanner" object:nil];
          [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hidebanner) name:@"hidebanner" object:nil];

        if ([GameState sharedState].bottomBanner==YES)  {
            self.frame1 = CGRectMake(0,self.view.frame.size.width-35,self.view.frame.size.height,35);
        }else{
            self.frame1 = CGRectMake(0,0,self.view.frame.size.height, 35);
        }
        
        bannerView = [[GADBannerView alloc]initWithFrame:self.frame1];
//        bannerView.window.frame = self.frame1;
        
        //    bannerView = [[GADBannerView alloc]initWithAdSize:GADAdSizeFullWidthLandscapeWithHeight(35) origin:0.0];
        //    bannerView = [[GADBannerView alloc]initWithAdSize:GADAdSizeFromCGSize(<#CGSize size#>)];
        
        //Live Admob Code
        //    self.bannerView.adUnitID = @"ca-app-pub-7881880964352996/1647673665";
        
        // Test Admob Code
        bannerView.adUnitID =@"ca-app-pub-8909749042921180/1973833957";
        
        bannerView.rootViewController = self;
        bannerView.delegate = self ;
        [self.view addSubview:bannerView];
        
        GADRequest *request = [GADRequest alloc] ;
        //    request.testDevices = [NSArray arrayWithObjects:GAD_SIMULATOR_ID,@"TheIDAppearingInLogs",nil];//
        [bannerView loadRequest:request];
//        bannerView.hidden = YES;

	}
	return self;
}
-(void)showbanner{
    bannerView.hidden = NO;
}
-(void)hidebanner{
    bannerView.hidden = YES;
}
/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */


 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
	[super viewDidLoad];
    /*
     if ([GameState sharedState].bottomBanner==YES)  {
         self.frame1 = CGRectMake(0,self.view.frame.size.width-35,self.view.frame.size.height,35);
     }else{
         self.frame1 = CGRectMake(0,100,self.view.frame.size.height, 35);
     }
     
     //    self.frame1 = CGRectMake(0,0,self.view.frame.size.height, 35);
     self.bannerView = [[GADBannerView alloc]initWithFrame:self.frame1];
     
     self.bannerView.frame = self.frame1;
     
     //Live Admob Code
     self.bannerView.adUnitID = @"ca-app-pub-7881880964352996/1647673665";
     
     // Test Admob Code
     //   self.bannerView.adUnitID =@"ca-app-pub-8909749042921180/1973833957";
     
     self.bannerView.rootViewController = self;
     self.bannerView.delegate = self ;
     [self.view addSubview:self.bannerView];
     
     GADRequest *request = [GADRequest alloc] ;
     //    request.testDevices = [NSArray arrayWithObjects:GAD_SIMULATOR_ID,@"TheIDAppearingInLogs",nil];//
     [self.bannerView loadRequest:request];
   */  
     
}

-(void) createFullscreenAdmob{
    if ([self.interstitial isReady]) {
        NSLog(@"in ready");
        [self.interstitial presentFromRootViewController:self];
    }
}



// Override to allow orientations other than the default portrait orientation.

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	//
	// There are 2 ways to support auto-rotation:
	//  - The OpenGL / cocos2d way
	//     - Faster, but doesn't rotate the UIKit objects
	//  - The ViewController way
	//    - A bit slower, but the UiKit objects are placed in the right place
	//
	
#if GAME_AUTOROTATION==kGameAutorotationNone
	//
	// EAGLView won't be autorotated.
	// Since this method should return YES in at least 1 orientation, 
	// we return YES only in the Portrait orientation
	//
	return ( interfaceOrientation == UIInterfaceOrientationPortrait );
	
#elif GAME_AUTOROTATION==kGameAutorotationCCDirector
	//
	// EAGLView will be rotated by cocos2d
	//
	// Sample: Autorotate only in landscape mode
	//
	if( interfaceOrientation == UIInterfaceOrientationLandscapeLeft ) {
		[[CCDirector sharedDirector] setDeviceOrientation: kCCDeviceOrientationLandscapeRight];
	} else if( interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		[[CCDirector sharedDirector] setDeviceOrientation: kCCDeviceOrientationLandscapeLeft];
	}
	
	// Since this method should return YES in at least 1 orientation, 
	// we return YES only in the Portrait orientation
	return ( interfaceOrientation == UIInterfaceOrientationPortrait );
	
#elif GAME_AUTOROTATION == kGameAutorotationUIViewController
	//
	// EAGLView will be rotated by the UIViewController
	//
	// Sample: Autorotate only in landscpe mode
	//
	// return YES for the supported orientations
	
	return ( UIInterfaceOrientationIsLandscape( interfaceOrientation ) );
	
#else
#error Unknown value in GAME_AUTOROTATION
	
#endif // GAME_AUTOROTATION
	
	
	// Shold not happen
	return NO;
}

//
// This callback only will be called when GAME_AUTOROTATION == kGameAutorotationUIViewController
//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	//
	// Assuming that the main window has the size of the screen
	// BUG: This won't work if the EAGLView is not fullscreen
	///
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	CGRect rect = CGRectZero;

	
	if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)		
		rect = screenRect;
	
	else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
		rect.size = CGSizeMake( screenRect.size.height, screenRect.size.width );
	
	CCDirector *director = [CCDirector sharedDirector];
	EAGLView *glView = [director openGLView];
	float contentScaleFactor = [director contentScaleFactor];
	
	if( contentScaleFactor != 1 ) {
		rect.size.width *= contentScaleFactor;
		rect.size.height *= contentScaleFactor;
	}
	glView.frame = rect;
}
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
}


#pragma mark-

#pragma mark -
-(void) checkNotification:(NSNotification *)notify{
    
    NSLog(@"Url = %@",notify.object);
    
    NSURL *targetURL = notify.object;
    
    NSRange range = [targetURL.query rangeOfString:@"notif" options:NSCaseInsensitiveSearch];
    
    // If the url's query contains 'notif', we know it's coming from a notification - let's process it
    if(targetURL.query && range.location != NSNotFound)
    {
        // Yes the incoming URL was a notification
        // ProcessIncomingRequest(targetURL, callback);
        [self processRequest:targetURL];
    }
}

-(void) processRequest:(NSURL *)targetURL{
    // Extract the notification id
    
    NSArray *pairs = [targetURL.query componentsSeparatedByString:@"&"];
    NSMutableDictionary *queryParams = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs)
    {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val = [[kv objectAtIndex:1]
                         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [queryParams setObject:val forKey:[kv objectAtIndex:0]];
    }
    
    NSString *requestIDsString = [queryParams objectForKey:@"request_ids"];
    NSArray *requestIDs = [requestIDsString componentsSeparatedByString:@","];
    self.requestIDsAry = [NSArray arrayWithArray:requestIDs];
    self.count = self.requestIDsAry.count-1;
    [self checkRequestWithID:[self.requestIDsAry lastObject]];
    //----------------
}

-(void) checkRequestWithID:(NSString *)requestID{
    FBRequest *req = [[FBRequest alloc] initWithSession:[FBSession activeSession] graphPath:requestID];
    
    [req startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error){
        NSLog(@"Result== %@",result);
        NSLog(@"errror == %@",error);
        if (!error)
        {
            NSLog(@"Display life request UI");
            
//            [self proceedRequestWithResult:result];
        }
        else{
            
            NSLog(@"Error == %@",error.localizedDescription);
            if (self.count>0) {
                self.count = self.count - 1;
                NSString *curReqID = [NSString stringWithFormat:@"%@",[self.requestIDsAry objectAtIndex:self.count]];
                [self checkRequestWithID:curReqID];
            }
            else{
                return;
            }
        }
    }];
}

-(void)proceedRequestWithResult:(id) result{
    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:result];
    NSString *message = [NSString stringWithFormat:@"%@",[result objectForKey:@"message"]];
    
    NSLog(@"message is %@",message);
    
    NSString *requestID = [NSString stringWithFormat:@"%@",[result objectForKey:@"id"]];
    NSLog(@"Request ID = %@",requestID);
    if ([message isEqualToString:@"sending life request"]) {
        
//        [self displayLifeRequestUI:dict];
        
    }
    else if([message isEqualToString:@"sending extra life"]){
//        NSString *from = [[result objectForKey:@"from"] objectForKey:@"name"];
//        self.senderName = from;
//        //self.strSenderFbId = [[result objectForKey:@"from"] objectForKey:@"id"];
//        NSString *toName = [[result objectForKey:@"to"] objectForKey:@"name"];
//        self.currentUserName = toName;
//        NSString *title = [NSString stringWithFormat:@"Says thank you to %@",from];
//        NSString *description = [NSString stringWithFormat:@"I got one extra life gifted by %@",from];
//        
//        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"life",FacebookType,title,FacebookTitle,description,FacebookDescription,@"say",FacebookActionType, nil];
//        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//         appDelegate.openGraphDict = dict;
//        
//        if (FBSession.activeSession.isOpen) {
//              [appDelegate storyPostwithDictionary:dict];
//        }
//        else{
//            [appDelegate openSessionWithLoginUI:3 withParams:dict];
//        }
//        
//        [self increaseUserLife:dict];
        
        [self lifeAcceptUI:result];
     }
    
    else{
        NSLog(@"Unknown request");
    }//else if loop close
    
    //[self deleteFbRequest:requestID];
}

-(void) deleteFbRequest:(NSString *)requestID{
    
    //FBRequest *req = [[FBRequest alloc] initWithSession:[FBSession activeSession] graphPath:requestID];
    
   FBRequest *req = [[FBRequest alloc] initWithSession:[FBSession activeSession] graphPath:requestID parameters:nil HTTPMethod:@"DELETE"];
    
    [req startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error){
        if (error) {
            NSLog(@"Not Deleted==%@",error);
        }
        else{
            NSLog(@"Deleted");
        }
    }];
    /*
    [FBRequestConnection startWithGraphPath:requestID parameters:[NSDictionary dictionary] HTTPMethod:@"DELETE" completionHandler:^(FBRequestConnection *connection, id result, NSError *error){
        
        if (error) {
            NSLog(@"Not Deleted");
        }
        else{
            NSLog(@"Deleted");
        }
    }];*/
}
#pragma mark -
-(void)lifeAcceptUI:(NSDictionary *)result{
    
    NSDictionary *fromDataDict = [result objectForKey:@"from"];
    NSDictionary *toDict = [result objectForKey:@"to"];
    
    NSString *sendername = [NSString stringWithFormat:@"%@",[fromDataDict objectForKey:@"name"]];
    NSLog(@"from = %@",sendername);
    self.senderName = sendername;
    
    NSString *receiverName = [NSString stringWithFormat:@"%@",[toDict objectForKey:@"name"]];
    self.currentUserName = receiverName;
    
    
    NSString *senderID = [NSString stringWithFormat:@"%@",[fromDataDict objectForKey:@"id"]];
    self.senderID = senderID;
    
    
    [self createUI:sendername];
    
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@",self.senderName];
    
    self.messageLabel.text = [NSString stringWithFormat:@"Sent you extra life"];
    [self.sendButton setBackgroundImage:[UIImage imageNamed:@"accept.png"] forState:UIControlStateNormal];
    [self.sendButton addTarget:self action:@selector(lifeAcceptButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.displayRequestView.hidden = NO;
    [UIView animateWithDuration:.3 animations:^{
        self.containerView.frame = CGRectMake(17, 65, 284, 278);
    }];
}

-(void)lifeAcceptButtonAction:(id)sender{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    int lifeUserDefault = (int)[userDefault integerForKey:@"life"];
    //NSLog(@"Life Before added -==- %d",lifeUserDefault);
    NSString *title = [NSString stringWithFormat:@"Thank you %@ for extra life",self.currentUserName];
    NSString *description = [NSString stringWithFormat:@"%@ got one extra life gifted by %@",self.senderName,self.currentUserName];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"life",FacebookType,title,FacebookTitle,description,FacebookDescription,@"say",FacebookActionType, nil];
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate storyPostwithDictionary:dict];
    
    if (lifeUserDefault<=4) {
        lifeUserDefault++;
        [userDefault setInteger:lifeUserDefault forKey:@"life"];
        // NSLog(@"Life After added -==- %d",lifeUserDefault);
        [userDefault synchronize];
        
        //[[[UIAlertView alloc] initWithTitle:@"Congratulation!" message:[NSString stringWithFormat:@"You got new life from %@",self.senderName] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        
    }
    [self cancelButtonClicked:nil];
}

#pragma mark -
-(void) displayLifeRequestUI:(NSDictionary *)result{
    
    NSDictionary *fromDataDict = [result objectForKey:@"from"];
    NSDictionary *toDict = [result objectForKey:@"to"];
    
    NSString *sendername = [NSString stringWithFormat:@"%@",[fromDataDict objectForKey:@"name"]];
    NSLog(@"from = %@",sendername);
    self.senderName = sendername;
    
    NSString *receiverName = [NSString stringWithFormat:@"%@",[toDict objectForKey:@"name"]];
    self.currentUserName = receiverName;
    
    
    NSString *senderID = [NSString stringWithFormat:@"%@",[fromDataDict objectForKey:@"id"]];
    self.senderID = senderID;
    //NSLog(@"url == http://graph.facebook.com/%@",senderID);
    //    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@",senderID]]];
    //    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //    NSLog(@"Response = %@",response);
    
    [self createUI:sendername];
    
    [self.sendButton setBackgroundImage:[UIImage imageNamed:@"send.png"] forState:UIControlStateNormal];
    [self.sendButton addTarget:self action:@selector(sendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.nameLabel.text = [NSString stringWithFormat:@"Help %@",sendername];
    self.messageLabel.text = [NSString stringWithFormat:@"send extra life"];
    
    
    self.displayRequestView.hidden = NO;
    [UIView animateWithDuration:.3 animations:^{
        self.containerView.frame = CGRectMake(45, 65, 400, 278);
    }];
}

-(void) createUI:(NSString *)senderName{
    
    if (!self.displayRequestView) {
        CGRect frame = [UIScreen mainScreen].bounds;
        self.displayRequestView = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.height, frame.size.width)];
        self.displayRequestView.backgroundColor = [UIColor blackColor];
        self.displayRequestView.alpha = 0.4f;
        [self.view addSubview:self.displayRequestView];
        
        self.containerView = [[UIView alloc] initWithFrame:CGRectMake(45, -300, 400, 278)];
        self.containerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LifeReqBG.png"]];
        [self.view addSubview:self.containerView];
        
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 50, 350, 60)];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.numberOfLines = 1;
        self.nameLabel.font = [UIFont fontWithName:@"TerrorPro" size:25];
        self.nameLabel.textColor = [UIColor colorWithRed:(CGFloat)132/255 green:(CGFloat)98/255 blue:(CGFloat)166/255 alpha:1.0f];
        self.nameLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self.containerView addSubview:self.nameLabel];
        
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 80, 350, 60)];
        self.messageLabel.textColor = [UIColor blackColor];
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        self.messageLabel.numberOfLines = 0;
        self.messageLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self.containerView addSubview:self.messageLabel];
        
      
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelButton.frame = CGRectMake(70, 200, 100, 45);
        //self.cancelButton.titleLabel.textColor = [UIColor whiteColor];
        //[self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView addSubview:self.cancelButton];
        //=
        self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sendButton.frame = CGRectMake(228, 200, 100, 45);
        //        self.sendButton.titleLabel.textColor = [UIColor whiteColor];
        //        [self.sendButton setTitle:@"Send" forState:UIControlStateNormal];
        
        [self.containerView addSubview:self.sendButton];
    }
    else{
        self.displayRequestView.hidden = NO;
    }
    
    
}

-(void) sendButtonClicked:(id)sender{
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSDictionary *challenge =  [NSDictionary dictionaryWithObjectsAndKeys: [NSString stringWithFormat:@"got extra life"], @"message", nil];
    NSString *lifeReq = [jsonWriter stringWithObject:challenge];
    
    // Create a dictionary of key/value pairs which are the parameters of the dialog
    
    // 1. No additional parameters provided - enables generic Multi-friend selector
    NSMutableDictionary* params =   [NSMutableDictionary dictionaryWithObjectsAndKeys:self.senderID, @"to",lifeReq, @"data",@"sending extra life",@"message",@"Send Live",@"Title",nil];
    
    self.currentUserName = [[NSUserDefaults standardUserDefaults]objectForKey:@"ConnectedFacebookUserName"];
    
    NSString *title = [NSString stringWithFormat:@"i sent extra life to %@",self.senderName];
    NSString *des = [NSString stringWithFormat:@"Now %@ has one extra life gifted by %@",self.senderName, self.currentUserName];
    NSDictionary *storyDict = [NSDictionary dictionaryWithObjectsAndKeys:@"life",FacebookType,title,FacebookTitle,des,FacebookDescription,@"send",FacebookActionType, nil];
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.delegate = nil;
    appDelegate.openGraphDict = storyDict;
    
    if (!FBSession.activeSession.isOpen) {
//        [appDelegate openSessionWithLoginUI:2 withParams:params];
    }
    else{
//        [appDelegate sendRequestToFriends:params];
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendRequestToFrnds) name:RequestTOFacebook object:nil];
        //        [appDelegate openSessionWithAllowLoginUI:2];
    }
    
    [self cancelButtonClicked:sender];
}
-(void) cancelButtonClicked:(id)sender{
    
    [UIView animateWithDuration:.3 animations:^{
        self.containerView.frame = CGRectMake(45, -300, 400, 278);
    }completion:^(BOOL finished){
        if (finished == YES) {
            self.displayRequestView.hidden = YES;
        }
    }];
}
#pragma mark -
-(void) increaseUserLife:(NSDictionary *)dict{
    NSLog(@"Got new life");
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    int life = (int)[userDefaults integerForKey:@"live"];
    int newLife;
    if (life<5) {
        newLife = life + 1;
    }
    else{
        newLife = 5;
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Congratulations!" message:@"You got one extra life" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    
    [userDefaults setInteger:newLife forKey:@"live"];
    [userDefaults  synchronize];
    
}

#pragma mark -
#pragma mark -

- (void)revmobAdDidReceive {
    NSLog(@"[RevMob Sample App] Ad loaded.");
}

- (void)revmobAdDidFailWithError:(NSError *)error {
    NSLog(@"[RevMob Sample App] Ad failed: %@", error);
}
- (void)revmobUserClickedInTheAd {
    NSLog(@"[RevMob Sample App] User clicked in the Ad.");
}

-(void) createAddBannerView{
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
    
    return;
}


-(void) displayBannerView:(BOOL)display{
    
    if (display==YES) {
        self.rev_BannerView.hidden = NO;
    }
    else{
        self.rev_BannerView.hidden = YES;
    }
}



@end

