//
//  Store.h
//  CaveRun
//
//  Created by GLB-254 on 7/31/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Store : CCLayer {
    
}
@property(nonatomic,retain)CCSprite *cave;
@property(nonatomic,retain)CCMenu *menuBack,*store_button;
-(void)backAction:(id)sender;

@end
