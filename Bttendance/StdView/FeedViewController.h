//
//  StdFeedView.h
//  bttendance
//
//  Created by HAJE on 2014. 1. 15..
//  Copyright (c) 2014년 Utopia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseCell.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <MapKit/MapKit.h>
#import <AFNetworking/AFNetworking.h>
#import "BTUserDefault.h"
#import "CourseAttendView.h"
#import "CourseInfoCell.h"
#import "BTColor.h"
#import "PostCell.h"
#import "ButtonCell.h"
#import "AppDelegate.h"
#import "CourseCreateController.h"
#import "AttdStatViewController.h"
#import "BTAPIs.h"

@interface FeedViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    
    NSDictionary *userinfo;
    NSMutableArray * data;
    
    NSString *pid;
    NSString *cid;
    NSString *my_id;
    
    PostCell *currentpostcell;
    CourseCell *currentcoursecell;
    
    NSInteger rowcount;
    int time;
    
    Boolean locationcheck;
    Boolean first_launch;
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableview;

-(void)showing_timer_post:(PostCell *) cell;
-(void)change_check_post:(NSTimer *)timer;
-(void)send_attendance_check:(id)sender;
-(void)receiveMessage:(id)sender;

@end
