//
//  CourseInfoCell.h
//  Bttendance
//
//  Created by TheFinestArtist on 2013. 12. 27..
//  Copyright (c) 2013년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "School.h"
#import "SchoolSimple.h"

@interface SchoolInfoCell : UITableViewCell

+ (SchoolInfoCell *)cellFromNibNamed:(NSString *)nibName;

@property(weak, nonatomic) IBOutlet UILabel *Info_SchoolName;
@property(weak, nonatomic) IBOutlet UILabel *Info_SchoolID;
@property(weak, nonatomic) IBOutlet UIImageView *arrow;
@property(weak, nonatomic) IBOutlet UIView *selected_bg;

@property(retain, nonatomic) School *school;
@property(retain, nonatomic) SchoolSimple *simpleSchool;

@end
