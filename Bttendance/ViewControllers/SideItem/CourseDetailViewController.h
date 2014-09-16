//
//  StdCourseDetailView.h
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 1. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"
#import "User.h"
#import "CourseDetailHeaderView.h"
#import "RESideMenu.h"

@interface CourseDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate> {

    NSMutableArray *data;

    NSString *my_id;
    
    User *user;
    NSTimer *refreshTimer;
    
    CourseDetailHeaderView *coursedetailheaderview;
}

@property(weak, nonatomic) IBOutlet UITableView *tableview;
@property(strong, nonatomic) SimpleCourse *simpleCourse;

@end
