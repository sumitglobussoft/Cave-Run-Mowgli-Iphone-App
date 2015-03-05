//
//  Platform.m
//  CaveRun
//
//  Created by tang on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Platform.h"
#import "cocos2d.h"
#import "CCAnimate+SequenceLoader.h"
#import "Player.h"
#import "SimpleAudioEngine.h"
#import "GameOverScene.h"
#import "GameState.h"
#import "LifeOver.h"

#import "GameMain.h"
#import "AdMobFullScreenViewController.h"

@implementation Platform {
    CCSprite *midMC;
    CCLayer *mc;
    
}

@synthesize widMax,widMin,leftWidth,rightWidth,midWidth,gap,lastWid;
@synthesize __pf,pfsArr,pfWidthArr,pool,lastPF;
@synthesize coinsArr,demonArr,coinsArrsArr,demonArrsArr;
@synthesize obsArr,obsArrsArr,coinsNum,currentLevel,gm,enemy,Bool,loopFall,fall,flag,levelBonus,player;


-(id) init
{
    
    if( (self=[super init])) {
      
        self.levelBonus=0;
        self.gap=50;//50
        self.coinsNum=0;
        //self.currentLevel=1;
        self.currentLevel =[GameState sharedState].levelNumber;
       // NSLog(@"current level is %d",self.currentLevel);
        
        self.lastWid=0;
        self.leftWidth=122/2;
        self. rightWidth=122/2;
        self. midWidth=100/2;
        self. widMax=800;
        self.widMin=200;
   //  CGSize ws=[[CCDirector sharedDirector]winSize];
          [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"clips.plist"];
          [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"enemy.plist"];
        
        self.pool=[[NSMutableArray alloc]init];
        self.pfsArr=[[NSMutableArray alloc]init];
        self.pfWidthArr=[[NSMutableArray alloc]init];
        
        self.coinsArrsArr=[[NSMutableArray alloc]init];
        self.demonArrsArr=[[NSMutableArray alloc]init];
        self.demonArr=[[NSMutableArray alloc]init];
        self.obsArr=[[NSMutableArray alloc]init];
        
        self.obsArrsArr=[[NSMutableArray alloc]init];
        
      
        
        [self addMidDecalToPool:500];
        
        self.lastPF=[self create:1000 addOB:NO];
        [self addChild:self.lastPF];
        
          self.loopFall=[CCRepeatForever actionWithAction:[CCAnimate actionWithSpriteSequence:@"fall%04d.png"
                                                                             
                                                                                                      numFrames:6
                                                                                                          delay:0.03f
                                                                                           restoreOriginalFrame:NO]];
        
        //-----------------scheduler for enemy------------------------
        counter=1;
        int levelno=[GameState sharedState].levelNumber;
        if(levelno>=1&&levelno<=9)
            [self schedule:@selector(enemycontrol) interval:20];
        if(levelno>=10&&levelno<=19)
            [self schedule:@selector(enemycontrol) interval:8];
        if(levelno>=20&&levelno<=29)
            [self schedule:@selector(enemycontrol) interval:6];
        if(levelno>=30&&levelno<=39)
            [self schedule:@selector(enemycontrol) interval:6];
        if(levelno>=40&&levelno<=50)
            [self schedule:@selector(enemycontrol) interval:6];
        flag=false;
        
        }
    return self;
    
}

//move pf clips

