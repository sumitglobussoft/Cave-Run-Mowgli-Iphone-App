//
//  FriendsLevel.m
//  CaveRunMowgli
//
//  Created by Sumit on 01/12/14.
//
//

#import "FriendsLevel.h"
#import "GameMain.h"
#import "LevelSelectionScene.h"
#import "MainMenu.h"

@implementation FriendsLevel
@synthesize friendsView,bottomScroll;

+(CCScene *) scene
{
    // 'scene' is an autorelease object.
    CCScene *scene = [CCScene node];
    
    // 'layer' is an autorelease object.
    FriendsLevel *layer = [FriendsLevel node];
    
    // add layer as a child to scene
    [scene addChild:layer];
    
    // return the scene
    return scene;
}

-(id) init
{
    if( (self=[super init]))
    {
        CGSize ws=[[CCDirector sharedDirector]winSize];
        
        
        rootViewController = (UIViewController*)[(AppDelegate*)[[UIApplication sharedApplication] delegate] getRootViewController];
        
        spriteBackground=[CCSprite spriteWithFile:@"background_1-1.png"];
        spriteBackground.position=ccp(ws.width/2,ws.height/2);
        
        if ([UIScreen mainScreen].bounds.size.height<500) {
            [self resizeSprite:spriteBackground toWidth:500 toHeight:350];
        }else{
            [self resizeSprite:spriteBackground toWidth:600 toHeight:350];
        }
        [self addChild:spriteBackground];
                levelBackground=[CCSprite spriteWithFile:@"game-bg-1.png"];
        levelBackground.position=ccp(ws.width/2,ws.height/2);
        
        [self addChild:levelBackground];
                
        secondView = [[UIView alloc]initWithFrame:CGRectMake(110, 20, 245, 295)];
        [secondView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"popup.png"]]];
        [rootViewController.view addSubview:secondView];
        
        if ([UIScreen mainScreen].bounds.size.height<500) {
            friendsLevel = [[UILabel alloc]initWithFrame:CGRectMake(160, -20, 200, 100)];
        }else{
            friendsLevel = [[UILabel alloc]initWithFrame:CGRectMake(160, -20, 200, 100)];
        }
        friendsLevel.text=@"Friends Level Status";
        [rootViewController.view addSubview:friendsLevel];
        
        scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 20, 200, 200)];
        
        scrollV.contentSize=CGSizeMake(100,250);
        scrollV.scrollEnabled=YES;
//        scrollV.backgroundColor = [UIColor redColor];
        
//             [rootViewController.view addSubview:scrollV];
        
        
        [secondView addSubview:scrollV];
        
        UIImage *btnImage = [UIImage imageNamed:@"play.png"];
        playButton = [[UIButton alloc]init];
        playButton.frame = CGRectMake(70,220, 100, 50);
        [playButton setImage:btnImage forState:UIControlStateNormal];
        
        UIImage *backImage = [UIImage imageNamed:@"backLevel.png"];
        backButton = [[UIButton alloc]init];
       // backButton.frame = CGRectMake(-30,0,100, 50);
        if ([UIScreen mainScreen].bounds.size.height<500) {
             backButton.frame = CGRectMake(30,10,100, 50);
        }else{
            backButton.frame = CGRectMake(50,10,100, 50);
        }
//        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
////             if([UIScreen mainScreen].bounds.size.width>660) {
//           backButton.frame = CGRectMake(80,10,100, 50);
////             }
//            //iphone 6
//        }
        
        
        [backButton setImage:backImage forState:UIControlStateNormal];
        
//        [secondView addSubview:backButton];
        [rootViewController.view addSubview:backButton];
        [backButton addTarget:self action:@selector(backBtnAction1:) forControlEvents:UIControlEventTouchUpInside];

        [secondView addSubview:playButton];
        [playButton addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self findFriendsLevel];
        
    }
    return self;
}

