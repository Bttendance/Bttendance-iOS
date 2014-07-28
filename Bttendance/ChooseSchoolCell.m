//
//  ChooseSchoolCell.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 7. 28..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "ChooseSchoolCell.h"
#import "BTColor.h"

@implementation ChooseSchoolCell
@synthesize textfield, selected_bg;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 44)];
        UIView *right = [[UIView alloc] initWithFrame:CGRectMake(319, 0, 1, 44)];
        left.backgroundColor = [BTColor BT_grey:1];
        right.backgroundColor = [BTColor BT_grey:1];
        [self addSubview:left];
        [self addSubview:right];
        
        UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(295, 14, 10, 15)];
        [arrow setImage:[UIImage imageNamed:@"arrow.png"]];
        [self addSubview:arrow];
        
        selected_bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        selected_bg.backgroundColor = [BTColor BT_cyan:0.1];
        [self addSubview:selected_bg];
        
        textfield = [[UITextField alloc] initWithFrame:CGRectMake(98, 1, 222, 40)];
        textfield.tintColor = [BTColor BT_silver:1];
        UIView *underline = [[UIView alloc] initWithFrame:CGRectMake(0, 43, 320, 1)];
        underline.backgroundColor = [BTColor BT_grey:1];
        [self addSubview:textfield];
        [self addSubview:underline];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if (highlighted)
        self.selected_bg.hidden = NO;
    else
        self.selected_bg.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (selected)
        self.selected_bg.hidden = NO;
    else
        self.selected_bg.hidden = YES;
}

@end
