//
//  OptionCell.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 9. 17..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionCell : UITableViewCell

+ (OptionCell *)cellFromNibNamed;

@property(weak, nonatomic) IBOutlet UILabel *title;
@property(weak, nonatomic) IBOutlet UIView *selected_bg;
@property(weak, nonatomic) IBOutlet UIImageView *check;

@end
