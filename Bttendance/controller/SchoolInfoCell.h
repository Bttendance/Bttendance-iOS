//
//  CourseInfoCell.h
//  Bttendance
//
//  Created by HAJE on 2013. 12. 27..
//  Copyright (c) 2013년 Utopia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SchoolInfoCell : UITableViewCell

+ (SchoolInfoCell *)cellFromNibNamed:(NSString *)nibName;

@property(weak, nonatomic) IBOutlet UILabel *Info_SchoolName;
@property(weak, nonatomic) IBOutlet UILabel *Info_SchoolID;
@property(weak, nonatomic) IBOutlet UIButton *Info_Check;
@property(assign, nonatomic) NSInteger Info_SchoolID_int;

@end
