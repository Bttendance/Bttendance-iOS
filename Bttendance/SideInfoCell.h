//
//  SideInfoCell.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 7. 16..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideInfoCell : UITableViewCell

+ (SideInfoCell *)cellFromNibNamed;

@property (weak, nonatomic) IBOutlet UILabel *Info;
@property (weak, nonatomic) IBOutlet UIImageView *Icon;
@property(weak, nonatomic) IBOutlet UIView *selected_bg;

@end
