//
//  GameOver.h
//  CaveRun
//
//  Created by Sumit on 17/06/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "GameMain.h"

@class GameMain;
@interface GameOver : CCSprite {
    CCSprite *gameOverSprite;
    CCLabelTTF *disText,*coinText,*levelText,*totalScoreText,*runTimeDisText,*runTimeCoinText;
    
    //added now
    
    CCLabelBMFont *text1,*text2,*text3,*text4;
    GameMain *gm;
    id gameMain;
    
}//
-(void)setScore;
@property(nonatomic,strong)NSString *s1;
@property(nonatomic,retain) CCSprite *gameOverSprite;
@property(nonatomic,retain) CCLabelTTF *disText,*coinText,*levelText,*totalScoreText,*runTimeDisText,*runTimeCoinText;
@property(nonatomic)NSInteger coinCount;
@property(nonatomic,retain) CCLabelTTF *shareText;
@property (nonatomic,retain) id gameMain;

//added now
@property (nonatomic,retain) CCLabelBMFont *text1,*text2,*text3,*text4;
@end