#pragma mark
#pragma mark Create platform and move platform
#pragma mark =============================
-(void) move:(float) speed val:(int)soundValue {
   
    self.soundValue=soundValue;
    id pf=nil;
    
    for(int i=0;i<[self.pfsArr count];i++){
        CCLayer * _pf_=[self.pfsArr objectAtIndex:i];
        _pf_.position=ccp(_pf_.position.x-speed,_pf_.position.y);
        
       
        if(_pf_.position.x+[[self.pfWidthArr objectAtIndex:i] intValue]<0){
            pf=_pf_;
          
        }
    }
    
    //if old pf is out of the stage , create new
    
    if(self.lastPF.position.x+self.lastWid<480){
        int cn=(int)(500+arc4random()%800);
        int _y=(int)(50+arc4random()%200);
        int _x=self.lastPF.position.x+self.lastWid+80+((int) arc4random()%self.gap);//100
        CCLayer *newPF=[self create:cn addOB:YES];
        newPF.position=ccp( _x,_y);
        self.lastPF=newPF;
        [self addChild:newPF];
    }
    
    //remove pf
    if(pf){
          
         //CCLOG(@"========== Platform removed ============");
         [self removeChild:pf cleanup:YES];
         [self.pfWidthArr removeObjectAtIndex:0];
         [self.pfsArr removeObjectAtIndex:0];
         [self.coinsArrsArr removeObjectAtIndex:0];
         [self.obsArrsArr removeObjectAtIndex:0];
        
    }
    
    [self tryRemoveCoin];
    
}

//remove all platforms

-(void) removeAll{
    for(int i=0;i<[self.pfsArr count];i++){
        [self removeChild:[self.pfsArr objectAtIndex:i] cleanup:NO];
    }
    self.pfsArr=[[NSMutableArray alloc]init];
}

//ready for new game 
-(void) createForNewGame{
   // self.lives=3;
    
    self.currentLevel=1;
    self.coinsNum=0;
    self.gap=50;//50
    self.lastPF=nil;
    self.obsArrsArr=[[NSMutableArray alloc]init];
    self.pfsArr=[[NSMutableArray alloc]init];
    self.pfWidthArr=[[NSMutableArray alloc]init];
    self.coinsArrsArr=[[NSMutableArray alloc]init];
    self.demonArrsArr=[[NSMutableArray alloc]init];
    self.lastPF=[self create:1000 addOB:NO];
    [self addChild:self.lastPF];
    
}

-(void) initForNewGame{
    
}

//create platforms
-(CCLayer *) create:(int) _width addOB:(BOOL)addob{
    
    
    
    self.coinsArr=[[NSMutableArray alloc]init];
    self.obsArr=[[NSMutableArray alloc]init];
    
   mc=[CCLayer node];
    
  
    int _wid=_width;
    if(_wid<self.widMin){
        _wid=self.widMin;
    }
    
    
    int _widMid=_wid-(self.leftWidth+self.rightWidth);
    
    
    int numSpriteToCreate=_widMid/100;
    
    int maxNumOfOb=1;
    
    CCSprite * left=[CCSprite spriteWithSpriteFrameName:@"d0.png"];
    left.anchorPoint=ccp(0,1);
    [mc addChild:left];
      for(int i=0;i<numSpriteToCreate;i++){
        
        midMC=[self getDecalFromPool];
        
        
        midMC.anchorPoint=ccp(0,1);
        
        midMC.position=ccp(leftWidth+i*midWidth,0);

        
        [mc addChild:midMC];
        
        if(arc4random()%10>3){
            
            if(maxNumOfOb>0&&arc4random()%10>8&&addob){
                
                NSString *typeStr;
                CCSprite *ob;
                
                int rn=arc4random()%10;
                if(rn>=7&&rn<=9){
                   typeStr =@"stone";
                    ob=[CCSprite spriteWithSpriteFrameName:@"obstacle_small0001.png"];
                } 
                if(rn>=4&&rn<=6){
                    typeStr =@"fire";
                    ob=[CCSprite spriteWithSpriteFrameName:@"obstacle_small0003.png"];
                }
                
                if(rn>=1&&rn<=3){
                    typeStr =@"ice";
                    ob=[CCSprite spriteWithSpriteFrameName:@"obstacle_small0005.png"];
                }
                
                if(rn==0){
                    typeStr =@"no";
                    ob=[CCSprite spriteWithSpriteFrameName:@"obstacle_small0004.png"];
                }
                
                
                
                ob.position=ccp(midMC.position.x+5,midMC.position.y-16);
               
                [mc addChild:ob];
                
                NSMutableArray * objArr=[[NSMutableArray alloc]init];
                
                [objArr addObject:ob];
                
                [objArr addObject:typeStr];
                [self.obsArr addObject:objArr];
                
                maxNumOfOb--;
            }
            else {
                
                //adding the coin..
            
                id loopCoin= [CCRepeatForever actionWithAction:[CCAnimate actionWithSpriteSequence:@"coin%04d.png"
                                                            
                                                                                     numFrames:36 
                                                                                         delay:0.014f
                                                                          restoreOriginalFrame:NO]];            
                //prev delay 0.014
                CCSprite *coin=[CCSprite node];
            
                [coin runAction:loopCoin];
            
                
                int rn5=arc4random()%10;
                
                if (rn5<5) {
                    int rn1=arc4random()%150;
                    
                    coin.position=ccp(midMC.position.x+5,midMC.position.y+rn1);
                    
                    [mc addChild:coin];
                
                }

                    [self.coinsArr addObject:coin];
   
            }
            
        }
    }
    
    CCSprite * right=[CCSprite spriteWithSpriteFrameName:@"d6.png"];
    right.anchorPoint=ccp(0,1);
    right.position=ccp(leftWidth+numSpriteToCreate*midWidth,0);
    
    [mc addChild:right];
    
   
    
    if(!self.lastPF){
        mc.position=ccp(0,74);
    }
    
    self.lastWid=(numSpriteToCreate*midWidth+self.leftWidth+self.rightWidth);
    [pfWidthArr addObject:[NSNumber numberWithInt:self.lastWid]];
    
    [self.pfsArr addObject:mc];
    
    [self.coinsArrsArr addObject:self.coinsArr];
   [self.demonArrsArr addObject:self.demonArr];
    [self.obsArrsArr addObject:self.obsArr];
    return mc;
}

