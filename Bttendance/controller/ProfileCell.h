//
//  ProfileCell.h
//  bttendance
//
//  Created by HAJE on 2014. 1. 22..
//  Copyright (c) 2014년 Utopia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *data;

+(ProfileCell *)cellFromNibNamed:(NSString *)nibName;
@end
