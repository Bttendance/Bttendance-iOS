//
//  TextInputCell.m
//  Bttendance
//
//  Created by TheFinestArtist on 2013. 11. 27..
//  Copyright (c) 2013년 Bttendance. All rights reserved.
//

#import "TextInputCell.h"
#import "UIColor+Bttendance.h"

@implementation TextInputCell
@synthesize textfield;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        textfield = [[UITextField alloc] initWithFrame:CGRectMake(98, 1, 222, 40)];
        textfield.tintColor = [UIColor silver:1];
        UIView *underline = [[UIView alloc] initWithFrame:CGRectMake(0, 43, 320, 1)];
        UIView *left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 44)];
        UIView *right = [[UIView alloc] initWithFrame:CGRectMake(319, 0, 1, 44)];
        underline.backgroundColor = [UIColor grey:1];
        left.backgroundColor = [UIColor grey:1];
        right.backgroundColor = [UIColor grey:1];
        [self addSubview:textfield];
        [self addSubview:underline];
        [self addSubview:left];
        [self addSubview:right];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