- (float)randomValueBetween:(float)low andValue:(float)high {
    
    return (((float) arc4random() / 0xFFFFFFFFu) * (high - low)) + low;
}

//get current coins array

-(NSMutableArray *) getCurrentCoinsArr{
    int idx=0;
    int arrCount=[self.coinsArrsArr count];
    
    if(((CCLayer *)([self.pfsArr objectAtIndex:0])).position.x+[[self.pfWidthArr objectAtIndex:0] intValue]<[Player initX]){
        
        idx=1;
        
    }
    
    if(arrCount==1&&idx==1){
        return nil;
    }
    
    if(arrCount>=0&&idx==0){
        return [self.coinsArrsArr objectAtIndex:0];
    }
    
    if(arrCount>=2&&idx==1){
        return [self.coinsArrsArr objectAtIndex:1];
    }
    
    return nil;
}

//get current demons array

-(NSMutableArray *) getCurrentDemonsArr{
    int idx=0;
     int arrCount=[self.demonArrsArr count];
     if(((CCLayer *)([self.pfsArr objectAtIndex:0])).position.x+[[self.pfWidthArr objectAtIndex:0] intValue]<[Player initX]){
        
        idx=1;
        
        
    }
    
    if(arrCount==1&&idx==1){
        return nil;
    }
    
    if(arrCount>=0&&idx==0){
      return [self.demonArrsArr objectAtIndex:0];
    }
    
    if(arrCount>=2&&idx==1){
        return [self.demonArrsArr objectAtIndex:1];
    }
    
    return nil;
}

//get current obstructs array

-(NSMutableArray *) getCurrentObsArr{
    int idx=0;
    
    int arrOb=[self.obsArrsArr count];
    
    
    
    if(((CCLayer *)([self.pfsArr objectAtIndex:0])).position.x+[[self.pfWidthArr objectAtIndex:0] intValue]<[Player initX]){
        
        idx=1;
    }
    
    if(arrOb==1&&idx==1){
        return nil;
    }
    
    if(arrOb>=0&&idx==0){
        return [self.obsArrsArr objectAtIndex:0];
    }
    
    if(arrOb>=2&&idx==1){
        return [self.obsArrsArr objectAtIndex:1];
    }
    
    return nil;
}

//try remove coin

