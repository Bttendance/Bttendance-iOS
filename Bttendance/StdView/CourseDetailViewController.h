//
//  StdCourseDetailView.h
//  Bttendance
//
//  Created by HAJE on 2014. 1. 24..
//  Copyright (c) 2014년 Utopia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseDetailHeaderView.h"
#import "PostCell.h"
#import "CourseCell.h"
#import "BTUserDefault.h"
#import "BTColor.h"
#import <AFNetworking/AFNetworking.h>
#import "BTAPIs.h"
#import "GradeViewController.h"
#import "CreateNoticeViewController.h"
#import "ManagerViewController.h"


@interface CourseDetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    __weak CourseCell *currentcell;
    
    NSDictionary *userinfo;
    NSInteger rowcount;
    NSMutableArray *data;
    
    NSString *my_id;
    Boolean auth;
    
    int time;
}

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) CourseCell *currentcell;
@property (nonatomic) Boolean auth;

-(void)showing_timer_post:(PostCell *) cell;
-(void)change_check_post2:(NSTimer *)timer;
@end
