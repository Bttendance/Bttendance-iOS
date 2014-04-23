//
//  StdProfileHeaderView.h
//  bttendance
//
//  Created by HAJE on 2014. 1. 21..
//  Copyright (c) 2014년 Utopia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileHeaderView : UIView

@property(weak, nonatomic) IBOutlet UIImageView *Profile_image;
@property(weak, nonatomic) IBOutlet UILabel *accountType;
@property(weak, nonatomic) IBOutlet UILabel *userName;

+ (ProfileHeaderView *)viewFromNibNamed:(NSString *)nibName;

@property(weak, nonatomic) IBOutlet UIButton *edit_button;

@end
