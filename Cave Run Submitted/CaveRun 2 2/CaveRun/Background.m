//
//  Background.m
//  CaveRun
//
//  Created by tang on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Background.h"
#import "cocos2d.h"
@implementation Background
@synthesize bgb,bgf,staticBG,bgbLayer,bgfLayer,daylight,bgImgs;


CGSize ws;
-(id) init
{
    if( (self=[super init])) {
        ws=[[CCDirector sharedDirector]winSize];
        bgImgs=[[NSMutableArray alloc]init];
        staticBG=[CCSprite spriteWithFile:@"background.jpg"];
      //    [self resizeSprite:staticBG toWidth:ws.width toHeight:ws.height];
        [self.bgImgs addObject:staticBG];
        bgbLayer=[CCLayer node];
        bgfLayer=[CCLayer node];
        
        NSString *bgbPath;
        if(ws.width==568){
            bgbPath=@"bgb_iphone5.png";
        }
        else{
            bgbPath=@"bgb.png";
        }
        
        bgb=[CCSprite spriteWithFile:bgbPath];
        bgb.anchorPoint=ccp(0,0);
        [bgbLayer addChild:bgb];
        [self.bgImgs addObject:bgb];
        bgb=[CCSprite spriteWithFile:bgbPath];
        bgb.anchorPoint=ccp(0,0);
        
        bgb.position=ccp(ws.width-1,0);
        [bgbLayer addChild:bgb];
        [self.bgImgs addObject:bgb];
        
//        [self resizeSprite:bgb toWidth:ws.width toHeight:ws.height];

        
        daylight=[CCSprite spriteWithFile:@"daylight.png"];
        daylight.anchorPoint=ccp(1,0);
        daylight.position=ccp(ws.width,-80);
        
        
        NSString *bgfPath;
        if(ws.width==568){
            bgfPath=@"bgf_iphone5.png";
        }
        else{
            bgfPath=@"bgf.png";
        }
        
        bgf=[CCSprite spriteWithFile:bgfPath];
        bgf.anchorPoint=ccp(0,0);
        [bgfLayer addChild:bgf];
        [self.bgImgs addObject:bgf];
        bgf=[CCSprite spriteWithFile:bgfPath];
        bgf.anchorPoint=ccp(0,0);
        
        bgf.position=ccp(ws.width-1,0);
        
        [self.bgImgs addObject:bgf];
        [bgfLayer addChild:bgf];
        
//     [self resizeLayer:bgbLayer toWidth:ws.width toHeight:ws.height];
//        [self resizeLayer:bgfLayer toWidth:ws.width toHeight:ws.height];
//
//        [self resizeSprite:bgf toWidth:ws.width toHeight:ws.height];
        
        staticBG.anchorPoint=ccp(0,0);
        
        bgbLayer.position=ccp(-300,0);
        
        [self addChild:staticBG];
        [self addChild:daylight];
        [self addChild:bgbLayer];
        
        [self addChild:bgfLayer];
        
        
         
    }
    return self;
}


-(void)resizeSprite:(CCSprite*)sprite toWidth:(float)width toHeight:(float)height {
    sprite.scaleX = width / sprite.contentSize.width;
    sprite.scaleY = height / sprite.contentSize.height;
}

-(void)resizeLayer:(CCLayer*)sprite toWidth:(float)width toHeight:(float)height {
    sprite.scaleX = width / sprite.contentSize.width;
    sprite.scaleY = height / sprite.contentSize.height;
}

//set it's color to random color

-(void)setColorWithRBG{
    int rrr=(int)(1+arc4random()%255/2+255/2);
    int ggg=(int)(1+arc4random()%255/2+255/2);
    int bbb=(int)(1+arc4random()%255/2+255/2);
          
    for(int i=0;i<[self.bgImgs count];i++){
        CCSprite * toChangeColor=[self.bgImgs objectAtIndex:i];
        
        toChangeColor.color=ccc3(rrr,ggg,bbb);
    }
    
    //((CCSprite*) self).color=ccc3(rrr,ggg,bbb);
}
#pragma mark
#pragma mark Move background
#pragma mark =============================
-(void) moveWithSpeed:(float) speed{
    bgbLayer.position=ccp(bgbLayer.position.x-speed,bgbLayer.position.y);
    
    bgfLayer.position=ccp(bgfLayer.position.x-speed*2,bgfLayer.position.y);
    
    if(bgbLayer.position.x<-ws.width){
        bgbLayer.position=ccp(0,0);
    }
    
    if(bgfLayer.position.x<-ws.width){
        bgfLayer.position=ccp(0,0);
    }
}
- (void) dealloc
{
    self.bgb=nil;
    self.bgf=nil;
    self.staticBG=nil;
    
    self.bgbLayer=nil;
    self.bgfLayer=nil;
    self.bgImgs=nil;
    [super dealloc];
}
@end
