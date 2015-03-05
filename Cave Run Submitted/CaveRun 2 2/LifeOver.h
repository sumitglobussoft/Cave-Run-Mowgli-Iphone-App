//
//  LifeOver.h
//  BowHunting
//
//  Created by Sumit Ghosh on 26/03/14.
//  Copyright (c) 2014 tang. All rights reserved.
//

#import "CCSprite.h"
#import "CCLayer.h"
#import "cocos2d.h"
#import "Store.h"
#import <FacebookSDK/FacebookSDK.h>

@interface LifeOver : CCSprite {
    
    int min;
    int sec;
    int remTime;
    NSUserDefaults *userDefault;
}

@property(nonatomic,retain) CCLabelBMFont *lblNextLifeTime;
@property(nonatomic,retain) CCLabelBMFont *timeText;
@property(nonatomic,retain) CCLabelBMFont *lblMoreLifeNow;
@property(nonatomic,retain) CCMenu *menuAskFrnd;
@property(nonatomic,retain) CCMenu *menuMoreLife;
@property(nonatomic,retain) CCMenu *menuBack;
@property(nonatomic,assign) id storeLayer;

@end
