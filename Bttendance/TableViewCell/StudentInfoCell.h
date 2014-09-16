//
//  StudentInfoCell.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 8. 8..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface StudentInfoCell : UITableViewCell

+ (StudentInfoCell *)cellFromNibNamed;

@property(weak, nonatomic) IBOutlet UILabel *name;
@property(weak, nonatomic) IBOutlet UILabel *idnumber;
@property(weak, nonatomic) IBOutlet UIImageView *icon;
@property(weak, nonatomic) IBOutlet UILabel *detail;
@property(weak, nonatomic) IBOutlet UIView *background_bg;
@property(weak, nonatomic) IBOutlet UIView *selected_bg;
@property(weak, nonatomic) IBOutlet UIView *underline;

@end