-(void) tryRemoveCoin{
  
    NSMutableArray *cca=[self getCurrentCoinsArr];
    NSMutableArray *cca1=[self getCurrentDemonsArr];
    
    if(!flag){
        
        if (cca1) {
            int py1=((CCLayer *)(self.player)).position.y;
            for(int i=0;i<[cca1 count];i++){
                // CCSprite *enemy=[cca objectAtIndex:i];
                enemy=[cca1 objectAtIndex:i];
                //initial <6
                
                if (abs(enemy.position.x+enemy.parent.position.x-[Player initX])<6)
                {
                    if (abs(enemy.position.y+enemy.parent.position.y-py1)<22 && enemy.visible && enemy.visible) {
                        
                     flag=YES;
                        
                        if (self.lives<=0) {
                            
                        }else{
                          
                            [self.player gotoAndStop:@"fade" val:1];
                            
                        }
                   NSInteger myLife=[[NSUserDefaults standardUserDefaults] integerForKey:@"live"];
                    myLife = myLife-1;
                        
                        ((GameMain*)[self gm ]).lostLife.visible=YES;
                        
                        ((GameMain*)[self gm ]).lostLife.opacity=255;
                        
                        id delay = [CCDelayTime actionWithDuration:0.5];
                        id fadeAlphaTo0=[CCFadeTo actionWithDuration:0.5 opacity:0];
                        id func=[CCCallFunc actionWithTarget:self selector:@selector(hideLostLife)];
                        id action = [CCSequence actions:delay,fadeAlphaTo0,func,nil];
                        [((GameMain*)[self gm ]).lostLife runAction:action];
                        
                        
                        [[NSUserDefaults standardUserDefaults] setInteger:myLife forKey:@"live"];
                        
                        [[NSUserDefaults standardUserDefaults]synchronize];
                        NSLog(@"%d",myLife);
                      
                        [self.gm updateLives:myLife];
                        
                        GameMain *gameMain=(GameMain*)self.gm;
                        
                        if (myLife<=0) {
                            
                            gameMain.stopGame=YES;
                            [self removeChild:self.player cleanup:YES];
                            gameMain.stopGame=YES;
                            [self.player stopAllActions];
                            [gameMain removeChild:self.player cleanup:YES];
                            
                            NSMutableArray *walkAnimFrames = [NSMutableArray array];
                            for (int i=1; i<=6; i++) {
                                [walkAnimFrames addObject:
                                 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                                  [NSString stringWithFormat:@"fall%04d.png",i]]];
                            }
                            
                            id animation = [CCAnimation animationWithFrames:walkAnimFrames delay:0.06];
                            
                            self.fall = [CCSprite spriteWithSpriteFrameName:@"fall0001.png"];
                            CCAction*  walkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]];
                            
                            [self.fall runAction:walkAction];
                            self.fall.position=ccp(120,py1);
                            
                            //added now
                            
                            id actionMove = [CCMoveTo actionWithDuration:15 position:ccp(450,-400)];
                            
                            [self.fall runAction:actionMove];
                            
                            [self addChild:fall];
                            
                            [GameState sharedState].clear=TRUE;
                     
                            gameMain.stopGame=YES;
                            
                            [self removeChild:self.player cleanup:YES];
                            
                            [gameMain showGameOver];
                            
                        }
                        
                        if (self.soundValue==1) {
                            [[SimpleAudioEngine sharedEngine] playEffect:@"hurt.mp3" pitch:1 pan:0 gain:1];
                        }
                    }
                    else
                    {
                     
                    }
                    [cca1 removeObjectAtIndex:i];
                }
                
            }
        }
    }
    
    if(cca){
        int py=((CCLayer*)(self.player)).position.y;
        for(int i=0;i<[cca count];i++){
            CCSprite *coin=[cca objectAtIndex:i];
            if(abs(coin.position.x+coin.parent.position.x-[Player initX])<6){

                if(coin.position.y+coin.parent.position.y<py)
                {
                    
                    if(abs(coin.position.y+coin.parent.position.y-py)<20 && coin.visible&&coin.visible){
                        
                        [coin.parent removeChild:coin cleanup:YES];
                        
                        if (self.soundValue==1) {
                            [[SimpleAudioEngine sharedEngine] playEffect:@"coin.wav" pitch:1 pan:0 gain:1];
                        }
 
                        ++self.coinsNum;
                        [self.gm updateScore];
                        int level_check=[GameState sharedState].levelNumber;
                        bool k=FALSE;
                        if(level_check<=10&&self.coinsNum==25)//25
                        {
                            k=TRUE;
                        }
                        else
                            if(level_check<=20&&self.coinsNum==35)//35
                            {
                                k=TRUE;
                            }
                            else
                                if (level_check<=30&&self.coinsNum==40)//40
                                {
                                    k=TRUE;
                                }
                                else
                                    if(level_check<=40&&self.coinsNum==45)//45
                                    {
                                        k=TRUE;
                                    }
                                    else
                                        if(level_check<=50&&self.coinsNum==50)//50
                                        {
                                            k=TRUE;
                                        }
                        if(k){
                            self.currentLevel++;
                            [coin.parent removeChild:enemy cleanup:YES];
                            
                            self.levelBonus++;
                            [self.gm updatelevelBonus:(int)self.levelBonus];
                            
                            int check = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"levelClear"];
                            
                            if (self.currentLevel < check ) {
                                
                            }else{
                                
                                [[NSUserDefaults standardUserDefaults] setInteger:currentLevel forKey:@"levelClear"];
                                
                                [[NSUserDefaults standardUserDefaults]synchronize];
                            }
                            
                            
                            ((Player*)[self player ]).maxSpeed+=20;
                            
                            
                            if(self.gap<90){
                                self.gap+=10;
                            }
                            
                            ((GameMain*)[self gm ]).levelUp.visible=YES;
                            
                            ((GameMain*)[self gm ]).levelUp.opacity=255;
                            
                            id delay = [CCDelayTime actionWithDuration:0.5];
                            id fadeAlphaTo0=[CCFadeTo actionWithDuration:0.5 opacity:0];
                            id func=[CCCallFunc actionWithTarget:self selector:@selector(hideLevelUp)];
                            id action = [CCSequence actions:delay,fadeAlphaTo0,func,nil];
                            [((GameMain*)[self gm ]).levelUp runAction:action];
                            
                            if (self.soundValue==1) {
                                [[SimpleAudioEngine sharedEngine] playEffect:@"levelUp.wav" pitch:1 pan:0 gain:1];
                            }
                            
                            [((GameMain*)[self gm ]).bg setColorWithRBG];
                            
                            [((GameMain*)[self gm ]).bg setColorWithRBG];
                            GameMain *gameMain=(GameMain*)self.gm;
                            gameMain.stopGame=YES;
                            
                            [self removeChild:self.player cleanup:YES];
                            [GameState sharedState].next=TRUE;
                            
                            BOOL netwrok_status=[[NSUserDefaults standardUserDefaults] boolForKey:CurrentNetworkStatus];
                            if (netwrok_status == YES) {
                                AdMobFullScreenViewController *adf= [[AdMobFullScreenViewController alloc]init];
                            }
                            [gameMain showGameOver];
//                             [gameMain.viewHost1 removeFromSuperview];

                        }
                    }
                    
                }
                else
                {
                    if(abs(coin.position.y+coin.parent.position.y-py)<=80 && coin.visible&&coin.visible){
                        [coin.parent removeChild:coin cleanup:YES];
                        
                        if (self.soundValue==1) {
                            [[SimpleAudioEngine sharedEngine] playEffect:@"coin.wav" pitch:1 pan:0 gain:1];
                        }
                        
                        ++self.coinsNum;
                        [self.gm updateScore];
                        

                       int level_check=[GameState sharedState].levelNumber;
                        bool k=FALSE;
                        if(level_check<=10&&self.coinsNum==25)//25
                        {
                            k=TRUE;
                        }
                        else
                            if(level_check<=20&&self.coinsNum==35)//35
                            {
                                k=TRUE;
                            }
                            else
                                if (level_check<=30&&self.coinsNum==40)//40
                                {
                                    k=TRUE;
                                }
                                else
                                    if(level_check<=40&&self.coinsNum==45)//45
                                    {
                                        k=TRUE;
                                    }
                                    else
                                        if(level_check<=50&&self.coinsNum==50)//50
                                        {
                                            k=TRUE;
                                        }
                        
                        if(k){
                            
                            self.currentLevel++;
                            [self.gm updateLevel:self.currentLevel];
                            self.levelBonus++;
                            [self.gm updatelevelBonus:(int)self.levelBonus];
                            
                        
                            int check = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"levelClear"];
                            
                            if (self.currentLevel < check ) {
                                
                            }else{
                                
                                [[NSUserDefaults standardUserDefaults] setInteger:currentLevel forKey:@"levelClear"];
                                
                                [[NSUserDefaults standardUserDefaults]synchronize];
                            }
                            
                            ((Player*)[self player ]).maxSpeed+=20;
                            
                            
                            if(self.gap<90){
                                self.gap+=10;
                            }
                            
                            ((GameMain*)[self gm ]).levelUp.visible=YES;
                            
                            ((GameMain*)[self gm ]).levelUp.opacity=255;
                            
                            id delay = [CCDelayTime actionWithDuration:0.5];
                            id fadeAlphaTo0=[CCFadeTo actionWithDuration:0.5 opacity:0];
                            id func=[CCCallFunc actionWithTarget:self selector:@selector(hideLevelUp)];
                            id action = [CCSequence actions:delay,fadeAlphaTo0,func,nil];
                            [((GameMain*)[self gm ]).levelUp runAction:action];
                            
                            if (self.soundValue==1) {
                                [[SimpleAudioEngine sharedEngine] playEffect:@"levelUp.wav" pitch:1 pan:0 gain:1];
                            }
                            [((GameMain*)[self gm ]).bg setColorWithRBG];
                            GameMain *gameMain=(GameMain*)self.gm;
                            gameMain.stopGame=YES;
                            
                            [self removeChild:self.player cleanup:YES];
                            [GameState sharedState].next=TRUE;
                            BOOL netwrok_status=[[NSUserDefaults standardUserDefaults] boolForKey:CurrentNetworkStatus];
                            if (netwrok_status == YES) {
                                AdMobFullScreenViewController *adf= [[AdMobFullScreenViewController alloc]init];
                            }
                            [gameMain showGameOver];
//                             [gameMain.viewHost1 removeFromSuperview];

                        }
                    }
                    
                }
                
                
            }
        }
        
        
    }
    
    [self hitTestOB];
}


