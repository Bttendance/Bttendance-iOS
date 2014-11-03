//
//  CourseCell.m
//  Bttendance
//
//  Created by TheFinestArtist on 2013. 12. 6..
//  Copyright (c) 2013년 Bttendance. All rights reserved.
//

#import "CourseCell.h"

@interface CourseCell ()
@end

@implementation CourseCell


+ (CourseCell *)cellFromNibNamed:(NSString *)nibName {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    CourseCell *cell = nil;
    NSObject *nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[CourseCell class]]) {
            cell = (CourseCell *) nibItem;
            break;
        }
    }
    return cell;
}


@end
