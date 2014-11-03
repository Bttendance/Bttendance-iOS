//
//  OptionCell.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 9. 17..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "OptionCell.h"

@implementation OptionCell

+ (OptionCell *)cellFromNibNamed {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"OptionCell" owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    OptionCell *cell = nil;
    NSObject *nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[OptionCell class]]) {
            cell = (OptionCell *) nibItem;
            break;
        }
    }
    return cell;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if (highlighted)
        self.selected_bg.hidden = NO;
    else
        self.selected_bg.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (selected)
        self.check.hidden = NO;
    else
        self.check.hidden = YES;
}

@end
