//
//  CourseInfoCell.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 7. 16..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideCourseInfoCell : UITableViewCell

+ (SideCourseInfoCell *)cellFromNibNamed:(NSString *)nibName;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *message1;
@property (weak, nonatomic) IBOutlet UILabel *message2;

@end
