//
//  StdProfileHeaderView.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 1. 21..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "ProfileHeaderView.h"

@interface ProfileHeaderView ()

@end

@implementation ProfileHeaderView

+ (ProfileHeaderView *)viewFromNibNamed:(NSString *)nibName {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    ProfileHeaderView *view = nil;
    NSObject *nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[ProfileHeaderView class]]) {
            view = (ProfileHeaderView *) nibItem;
            break;
        }
    }
    return view;
}

@end