-(void)backBtnAction1:(id)sender {
   scrollV.hidden=YES;
    scrollV = nil;
    playButton.hidden = YES;
    playButton=nil;
    secondView.hidden = YES;
    secondView=nil;
    friendsLevel.hidden = YES;
    friendsLevel = nil;
    backButton.hidden=YES;
    backButton=nil;
    
   [self removeChild:spriteBackground cleanup:YES];
    [self removeChild:levelBackground cleanup:YES];
    
    [[CCDirector sharedDirector] replaceScene:[MainMenu node]];
}


-(void)findPlayerLevel{
    
    
    NSString *fbID = [[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID];
    
    if (fbID) {
        
        PFQuery * query=[PFQuery queryWithClassName:ParseScoreTableName];
        [query whereKey:@"PlayerFacebookID" equalTo:fbID];
        [query orderByDescending:@"Level"];
        
        //       NSArray *num= [query getFirstObject];
        
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            
          NSNumber *num=object[@"Level"];
            int num1 = [num intValue]+1;
         [[NSUserDefaults standardUserDefaults] setInteger:num1  forKey:@"levelClear"];
            //[[NSUserDefaults standardUserDefaults] setInteger:50 forKey:@"levelClear"];
            [GameState sharedState].levelNumber=num1;
            [[NSUserDefaults standardUserDefaults]synchronize];
            
        }];
    }
}

-(void)playAction:(id)sender{
    
    playButton.hidden=YES;
    friendsLevel.hidden=YES;
    secondView.hidden = YES;
    friendsLevel.hidden=YES;
    friendsLevel = nil;
    playButton=nil;
    backButton.hidden=YES;
    
    [self removeChild:menuBack1 cleanup:YES];
    [self removeChild:spriteBackground cleanup:YES];
    [self removeChild:levelBackground cleanup:YES];
    
   //  [[CCDirector sharedDirector]replaceScene:[CCTransitionFadeTR transitionWithDuration:0.8 scene:[LevelSelectionScene scene]]];
    
    [[CCDirector sharedDirector]replaceScene:[LevelSelectionScene scene]];
}

-(void)resizeSprite:(CCSprite*)sprite toWidth:(float)width toHeight:(float)height {
    sprite.scaleX = width / sprite.contentSize.width;
    sprite.scaleY = height / sprite.contentSize.height;
}

