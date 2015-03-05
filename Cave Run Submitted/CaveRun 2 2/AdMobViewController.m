//
//  AdMobViewController.m
//  CaveRunMowgli
//
//  Created by Sumit on 18/11/14.
//
//

#import "AdMobViewController.h"
#import "GADBannerView.h"
#import "GADRequest.h"
#import "GameState.h"

@interface AdMobViewController ()

@end

@implementation AdMobViewController
@synthesize bannerView ,frame1;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"self.view.frame.size.width %f",self.view.frame.size.width);
     NSLog(@"self.view.frame.size.height %f",self.view.frame.size.height);
    
    CGRect frame = [UIScreen mainScreen].bounds;
    NSLog(@"frame.width is %f",frame.size.width);
    NSLog(@"height is %f",frame.size.height);

   
    if ([GameState sharedState].bottomBanner==YES)  {
        
        self.frame1 = CGRectMake(0,self.view.frame.size.width-35,self.view.frame.size.height,35);
    }else{
         self.frame1 = CGRectMake(0,0,self.view.frame.size.height, 35);
    }
   // CGRect frame = [UIScreen mainScreen].bounds;

    if ([GameState sharedState].bottomBanner==YES)  {
        if (self.view.frame.size.width>self.view.frame.size.height) {
            
            self.frame1 = CGRectMake(0,self.view.frame.size.height-35,self.view.frame.size.width,35);
        }
    }
    
    if ([GameState sharedState].bottomBanner==NO)  {
        if (self.view.frame.size.width>self.view.frame.size.height) {
            
           self.frame1 = CGRectMake(0,0,self.view.frame.size.width, 35);
        }
    }
   
    
    
    self.bannerView = [[GADBannerView alloc]initWithFrame:self.frame1];

    //Live Admob Code
    self.bannerView.adUnitID = @"ca-app-pub-7881880964352996/1647673665";

// Test Admob Code
 //  self.bannerView.adUnitID =@"ca-app-pub-8909749042921180/1973833957";

    self.bannerView.rootViewController = self;
    self.bannerView.delegate = self ;
    [self.view addSubview:self.bannerView];
    
    GADRequest *request = [GADRequest alloc] ;
//    request.testDevices = [NSArray arrayWithObjects:GAD_SIMULATOR_ID,@"TheIDAppearingInLogs",nil];//
    [self.bannerView loadRequest:request];
    
}

- (void) adView: (GADBannerView*) view didFailToReceiveAdWithError: (GADRequestError*) error{
    NSLog(@"did fail to receive");
}

- (void) adViewDidReceiveAd: (GADBannerView*) view{
    NSLog(@"add received for banner adds");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
