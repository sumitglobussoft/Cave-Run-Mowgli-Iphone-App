//
//  Background.h
//  CaveRun
//
//  Created by tang on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"
@interface Background : CCLayer
{
    CCSprite * staticBG;
    CCSprite *daylight;
    CCSprite * bgf;
    CCSprite * bgb;
    
    CCLayer * bgfLayer;
    CCLayer * bgbLayer;
    NSMutableArray *bgImgs;
}
-(void) moveWithSpeed:(float) speed;
-(void)setColorWithRBG;
@property(nonatomic ,retain) CCSprite *bgb;
@property(nonatomic ,retain) NSMutableArray *bgImgs;
@property(nonatomic ,retain) CCSprite *bgf;
@property(nonatomic ,retain) CCLayer *bgfLayer;
@property(nonatomic ,retain) CCLayer *bgbLayer;
@property(nonatomic ,retain) CCSprite * staticBG;
@property(nonatomic ,retain) CCSprite * daylight;
@end
