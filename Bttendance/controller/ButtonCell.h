//
//  ButtonCell.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 1. 3..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonCell : UITableViewCell {
}

+ (ButtonCell *)cellFromNibNamed:(NSString *)nibName;

@property(weak, nonatomic) IBOutlet UIButton *button;

@end