-(void)findFriendsLevel{
    NSMutableArray *mutArr = [[NSMutableArray alloc]init];
    mutArr =[[NSUserDefaults standardUserDefaults] objectForKey:FacebookGameFrindes];
    
   // NSLog(@"MutArray %@",mutArr);
    if (mutArr.count<1) {
        [self retriveFriendsRandomScore:3];
        return;
    }
    
    
    NSMutableArray * level=[[NSMutableArray alloc]init];
    NSMutableArray * name=[[NSMutableArray alloc]init];
    NSMutableArray * Id=[[NSMutableArray alloc]init];
    
    PFQuery * query=[PFQuery queryWithClassName:ParseScoreTableName];
    [query whereKey:@"PlayerFacebookID" containedIn:mutArr];
    [query orderByDescending:@"Level"];
    //    NSArray * arr=[query findObjects];
    //    NSLog(@"array ====== %@",arr);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray * arr=[query findObjects];
//        NSLog(@"detail of friends %@",arr);
        
        for (int j=0; j<arr.count; j++) {
            PFObject * obj=[arr objectAtIndex:j];
            for(int k=0;k<mutArr.count;k++)
            {
                if(![Id containsObject:obj[@"PlayerFacebookID"]])
                {
                    [level addObject:obj[@"Level"]];
                    [name addObject:obj[@"Name"]];
                    [Id addObject:obj[@"PlayerFacebookID"]];
                }
            }
        }
        
        NSLog(@"Level %@",level);
        NSLog(@"name is %@",name);
        NSLog(@"id is %@",Id);
        
        for(int i=0;i<level.count;i++)
        {
            NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",Id[i]]];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                UIImageView *aimgeView = (UIImageView*)[self.friendsView viewWithTag:100+i];
                UILabel *label = (UILabel*)[self.friendsView viewWithTag:300+i];
                UILabel *positionLabel=(UILabel*)[self.friendsView viewWithTag:3000+i];
                if (aimgeView == nil) {
//                    UIImageView *profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+(i*90), 60, 35, 35)];
                   
                    UIImageView *profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10+(i*40), 35, 35)];
                    
                    profileImageView.tag = 100+i;
                    profileImageView.tag = 100+i;
                    profileImageView.layer.borderWidth=2;
                    profileImageView.layer.borderColor=[[UIColor orangeColor]CGColor];
                    
                    [scrollV addSubview:profileImageView];
                    [profileImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"58x58.png"]];
                }
                else{
                    aimgeView.hidden = NO;
                    [aimgeView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"58x58.png"]];
                }
                if (label==nil) {
                    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 15+(i*40), 150, 35)];
                    infoLabel.tag = 300+i;
                    infoLabel.backgroundColor = [UIColor clearColor];
                    infoLabel.font = [UIFont systemFontOfSize:10];
                    infoLabel.numberOfLines = 0;
                    infoLabel.lineBreakMode = NSLineBreakByCharWrapping;
                    infoLabel.text = [NSString stringWithFormat:@"%@",name[i]];
                    [scrollV addSubview:infoLabel];
                    
                    [infoLabel sizeToFit];
                }
                else{
                    label.hidden = NO;
                    label.text = [NSString stringWithFormat:@"%@",name[i]];
                    [label sizeToFit];
                }
                
                
                if(positionLabel==nil)
                {
                    
                    
                    UILabel * position=[[UILabel alloc] initWithFrame:CGRectMake(180, 10+(i*40), 30, 45)];
                    position.tag = 3000+i;
                    position.textColor = [UIColor orangeColor];
                    position.backgroundColor=[UIColor clearColor];
                    [position setFont:[UIFont fontWithName:@"ShallowGraveBB" size:20]];
                    position.numberOfLines = 0;
                    position.lineBreakMode = NSLineBreakByCharWrapping;
                    position.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@", level[i]]];
                    [scrollV addSubview:position];
                    
                }
                else
                {
                    positionLabel.hidden=NO;
                    positionLabel.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@", level[i]]];
                    
                    
                }
                
                
            });
        }
    });
}

