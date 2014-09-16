//
//  GradeCell.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 1. 28..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "GradeCell.h"

@interface GradeCell ()

@end

@implementation GradeCell

+ (GradeCell *)cellFromNibNamed:(NSString *)nibName {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    GradeCell *cell = nil;
    NSObject *nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[GradeCell class]]) {
            cell = (GradeCell *) nibItem;
            break;
        }
    }
    return cell;
}

@end
