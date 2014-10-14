//
//  QuestionCell.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 8. 1..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "QuestionCell.h"
#import "UIColor+Bttendance.h"

@implementation QuestionCell

+ (QuestionCell *)cellFromNibNamed {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"QuestionCell" owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    QuestionCell *cell = nil;
    NSObject *nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[QuestionCell class]]) {
            cell = (QuestionCell *) nibItem;
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
