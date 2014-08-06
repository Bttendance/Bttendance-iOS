//
//  CourseSettingViewController.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 7. 25..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"

@interface CourseSettingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property(retain, nonatomic) SimpleCourse *simpleCourse;
@property(weak, nonatomic) IBOutlet UITableView *tableview;

@end
