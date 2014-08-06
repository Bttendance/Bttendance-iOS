//
//  PasswordCell.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 7. 16..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordCell : UITableViewCell

+ (PasswordCell *)cellFromNibNamed:(NSString *)nibName;

@property(weak, nonatomic) IBOutlet UILabel *password;
@property(weak, nonatomic) IBOutlet UIView *selected_bg;
@property(weak, nonatomic) IBOutlet UIImageView *arrow;

@end