#pragma mark-
#pragma enemy control
-(void)enemycontrol
{
    
    if(counter<=[GameState sharedState].levelNumber*10)
    {
        NSMutableArray *walkAnimFrames = [NSMutableArray array];
        for (int i=1; i<=2; i++) {
            [walkAnimFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"enemy%04d.png",i]]];
            
        }
        
        id animation = [CCAnimation animationWithFrames:walkAnimFrames delay:0.50];
        
        enemy = [CCSprite spriteWithSpriteFrameName:@"enemy0001.png"];
        CCAction *walkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]];
       
        [enemy runAction:walkAction];
             int delay;
        delay=arc4random()%50;
        enemy.position=ccp(midMC.position.x-delay,midMC.position.y-12);
       
        int time=30;
        int levelno=[GameState sharedState].levelNumber;
        if(levelno>=40 && levelno<=50)
        {
            time=50;
        }
        if(levelno>=20 && levelno<=40)
        {
            time=40;
        }

        flag=false;
        
        [mc addChild:enemy];
        float duration=(midMC.position.x+50)/time;
        id actionMove = [CCMoveTo actionWithDuration:duration position:ccp(0,midMC.position.y-12)];
        id action1=[CCMoveTo actionWithDuration:2.0 position:ccp(0,midMC.position.y-200)];
        
        
        [enemy runAction:action1];
        
        [CCSequence actions:actionMove,action1,
         
         nil];
        [enemy runAction:actionMove];
        
        [self.demonArr addObject:enemy];
    }
    counter=counter+1;
}

