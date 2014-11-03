//
//  SideHeaderView.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 7. 16..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "SideHeaderViewCell.h"
#import "UIColor+Bttendance.h"

@interface SideHeaderViewCell ()

@end

@implementation SideHeaderViewCell

+ (SideHeaderViewCell *)cellFromNibNamed {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"SideHeaderViewCell" owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    SideHeaderViewCell *view = nil;
    NSObject *nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[SideHeaderViewCell class]]) {
            view = (SideHeaderViewCell *) nibItem;
            break;
        }
    }
    
    return view;
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
