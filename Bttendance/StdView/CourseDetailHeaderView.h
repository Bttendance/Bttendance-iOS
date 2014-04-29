//
//  StdCourseDetailHeaderView.h
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 1. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseDetailHeaderView : UIView

+ (CourseDetailHeaderView *)viewFromNibNamed:(NSString *)nibName;

@property(weak, nonatomic) IBOutlet UIView *bg;

@property(weak, nonatomic) IBOutlet UILabel *profname;
@property(weak, nonatomic) IBOutlet UILabel *schoolname;
@property(weak, nonatomic) IBOutlet UILabel *studentNumber;
@property(weak, nonatomic) IBOutlet UILabel *attendanceGrade;
@property(weak, nonatomic) IBOutlet UILabel *clickerUsage;
@property(weak, nonatomic) IBOutlet UILabel *noticeUsage;
@property(weak, nonatomic) IBOutlet UIView *background;
@property(weak, nonatomic) IBOutlet UIView *grade;
@property(weak, nonatomic) IBOutlet UIButton *BTicon;

@property(weak, nonatomic) IBOutlet UIButton *noticeBt;
@property(weak, nonatomic) IBOutlet UIButton *clickerBt;
@property(weak, nonatomic) IBOutlet UIButton *gradeBt;
@property(weak, nonatomic) IBOutlet UIButton *managerBt;
@end
