//
//  GameState.m
//  DartWheel
//
//  Created by Sumit Ghosh on 31/05/14.
//
//

#import "GameState.h"

static GameState *_sharedState = nil;

@implementation GameState


+(GameState*)sharedState {
    
    if (!_sharedState) {
        _sharedState=[[GameState alloc]init];
    }
    return _sharedState;
}

-(id)init{
    
    if (self=[super init]) {
        
    }
    return self;
}
@end
