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

@property(weak, nonatomic) IBOutlet UILabel *coursename;
@property(weak, nonatomic) IBOutlet UILabel *detail;

@property(weak, nonatomic) IBOutlet UIView *clickerBg;
@property(weak, nonatomic) IBOutlet UIView *attendanceBg;
@property(weak, nonatomic) IBOutlet UIView *noticeBg;

@property(weak, nonatomic) IBOutlet UIButton *clickerBt;
@property(weak, nonatomic) IBOutlet UIButton *attendanceBt;
@property(weak, nonatomic) IBOutlet UIButton *noticeBt;

@property(weak, nonatomic) IBOutlet UIImageView *clickerView;
@property(weak, nonatomic) IBOutlet UIImageView *attendanceView;
@property(weak, nonatomic) IBOutlet UIImageView *noticeView;

@property(weak, nonatomic) IBOutlet UILabel *clickerLabel;
@property(weak, nonatomic) IBOutlet UILabel *attendanceLabel;
@property(weak, nonatomic) IBOutlet UILabel *noticeLabel;

@property(weak, nonatomic) IBOutlet UIView *classBg;
@property(weak, nonatomic) IBOutlet UIView *classHeader;
@property(weak, nonatomic) IBOutlet UIView *classFooter;

@property(weak, nonatomic) IBOutlet UILabel *classcode;
@property(weak, nonatomic) IBOutlet UILabel *code;

@end
