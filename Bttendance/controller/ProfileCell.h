//
//  ProfileCell.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 1. 22..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileCell : UITableViewCell


@property(weak, nonatomic) IBOutlet UILabel *title;
@property(weak, nonatomic) IBOutlet UILabel *data;

+ (ProfileCell *)cellFromNibNamed:(NSString *)nibName;
@end
