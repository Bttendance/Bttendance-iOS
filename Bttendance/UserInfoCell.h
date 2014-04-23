//
//  CourseInfoCell.h
//  Bttendance
//
//  Created by TheFinestArtist on 2013. 12. 27..
//  Copyright (c) 2013년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoCell : UITableViewCell

+ (UserInfoCell *)cellFromNibNamed:(NSString *)nibName;

@property(weak, nonatomic) IBOutlet UILabel *Username;
@property(weak, nonatomic) IBOutlet UILabel *Email;
@property(weak, nonatomic) IBOutlet UIButton *Check;

@property(assign, nonatomic) NSInteger Info_UserID;
@property(weak, nonatomic) NSString *Info_Username;
@property(weak, nonatomic) NSString *Info_Email;

@end
