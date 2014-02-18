//
//  StdCourseView.h
//  bttendance
//
//  Created by HAJE on 2014. 1. 15..
//  Copyright (c) 2014년 Utopia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import "BTUserDefault.h"
#import "BTColor.h"
#import "ButtonCell.h"
#import "CourseCell.h"
#import "CourseAttendView.h"
#import "CourseDetailViewController.h"
#import "BTAPIs.h"
#import "BTUserDefault.h"
#import "SchoolChooseView.h"


@interface CourseListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>{
    
    NSInteger rowcount1;
    NSInteger rowcount2;
    
    NSMutableArray *data;
    NSDictionary *userinfo;
    NSArray *supervisingCourses;
    NSArray *attendingCourses;
    
    CourseCell *currentcell;
}

@property (weak, nonatomic) IBOutlet UITableView *tableview;


-(void)move_to_school:(id)sender;
-(void)move_to_course:(id)sender;

@end
