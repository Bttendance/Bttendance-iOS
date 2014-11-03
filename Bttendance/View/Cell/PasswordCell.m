//
//  PasswordCell.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 7. 16..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "PasswordCell.h"

@implementation PasswordCell

+ (PasswordCell *)cellFromNibNamed:(NSString *)nibName {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    PasswordCell *cell = nil;
    NSObject *nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[PasswordCell class]]) {
            cell = (PasswordCell *) nibItem;
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
        self.selected_bg.hidden = NO;
    else
        self.selected_bg.hidden = YES;
}

@end
