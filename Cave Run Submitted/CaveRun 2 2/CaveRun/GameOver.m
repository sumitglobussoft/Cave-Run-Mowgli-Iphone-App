//
//  GameOver.m
//  CaveRun
//
//  Created by Sumit on 17/06/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import "GameOver.h"


@implementation GameOver
@synthesize gameOverSprite,coinCount,shareText,gameMain,s1;
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

// on "init" you need to initialize your instance
-(id) init
{
    if (self=[super init]) {
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        NSLog(@"coin count==== %d",coinCount);
        ws=[[CCDirector sharedDirector]winSize];
        //create game over sprite
        self.gameOverSprite=[CCSprite spriteWithFile:@"GameOverNew.png"];
        // self.gameOverSprite.visible=NO;
        self.gameOverSprite.visible=YES;
        [self addChild:self.gameOverSprite];
        
        NSLog(@"s1====%@",s1);
        
        
        self.disText=[CCLabelTTF labelWithString:@"0" fontName:@"JFRocSol.TTF" fontSize:20];
        //[self.gameOverSprite addChild:self.disText];
        self.disText.anchorPoint=ccp(0,0);
        self.disText.position=ccp(340+20,280);
        
        
        //create text to show total coins collected
        self.coinText=[CCLabelTTF labelWithString:@"0" fontName:@"JFRocSol.TTF" fontSize:20];
        // [self.gameOverSprite addChild:self.coinText];
        self.coinText.anchorPoint=ccp(0,0);
        self.coinText.position=ccp(340+20,250);
        
        //level text
        self.levelText=[CCLabelTTF labelWithString:@"0" fontName:@"JFRocSol.TTF" fontSize:20];
        //[self.gameOverSprite addChild:self.levelText];
        self.levelText.anchorPoint=ccp(0,0);
        self.levelText.position=ccp(340+20,220);
        
        //SCORE TEXT
        self.totalScoreText=[CCLabelTTF labelWithString:@"0" fontName:@"JFRocSol.TTF" fontSize:28];
        // [self.gameOverSprite addChild:self.totalScoreText];
        // self.totalScoreText.anchorPoint=ccp(0,0);
        self.totalScoreText.position=ccp(300+20,150);
        self.totalScoreText.color=ccc3(255,180,0);
        
        self.gameOverSprite.anchorPoint=ccp(0.5,0.5);
        self.gameOverSprite.position=ccp(ws.width/2,ws.height/2);
        
        //added now
        
        self.text1=[CCLabelBMFont labelWithString:@"1111111" fntFile:@"font_30.fnt"];
        self.text2=[CCLabelBMFont labelWithString:@"2222222" fntFile:@"font_30.fnt"];
        self.text3=[CCLabelBMFont labelWithString:@"3333333" fntFile:@"font_30.fnt"];
        //           self.text4=[CCLabelBMFont labelWithString:@"9999999" fntFile:@"lifes.fnt"];
        //
        self.text1.anchorPoint=self.text2.anchorPoint=self.text3.anchorPoint=ccp(1,0);
        //
        self.text1.position=ccp(150,50);
        self.text2.position=ccp(160,80);
        self.text3.position=ccp(180,100);
        //
        //           self.text4.anchorPoint=ccp(0.5,0.5);
        //
        //           self.text4.position=ccp(160,150);
        
        [self addChild:self.text1];
        [self addChild:self.text2];
        [self addChild:self.text3];
        //           [self addChild:self.text4];
        
        
        
        CCMenuItem *menuMainMenu = [CCMenuItemImage itemFromNormalImage:@"retry.png" selectedImage:@"retry.png" target:self selector:@selector(retryAction:)];
        
        
        CCMenu  *menu1 = [CCMenu menuWithItems: menuMainMenu, nil];
        menu1.position = ccp(winSize.width/2, winSize.height/2-80);
        [menu1 alignItemsHorizontally];
        [self addChild:menu1 z:100];
        
        
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Share" fontName:@"Times New Roman" fontSize:24];
        
        label.position = ccp(100,20);
        
        label.color = ccc3(255, 255, 255);
        
        [self addChild: label];
        
        
        [self setScore];
        
    }
    return self;
}

-(void)setScore{
    //    gm=(GameMain*)self.gameMain;
    //     self.text1.string=gm.runTimeCoinText.string;
    
    gm=(GameMain*)self.gameMain;
    
    self.text1.string=gm.runTimeCoinText.string;
    
    
    
    
    NSLog(@"self.text1.string==== %@",gm.runTimeCoinText.string);
    
    // self.text2.string=gm.
    
    
    // self.text3.string=gm.score;
    
    
    
}
-(void)retryAction:(id)sender {
    NSLog(@"in retry action");
    [[CCDirector sharedDirector]replaceScene:[CCTransitionFadeTR transitionWithDuration:1.0 scene:[GameMain scene]]];
}
@end
