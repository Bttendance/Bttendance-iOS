//
//  CourseInfoCell.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 7. 16..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "CourseInfoCell.h"

@implementation CourseInfoCell

+ (CourseInfoCell *)cellFromNibNamed:(NSString *)nibName {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    CourseInfoCell *cell = nil;
    NSObject *nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[CourseInfoCell class]]) {
            cell = (CourseInfoCell *) nibItem;
            break;
        }
    }
    return cell;
}

@end
