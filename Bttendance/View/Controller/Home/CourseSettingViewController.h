//
//  CourseSettingViewController.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 7. 25..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"
#import "SimpleCourse.h"

@interface CourseSettingViewController : UITableViewController <UIAlertViewDelegate>

@property(retain, nonatomic) SimpleCourse *simpleCourse;

@end
