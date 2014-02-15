//
//  ProfCourseDetailHeaderView.m
//  Bttendance
//
//  Created by HAJE on 2014. 1. 24..
//  Copyright (c) 2014년 Utopia. All rights reserved.
//

#import "ProfCourseDetailHeaderView.h"

@interface ProfCourseDetailHeaderView ()

@end

@implementation ProfCourseDetailHeaderView

+(ProfCourseDetailHeaderView *)viewFromNibNamed:(NSString *)nibName{
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    ProfCourseDetailHeaderView *view = nil;
    NSObject* nibItem = nil;
    while((nibItem = [nibEnumerator nextObject]) != nil){
        if([nibItem isKindOfClass:[ProfCourseDetailHeaderView class]]){
            view = (ProfCourseDetailHeaderView *)nibItem;
            break;
        }
    }
    return view;
}


@end
