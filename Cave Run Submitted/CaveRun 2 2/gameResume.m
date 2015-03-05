//
//  gameResume.m
//  CaveRun
//
//  Created by Sumit on 12/06/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import "gameResume.h"
#import "GameMain.h"
#import "MainMenu.h"
#import "cocos2d.h"

@implementation gameResume
@synthesize gm;

- (id)init {
    if ((self = [super init])) {
        
        layer = [[[GamePauseLayer alloc] init] autorelease];
        [self addChild:layer];
    }
    return self;
}
@end

@implementation GamePauseLayer


+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GamePauseLayer *layer = [GamePauseLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id)init {
    
    if (self=[super init]) {

      //  NSLog(@"height=== %f",[UIScreen mainScreen].bounds.size.height);

        CGSize winSize = [CCDirector sharedDirector].winSize;
        CCSprite *spriteSubMenu = [CCSprite spriteWithFile:@"background_1-1.png"];
        spriteSubMenu.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:spriteSubMenu z:0];
        
        CCMenuItem *menuResume=[CCMenuItemImage itemFromNormalImage:@"menu1.png" selectedImage:@"menu1.png" target:self selector:@selector(MenuBtnAction:)];
        
        CCMenuItem *menuMainMenu = [CCMenuItemImage itemFromNormalImage:@"resume1.png" selectedImage:@"resume1.png" target:self selector:@selector(resumeAction:)];
        
        CCMenu  *menu1 = [CCMenu menuWithItems: menuResume, nil];
        menu1.position = ccp(winSize.width/2+10, winSize.height/2+40);
        [menu1 alignItemsHorizontally];
        [self addChild:menu1 z:100];
        
        CCMenu *menu2 = [CCMenu menuWithItems: menuMainMenu, nil];
        menu2.position = ccp(winSize.width/2+10, winSize.height/2-40);
        [menu2 alignItemsHorizontally];
        [self addChild:menu2 z:100];
        }
    return self;
}

-(void)resumeAction:(id)sender {
    [[CCDirector sharedDirector] popScene];
}

-(void)MenuBtnAction:(id)sender{
//     GameMain *gameMain=(GameMain*)self.gm;
//    [gm.viewHost1 removeFromSuperview];
//    gm.viewHost1.hidden=YES;
//     [[GameState sharedState].bannerView removeFromSuperview];
   [[CCDirector sharedDirector] replaceScene:[MainMenu scene]];
}

-(void) dealloc{
    
	[super dealloc];
}


@end
