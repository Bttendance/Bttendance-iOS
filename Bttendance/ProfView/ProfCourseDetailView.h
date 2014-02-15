//
//  ProfCourseDetailView.h
//  Bttendance
//
//  Created by HAJE on 2014. 1. 24..
//  Copyright (c) 2014년 Utopia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfCourseDetailHeaderView.h"
#import "PostCell.h"
#import "CourseCell.h"
#import "BTUserDefault.h"
#import "BTColor.h"
#import <AFNetworking/AFNetworking.h>
#import "NoticeView.h"
#import "GradeView.h"

@interface ProfCourseDetailView : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    __weak CourseCell *currentcell;
    
    NSDictionary *userinfo;
    
    NSInteger rowcount;
    
    NSMutableArray *data;
    
    NSString *my_id;
    
    int time;
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) CourseCell *currentcell;

-(void)showing_timer_post:(PostCell *) cell;
-(void)change_check_postpcdv:(NSTimer *)timer;
-(void)create_notice;
-(void)show_grade;
@end
