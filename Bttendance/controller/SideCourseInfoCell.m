//
//  CourseInfoCell.m
//  Bttendance
//
//  Created by TheFinestArtist on 2013. 12. 27..
//  Copyright (c) 2013년 Bttendance. All rights reserved.
//

#import "SideCourseInfoCell.h"

@interface SideCourseInfoCell ()

@end

@implementation SideCourseInfoCell

+ (SideCourseInfoCell *)cellFromNibNamed:(NSString *)nibName {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    SideCourseInfoCell *cell = nil;
    NSObject *nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[SideCourseInfoCell class]]) {
            cell = (SideCourseInfoCell *) nibItem;
            break;
        }
    }
    return cell;
}

@end
