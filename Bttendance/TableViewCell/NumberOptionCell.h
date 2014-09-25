//
//  NumberOptionCell.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 9. 17..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NumberOptionCell : UITableViewCell

+ (NumberOptionCell *)cellFromNibNamed;

@property(weak, nonatomic) IBOutlet UITextField *title;
@property(weak, nonatomic) IBOutlet UILabel *label;
@property(weak, nonatomic) IBOutlet UIView *selected_bg;
@property(weak, nonatomic) IBOutlet UIImageView *check;

@end
