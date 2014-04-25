//
//  CourseInfoCell.h
//  Bttendance
//
//  Created by TheFinestArtist on 2013. 12. 27..
//  Copyright (c) 2013년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "School.h"

@interface SchoolInfoCell : UITableViewCell

+ (SchoolInfoCell *)cellFromNibNamed:(NSString *)nibName;

@property(weak, nonatomic) IBOutlet UILabel *Info_SchoolName;
@property(weak, nonatomic) IBOutlet UILabel *Info_SchoolID;
@property(weak, nonatomic) IBOutlet UIButton *Info_Check;

@property(assign, nonatomic) School *school;

@end
