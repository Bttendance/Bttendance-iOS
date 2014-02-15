//
//  ProfProfileHeaderView.m
//  bttendance
//
//  Created by HAJE on 2014. 1. 21..
//  Copyright (c) 2014년 Utopia. All rights reserved.
//

#import "ProfProfileHeaderView.h"

@interface ProfProfileHeaderView ()

@end

@implementation ProfProfileHeaderView

+(ProfProfileHeaderView *)viewFromNibNamed:(NSString *)nibName{
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    ProfProfileHeaderView *view = nil;
    NSObject* nibItem = nil;
    while((nibItem = [nibEnumerator nextObject]) != nil){
        if([nibItem isKindOfClass:[ProfProfileHeaderView class]]){
            view = (ProfProfileHeaderView *)nibItem;
            break;
        }
    }
    return view;
}

@end
