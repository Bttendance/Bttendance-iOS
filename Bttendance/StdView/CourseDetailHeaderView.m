//
//  StdCourseDetailHeaderView.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 1. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "CourseDetailHeaderView.h"

@interface CourseDetailHeaderView ()

@end

@implementation CourseDetailHeaderView

+ (CourseDetailHeaderView *)viewFromNibNamed:(NSString *)nibName {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    CourseDetailHeaderView *view = nil;
    NSObject *nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[CourseDetailHeaderView class]]) {
            view = (CourseDetailHeaderView *) nibItem;
            break;
        }
    }
    return view;
}

@end
