//
//  CourseCell.h
//  Bttendance
//
//  Created by TheFinestArtist on 2013. 12. 6..
//  Copyright (c) 2013년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseCell : UITableViewCell {
}

+ (CourseCell *)cellFromNibNamed:(NSString *)nibName;

@property(weak, nonatomic) IBOutlet UILabel *CourseName;
@property(weak, nonatomic) IBOutlet UILabel *Professor;
@property(weak, nonatomic) IBOutlet UILabel *School;

@property(weak, nonatomic) IBOutlet UIButton *attendanceBt;
@property(weak, nonatomic) IBOutlet UIButton *clickerBt;
@property(weak, nonatomic) IBOutlet UIButton *noticeBt;

@property(assign, nonatomic) NSInteger CourseID;
@property(assign, nonatomic) NSInteger grade;

@property(weak, nonatomic) IBOutlet UIView *background;
@property(weak, nonatomic) IBOutlet UIButton *check_button;
@property(weak, nonatomic) IBOutlet UIImageView *check_icon;

@property(weak, nonatomic) IBOutlet UIView *cellbackground;

@property(assign, nonatomic) NSDate *attdCheckedDate;
@property(assign, nonatomic) NSInteger gap;

@property(assign, nonatomic) NSTimer *blink;
@property(assign, nonatomic) NSInteger blinkTime;

@property(assign, nonatomic) BOOL isManager;

@end
