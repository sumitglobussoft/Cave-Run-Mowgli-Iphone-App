//
//  FacebookFriendsTableViewController.h
//  CaveRun
//
//  Created by GBS-ios on 8/18/14.
//
//

#import <UIKit/UIKit.h>

@interface FacebookFriendsTableViewController : UITableViewController
@property (nonatomic, retain) NSArray *friendListArray;
@property (nonatomic, retain) NSMutableArray *selectedFriendsArray;
@property (nonatomic, retain) NSDictionary *paramDict;
@end
