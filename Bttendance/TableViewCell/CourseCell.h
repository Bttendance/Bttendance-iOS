//
//  CourseCell.h
//  Bttendance
//
//  Created by TheFinestArtist on 2013. 12. 6..
//  Copyright (c) 2013년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"

@interface CourseCell : UITableViewCell {
}

+ (CourseCell *)cellFromNibNamed:(NSString *)nibName;

@property(weak, nonatomic) IBOutlet UILabel *CourseName;
@property(weak, nonatomic) IBOutlet UILabel *Professor;
@property(weak, nonatomic) IBOutlet UILabel *School;

@property(weak, nonatomic) IBOutlet UIButton *clickerBt;
@property(weak, nonatomic) IBOutlet UIButton *attendanceBt;
@property(weak, nonatomic) IBOutlet UIButton *noticeBt;

@property(weak, nonatomic) IBOutlet UIImageView *clickerView;
@property(weak, nonatomic) IBOutlet UIImageView *attendanceView;
@property(weak, nonatomic) IBOutlet UIImageView *noticeView;

@property(weak, nonatomic) IBOutlet UIView *background;
@property(weak, nonatomic) IBOutlet UIImageView *check_image;
@property(weak, nonatomic) IBOutlet UIImageView *check_icon;

@property(weak, nonatomic) IBOutlet UIView *cellbackground;

@property(retain, nonatomic) Course *course;
@property(retain, nonatomic) SimpleCourse *simpleCourse;

@property(assign, nonatomic) NSInteger gap;

@property(assign, nonatomic) BOOL isManager;

@end
