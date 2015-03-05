//
//  FriendsLevel.h
//  CaveRunMowgli
//
//  Created by Sumit on 01/12/14.
//
//
#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "CCLayer.h"
#import <Parse/Parse.h>
#import "UIImageView+WebCache.h"
#import "RootViewController.h"

@interface FriendsLevel : CCLayer{
       UIViewController *rootViewController;
     CCSprite *levelBackground;
    CCSprite *spriteBackground ;
     UIButton *playButton;
    UIButton *backButton ; 
    UIScrollView *scrollV ;
    UIView *secondView ;
    UILabel *friendsLevel;
     CCMenu *menuBack1;

}

@property(nonatomic,strong) UIView *friendsView;
@property(nonatomic,strong) UIScrollView *bottomScroll ;
-(void)backBtnAction1:(id)sender;
+(CCScene *) scene;
@end
