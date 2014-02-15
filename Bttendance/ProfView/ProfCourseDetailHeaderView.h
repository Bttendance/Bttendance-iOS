//
//  ProfCourseDetailHeaderView.h
//  Bttendance
//
//  Created by HAJE on 2014. 1. 24..
//  Copyright (c) 2014년 Utopia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfCourseDetailHeaderView : UIView

+(ProfCourseDetailHeaderView *)viewFromNibNamed:(NSString *)nibName;

@property (weak, nonatomic) IBOutlet UILabel *profname;
@property (weak, nonatomic) IBOutlet UILabel *schoolname;
@property (weak, nonatomic) IBOutlet UILabel *lectureattr;
@property (weak, nonatomic) IBOutlet UILabel *data_time;
@property (weak, nonatomic) IBOutlet UILabel *classplace;
@property (weak, nonatomic) IBOutlet UIButton *Notice;
@property (weak, nonatomic) IBOutlet UIButton *Grade;
@property (weak, nonatomic) IBOutlet UIButton *TA;

@end
