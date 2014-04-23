//
//  CourseInfoCell.h
//  Bttendance
//
//  Created by HAJE on 2013. 12. 27..
//  Copyright (c) 2013년 Utopia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>

@interface CourseInfoCell : UITableViewCell

+ (CourseInfoCell *)cellFromNibNamed:(NSString *)nibName;

@property(weak, nonatomic) IBOutlet UILabel *Info_ProfName;
@property(weak, nonatomic) IBOutlet UILabel *Info_CourseName;
@property(weak, nonatomic) IBOutlet UIButton *Info_Check;
@property(weak, nonatomic) IBOutlet UIButton *Info_Button;
@property(assign, nonatomic) NSInteger Info_CourseID;

@property(weak, nonatomic) NSString *Info_SchoolName;
@property(weak, nonatomic) NSString *Info_CourseNumber;

@end
