//
//  GradeCell.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 1. 28..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface GradeCell : UITableViewCell

+ (GradeCell *)cellFromNibNamed:(NSString *)nibName;

@property(weak, nonatomic) IBOutlet UIImageView *profile_image;
@property(weak, nonatomic) IBOutlet UILabel *name;
@property(weak, nonatomic) IBOutlet UILabel *idnumber;
@property(weak, nonatomic) IBOutlet UIImageView *grade_image;
@property(weak, nonatomic) IBOutlet UILabel *att;
@property(weak, nonatomic) IBOutlet UILabel *tot;

@end