- (void) done {
   flag=NO;
}

//check obstruct if player hittest it
#pragma mark
#pragma mark Check for obstruction collission.
#pragma mark =============================

-(void)hitTestOB{
    NSMutableArray * oba=[self getCurrentObsArr];
    
    if(oba){
          int py=((CCLayer*)(self.player)).position.y;
            for(int i=0;i<[oba count];i++){
            CCSprite *ob=[((NSMutableArray*)([oba objectAtIndex:i])) objectAtIndex:0];
            NSString *type=[((NSMutableArray*)([oba objectAtIndex:i])) objectAtIndex:1];
            if(abs(ob.position.x+(ob.parent.position.x+20)-[Player initX])<30){
                    if(abs(ob.position.y+ob.parent.position.y-py)<20&&ob.visible&&ob.opacity==255){
                    
                    ob.opacity=254;
                    
                    if([type isEqualToString: @"fire"]){
                        
                        if(((Player *)self.player).state==2||((Player *)self.player).state==0
                           ||((Player *)self.player).state==-3||((Player *)self.player).state==-4){
                            
                            if (self.soundValue==1){
                            [[SimpleAudioEngine sharedEngine] playEffect:@"ouch.wav" pitch:1 pan:0 gain:1];
                            }
                            
                            [self.player fireUp];                            
                        }
                    }
                    
                    else if([type isEqualToString: @"stone"]){
                        
                        if(((Player *)self.player).state==0){
                            [[SimpleAudioEngine sharedEngine] playEffect:@"hit.wav" pitch:1 pan:0 gain:1];
                            
                            [self.player gotoAndStop:@"hit" val:0];
                            
                            ((Player *)self.player).state=-2;
                        }
                        
                        
                    }
                    
                    else if([type isEqualToString: @"ice"]){
                        
                        if(((Player *)self.player).state==0){
                            [[SimpleAudioEngine sharedEngine] playEffect:@"slip.wav" pitch:1 pan:0 gain:1];
                            
                            [self.player gotoAndStop:@"ice" val:0];
                            
                            ((Player *)self.player).state=-4;
                        }
                        
                        
                    }
                    
                    
                }
                           
            }
            
        }
        
    }

}

