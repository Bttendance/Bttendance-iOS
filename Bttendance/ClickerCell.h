//
//  ClickerCell.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 5. 2..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@interface ClickerCell : UITableViewCell

+ (ClickerCell *)cellFromNimNamed:(NSString *)nimName;

@property(weak, nonatomic) IBOutlet UIView *background;

@property(weak, nonatomic) IBOutlet UILabel *courseName;
@property(weak, nonatomic) IBOutlet UILabel *message;
@property(weak, nonatomic) IBOutlet UILabel *date;

@property(weak, nonatomic) IBOutlet UIView *bg_a;
@property(weak, nonatomic) IBOutlet UIView *bg_b;
@property(weak, nonatomic) IBOutlet UIView *bg_c;
@property(weak, nonatomic) IBOutlet UIView *bg_d;

@property(weak, nonatomic) IBOutlet UIImageView *ring_a;
@property(weak, nonatomic) IBOutlet UIImageView *ring_b;
@property(weak, nonatomic) IBOutlet UIImageView *ring_c;
@property(weak, nonatomic) IBOutlet UIImageView *ring_d;

@property(weak, nonatomic) IBOutlet UIImageView *blink_a;
@property(weak, nonatomic) IBOutlet UIImageView *blink_b;
@property(weak, nonatomic) IBOutlet UIImageView *blink_c;
@property(weak, nonatomic) IBOutlet UIImageView *blink_d;

@property(retain, nonatomic) Post *post;

@end
