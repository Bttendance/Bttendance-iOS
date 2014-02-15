//
//  customCell.m
//  Bttendance
//
//  Created by HAJE on 2013. 11. 27..
//  Copyright (c) 2013년 Utopia. All rights reserved.
//

#import "customCell.h"

@implementation customCell
@synthesize textfield;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        textfield = [[UITextField alloc] initWithFrame:CGRectMake(98, 3, 222, 40)];
//        textfield.borderStyle ;
        [self addSubview:textfield];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