//hide levelUP image of GameMain

-(void) hideLevelUp{
    
    ((GameMain*)[self gm ]).levelUp.visible=NO;
    [mc unschedule:@selector(enemycontrol)];
    [mc removeChild:enemy cleanup:YES];
}

-(void) hideLostLife{
    ((GameMain*)[self gm ]).lostLife.visible=NO;
    
}


//get current platform under player
#pragma mark
#pragma mark Get platform
#pragma mark =============================
-(CCLayer*) getCurrentPFUnderPlayer{
    CCLayer* repf=nil;
    int bordureX=-14;
    
    for(int i =0; i<[self.pfsArr count]; i++){
        
        CCLayer *pf=[self.pfsArr objectAtIndex:i];
        
        if(pf.position.x+[[self.pfWidthArr objectAtIndex:i]intValue]>Player.initX+bordureX&&pf.position.x<Player.initX-bordureX){
            repf=pf;
        }
        
    }
    
return repf;
    
}


-(void) addMidDecalToPool:(int)cnt{
    CCSprite *tempPF;
    NSString *fn;
    
    for(int i=0;i<cnt;i++){
        
        fn=[NSString stringWithFormat:@"d%i.png",(i%5)+1];
        tempPF=[CCSprite spriteWithSpriteFrameName:fn];
       
        [self.pool addObject:[CCSprite spriteWithSpriteFrameName:fn]];
    }
         
}

-(CCSprite *) getDecalFromPool{
     
    
    if([self.pool count]==0){
        [self addMidDecalToPool:5];
    }
    self.__pf=[self.pool objectAtIndex:0];
    
    [self.pool removeObjectAtIndex:0];
    
    return self.__pf;
}

-(int) getSafeY{
    int bordureY=30;
    CCLayer *pf=[self getCurrentPFUnderPlayer];
    if(pf!=nil){
        return pf.position.y-bordureY;
    }
                
    return -300;
}


-(void) dealloc{
    self.lastWid=0;
    self.lastPF=nil;
    self.__pf=nil;
    self.pool=nil;
    [super dealloc];
}


@end
