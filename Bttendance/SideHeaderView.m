//
//  SideHeaderView.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 7. 16..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "SideHeaderView.h"

@interface SideHeaderView ()

@end

@implementation SideHeaderView

+ (SideHeaderView *)viewFromNibNamed:(NSString *)nibName {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    SideHeaderView *view = nil;
    NSObject *nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[SideHeaderView class]]) {
            view = (SideHeaderView *) nibItem;
            break;
        }
    }
    return view;
}

@end
