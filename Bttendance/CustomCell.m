//
//  CustomCell.m
//  Bttendance
//
//  Created by HAJE on 2013. 11. 27..
//  Copyright (c) 2013년 Utopia. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell
@synthesize textfield;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        textfield = [[UITextField alloc] initWithFrame:CGRectMake(98, 1, 222, 40)];
        UIView *underline = [[UIView alloc] initWithFrame:CGRectMake(0, 43, 320, 1)];
        underline.backgroundColor = [BTColor BT_grey:1];
        [self addSubview:textfield];
        [self addSubview:underline];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
