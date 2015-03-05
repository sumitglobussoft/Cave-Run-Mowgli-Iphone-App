//
//  AdMobFullScreenViewController.m
//  CaveRunMowgli
//
//  Created by Sumit on 18/11/14.
//
//

#import "AdMobFullScreenViewController.h"
#import "AppDelegate.h"

@interface AdMobFullScreenViewController ()

@end

@implementation AdMobFullScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)init{
    
     self.interstitial = [self createAndLoadInterstitial];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
  
}

- (GADInterstitial *)createAndLoadInterstitial {
    GADInterstitial *interstitial = [[GADInterstitial alloc] init];

    //Test Admob Code
 // interstitial.adUnitID = @"ca-app-pub-4722099521556590/4105472067";

    // Live Admob Code
   interstitial.adUnitID = @"ca-app-pub-7881880964352996/3124406864";
  
    interstitial.delegate = self;
    GADRequest *request = [GADRequest request];
//    request.testDevices = [NSArray arrayWithObjects:GAD_SIMULATOR_ID,@"TheIDAppearingInLogs",nil];
    [interstitial loadRequest:request];
    return interstitial;
}


- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --------delegate methods
#pragma mark ===========

- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial {
    //[[NSNotificationCenter defaultCenter]postNotificationName:@"loadAdd" object:nil];
    NSLog(@"add received");
    [self adMob];
    if ([interstitial isReady]) {
        NSLog(@"inside");
        
        [interstitial presentFromRootViewController:self];
        
    }
}
-(void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error
{
      NSLog(@"Failed to recieve Ad");
}

-(void)adMob
{
    BOOL checkInternet=[[NSUserDefaults standardUserDefaults]objectForKey:CurrentNetworkStatus];
    if (checkInternet)
    {
     
        viewController = (UIViewController*)[(AppDelegate *)[[UIApplication sharedApplication] delegate] getRootViewController];
    }
    
    [viewController presentViewController:self animated:NO completion:nil];
    
}

@end
