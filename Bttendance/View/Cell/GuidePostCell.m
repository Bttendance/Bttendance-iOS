//
//  GuidePostCell.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 8. 10..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "GuidePostCell.h"

@implementation GuidePostCell

+ (GuidePostCell *)cellFromNibNamed:(NSString *)nibName {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    GuidePostCell *cell = nil;
    NSObject *nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[GuidePostCell class]]) {
            cell = (GuidePostCell *) nibItem;
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
