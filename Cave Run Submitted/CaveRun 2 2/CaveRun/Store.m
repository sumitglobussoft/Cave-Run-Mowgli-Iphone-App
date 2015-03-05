//
//  Store.m
//  CaveRun
//
//  Created by GLB-254 on 7/31/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import "Store.h"
#import "MainMenu.h"
#import "RageIAPHelper.h"
@implementation Store
@synthesize cave,menuBack,store_button;
CGSize ws;
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Store *layer = [Store node];
	
	// add layer as a child to scene
	[scene addChild:layer];
	
	// return the scene
	return scene;
}
-(id) init
{
	if( (self=[super init]))
    {
        //----------------Background added---------------------
        CCSprite *sp=[CCSprite spriteWithFile:@"background_1-1.png"];
        sp.anchorPoint=ccp(0,0);
        sp.position=ccp(ws.width==568?0:-(568-480)/2,0);
        
        [self addChild:sp];

        //----------------Main Screen------------------
        ws=[[CCDirector sharedDirector]winSize];
        cave= [CCSprite spriteWithFile:@"storescreen1.png"];
        cave.anchorPoint=ccp(0,0);
        cave.position=ccp(ws.width==568?0:-(568-480)/2,0);
        [self addChild:cave];
        //-------------------Back Button----------------------------
        CCMenuItem *menuItemBack = [CCMenuItemImage itemFromNormalImage:@"backLevel.png" selectedImage:@"backLevel.png" target:self selector:@selector(backAction:)];
        menuBack = [CCMenu menuWithItems: menuItemBack, nil];
        if([UIScreen mainScreen].bounds.size.height<500)
        {
            menuBack.position = ccp(40, ws.height-35);
        }
        else{
            menuBack.position=ccp(40,ws.height-35);
        }
        [menuBack alignItemsHorizontally];
        [self addChild:menuBack z:100];
        //--------------------------Buy Button-------------------------
        CCMenuItem *store_img = [CCMenuItemImage itemFromNormalImage:@"buy.png" selectedImage:@"buy.png" target:self selector:@selector(buy_Action:)];
        store_button = [CCMenu menuWithItems: store_img, nil];
        if([UIScreen mainScreen].bounds.size.height<500)
        {
            store_button.position = ccp(350, ws.height-155);
        }
        else{
            store_button.position=ccp(350,ws.height-155);
        }
        [store_button alignItemsHorizontally];
        [self addChild:store_button z:100];
        
        
        
    }
    return self;
}
-(void)backAction:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[MainMenu node]];

}
-(void)buy_Action:(id)sender
{
//    if([[NSUserDefaults standardUserDefaults]integerForKey:@"live"]==0)
//    {
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinner.center = CGPointMake(160, 240);
        spinner=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(ws.width/2, ws.height/2, 50, 50)];
        spinner.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
        spinner.color=[UIColor redColor];
        [[[CCDirector sharedDirector] openGLView] addSubview:spinner];
        [spinner startAnimating];

        [[RageIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
            NSLog(@"Products -==--= %@",products);
            if (success) {
            
                if (products.count <=0) {
                
                    [[[UIAlertView alloc] initWithTitle:@"" message:@"Please check your internet connection and try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
                }
                else{
                    SKProduct *product = products[0];
                
                    NSLog(@"Buying %@...", product.productIdentifier);
                
                    [[RageIAPHelper sharedInstance] buyProduct:product];
                }
            }
                [spinner stopAnimating];
        }];
        NSLog(@"More Lives Button Click");

//    }//for if condition for live
//    else
//    {
//        
//    }
}

-(void) dealloc{
    [super dealloc];
}


@end
