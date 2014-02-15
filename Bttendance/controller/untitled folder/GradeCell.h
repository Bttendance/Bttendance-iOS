//
//  GradeCell.h
//  bttendance
//
//  Created by HAJE on 2014. 1. 28..
//  Copyright (c) 2014년 Utopia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GradeCell : UITableViewCell

+(GradeCell *)cellFromNibNamed:(NSString *)nibName;
@property (weak,nonatomic) IBOutlet UIImageView *profile_image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *idnumber;
@property (weak, nonatomic) IBOutlet UIImageView *grade_image;
@property (weak, nonatomic) IBOutlet UILabel *att;
@property (weak, nonatomic) IBOutlet UILabel *tot;


@end
