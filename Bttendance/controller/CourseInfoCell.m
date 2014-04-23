//
//  CourseInfoCell.m
//  Bttendance
//
//  Created by HAJE on 2013. 12. 27..
//  Copyright (c) 2013년 Utopia. All rights reserved.
//

#import "CourseInfoCell.h"

@interface CourseInfoCell ()

@end

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
