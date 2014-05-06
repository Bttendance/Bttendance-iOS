//
//  ClickerCell.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 5. 2..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "ClickerCell.h"

@interface ClickerCell ()

@end

@implementation ClickerCell

+ (ClickerCell *)cellFromNimNamed:(NSString *)nibName {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    ClickerCell *cell = nil;
    NSObject *nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[ClickerCell class]]) {
            cell = (ClickerCell *) nibItem;
            break;
        }
    }
    return cell;
}

@end
