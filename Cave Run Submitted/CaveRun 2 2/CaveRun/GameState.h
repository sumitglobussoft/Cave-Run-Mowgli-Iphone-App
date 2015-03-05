//
//  GameState.h
//  DartWheel
//
//  Created by Sumit Ghosh on 31/05/14.
//
//

#import <Foundation/Foundation.h>
@interface GameState : NSObject

@property (nonatomic, assign) int levelNumber;
//@property (nonatomic, assign) int latestScore;
@property (nonatomic, assign) int remLife,remTime,score_gn;
@property (nonatomic, assign) BOOL checkLevelClear;
@property (nonatomic, assign) BOOL checkLife,clear,next;
@property (nonatomic,assign) NSArray *ary;
@property (nonatomic,retain) NSArray *friendsScoreArray;
@property(nonatomic,assign) BOOL checkAd ;
@property(nonatomic,assign) BOOL shareOnFacebook;
@property(nonatomic,assign) UIView *bannerView;
@property(nonatomic,assign) BOOL bottomBanner;
+(GameState*)sharedState;
@end