#pragma mark- random score
-(void) retriveFriendsRandomScore:(NSInteger)level{
//    NSMutableArray *mutArr = [[NSMutableArray alloc]init];
    
    
    NSMutableArray * levelAry=[[NSMutableArray alloc]init];
    NSMutableArray * name=[[NSMutableArray alloc]init];
    NSMutableArray * Id=[[NSMutableArray alloc]init];
    
    PFQuery * query=[PFQuery queryWithClassName:ParseScoreTableName];
    [query orderByDescending:@"Score"];
    query.limit=3;

    //    NSArray * arr=[query findObjects];
    //    NSLog(@"array ====== %@",arr);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray * arr=[query findObjects];
//        NSLog(@"detail of friends %@",arr);
        
        for (int j=0; j<arr.count; j++) {
            PFObject * obj=[arr objectAtIndex:j];

                if(![Id containsObject:obj[@"PlayerFacebookID"]])
               {
                    [levelAry addObject:obj[@"Level"]];
                    [name addObject:obj[@"Name"]];
                    [Id addObject:obj[@"PlayerFacebookID"]];
               }

        }
        
        NSLog(@"Level %@",levelAry);
        NSLog(@"name is %@",name);
        NSLog(@"id is %@",Id);
        
        for(int i=0;i<levelAry.count;i++)
        {
            NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",Id[i]]];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                UIImageView *aimgeView = (UIImageView*)[self.friendsView viewWithTag:100+i];
                UILabel *label = (UILabel*)[self.friendsView viewWithTag:300+i];
                UILabel *positionLabel=(UILabel*)[self.friendsView viewWithTag:3000+i];
                if (aimgeView == nil) {
                    //                    UIImageView *profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+(i*90), 60, 35, 35)];
                    
                    UIImageView *profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10+(i*40), 35, 35)];
                    
                    profileImageView.tag = 100+i;
                    profileImageView.tag = 100+i;
                    profileImageView.layer.borderWidth=2;
                    profileImageView.layer.borderColor=[[UIColor orangeColor]CGColor];
                    
                    [scrollV addSubview:profileImageView];
                    [profileImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"58x58.png"]];
                }
                else{
                    aimgeView.hidden = NO;
                    [aimgeView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"58x58.png"]];
                }
                if (label==nil) {
                    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 15+(i*40), 150, 35)];
                    infoLabel.tag = 300+i;
                    infoLabel.backgroundColor = [UIColor clearColor];
                    infoLabel.font = [UIFont systemFontOfSize:10];
                    infoLabel.numberOfLines = 0;
                    infoLabel.lineBreakMode = NSLineBreakByCharWrapping;
                    infoLabel.text = [NSString stringWithFormat:@"%@",name[i]];
                    [scrollV addSubview:infoLabel];
                    
                    [infoLabel sizeToFit];
                }
                else{
                    label.hidden = NO;
                    label.text = [NSString stringWithFormat:@"%@",name[i]];
                    [label sizeToFit];
                }
                
                
                if(positionLabel==nil)
                {
                    
                    
                    UILabel * position=[[UILabel alloc] initWithFrame:CGRectMake(180, 10+(i*40), 30, 45)];
                    position.tag = 3000+i;
                    position.textColor = [UIColor orangeColor];
                    position.backgroundColor=[UIColor clearColor];
                    [position setFont:[UIFont fontWithName:@"ShallowGraveBB" size:20]];
                    position.numberOfLines = 0;
                    position.lineBreakMode = NSLineBreakByCharWrapping;
                    position.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@", levelAry[i]]];
                    [scrollV addSubview:position];
                    
                }
                else
                {
                    positionLabel.hidden=NO;
                    positionLabel.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@", levelAry[i]]];
                }
            });
        }
    });

}

#pragma mark- find friends current level

-(void)displayFriendsListUI{
    
    NSMutableArray *mutArr1 = [[NSMutableArray alloc]init];
    mutArr1 =[[NSUserDefaults standardUserDefaults] objectForKey:FacebookGameFrindes];
    if(!self.friendsView)
    {
        self.friendsView=[[UIView alloc]init];
        if([UIScreen mainScreen].bounds.size.height<500)
        {
            self.friendsView.frame=CGRectMake(10, 320, 295, 160);
        }
        else{
            self.friendsView.frame=CGRectMake(10, 400, 295, 160);
        }
        //self.friendsView.backgroundColor=[UIColor colorWithRed:(CGFloat)183/255 green:(CGFloat)222/255 blue:(CGFloat)243/255 alpha:0.7];
        self.friendsView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"friends_level.png"]];
        self.friendsView.layer.cornerRadius=4;
        self.friendsView.clipsToBounds=YES;
//        [rootViewController.view addSubview:self.friendsView];
    }
    self.friendsView.hidden=NO;
    if(!self.bottomScroll)
    {
        scrollV=[[UIScrollView alloc]init];
        scrollV.frame=CGRectMake(0, 10, self.friendsView.frame.size.width,self.friendsView.frame.size.height);
       scrollV.backgroundColor=[UIColor clearColor];
        [self.friendsView addSubview:scrollV];
    }
    scrollV.hidden=NO;
    
    scrollV.contentSize=CGSizeMake(scrollV.frame.size.width, scrollV.frame.size.height*80);
    
}


@end
