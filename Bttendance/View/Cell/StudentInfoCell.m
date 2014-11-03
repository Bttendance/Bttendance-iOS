//
//  StudentInfoCell.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 8. 8..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "StudentInfoCell.h"

@implementation StudentInfoCell

+ (StudentInfoCell *)cellFromNibNamed {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"StudentInfoCell" owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    StudentInfoCell *cell = nil;
    NSObject *nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[StudentInfoCell class]]) {
            cell = (StudentInfoCell *) nibItem;
            break;
        }
    }
    return cell;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if (highlighted) {
        self.selected_bg.hidden = NO;
        self.background_bg.hidden = YES;
    } else {
        self.selected_bg.hidden = YES;
        self.background_bg.hidden = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (selected) {
        self.selected_bg.hidden = NO;
        self.background_bg.hidden = YES;
    } else {
        self.selected_bg.hidden = YES;
        self.background_bg.hidden = NO;
    }
}

@end
