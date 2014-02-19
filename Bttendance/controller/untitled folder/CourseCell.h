//
//  CourseCell.h
//  Bttendance
//
//  Created by HAJE on 2013. 12. 6..
//  Copyright (c) 2013년 Utopia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseCell : UITableViewCell {
}

+(CourseCell *)cellFromNibNamed:(NSString *)nibName;
@property (weak, nonatomic) IBOutlet UILabel *CourseName;
@property (weak, nonatomic) IBOutlet UILabel *Professor;
@property (weak, nonatomic) IBOutlet UILabel *School;

@property (assign, nonatomic) NSInteger CourseID;
@property (assign, nonatomic) NSInteger timer;
@property (assign, nonatomic) NSDate *time;
@property (assign, nonatomic) NSInteger gap;
@property (assign, nonatomic) NSInteger lastpid;
@property (assign, nonatomic) NSInteger grade;

@property (weak, nonatomic) IBOutlet UIImageView *background;
@property (weak, nonatomic) IBOutlet UIButton *check_button;
@property (weak, nonatomic) IBOutlet UIImageView *check_icon;

@property (weak, nonatomic) IBOutlet UIImageView *cellbackground;

@property (weak, nonatomic) NSTimer *nstimer;

@end
