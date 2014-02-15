//
//  ButtonCell.h
//  bttendance
//
//  Created by HAJE on 2014. 1. 3..
//  Copyright (c) 2014년 Utopia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BttendanceColor.h"

@interface ButtonCell :UITableViewCell {
}

+(ButtonCell *)cellFromNibNamed:(NSString *)nibName;

@property (weak, nonatomic) IBOutlet UIButton *button;

@end