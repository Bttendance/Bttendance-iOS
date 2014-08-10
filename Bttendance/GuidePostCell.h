//
//  GuidePostCell.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 8. 10..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuidePostCell : UITableViewCell

+ (GuidePostCell *)cellFromNibNamed:(NSString *)nibName;

@property(weak, nonatomic) IBOutlet UILabel *Message;

@property(weak, nonatomic) IBOutlet UIImageView *check_icon;
@property(weak, nonatomic) IBOutlet UIImageView *check_overlay;

@property(weak, nonatomic) IBOutlet UIView *cellbackground;
@property(weak, nonatomic) IBOutlet UIView *selected_bg;

@end
