//
//  SideHeaderView.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 7. 16..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "SideHeaderView.h"
#import "BTColor.h"

@interface SideHeaderView ()

@end

@implementation SideHeaderView

+ (SideHeaderView *)viewFromNibNamed {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"SideHeaderView" owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    SideHeaderView *view = nil;
    NSObject *nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[SideHeaderView class]]) {
            view = (SideHeaderView *) nibItem;
            break;
        }
    }
    
    [view.headerBT setBackgroundImage:[BTColor imageWithCyanColor:0.0] forState:UIControlStateNormal];
    [view.headerBT setBackgroundImage:[BTColor imageWithCyanColor:0.5] forState:UIControlStateHighlighted];
    
    return view;
}

@end
