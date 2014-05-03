//
//  StdCourseDetailView.h
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 1. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"

@interface CourseDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate> {

    NSInteger rowcount;
    NSArray *data;

    NSString *my_id;
    Boolean auth;
}

@property(weak, nonatomic) IBOutlet UITableView *tableview;

@property(retain, nonatomic) Course *course;
@property(retain, nonatomic) SimpleCourse *simpleCourse;
@property(nonatomic) Boolean auth;

@end
