//
//  ProfileCell.m
//  bttendance
//
//  Created by HAJE on 2014. 1. 22..
//  Copyright (c) 2014년 Utopia. All rights reserved.
//

#import "ProfileCell.h"

@interface ProfileCell ()

@end

@implementation ProfileCell

+ (ProfileCell *)cellFromNibNamed:(NSString *)nibName {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    ProfileCell *cell = nil;
    NSObject *nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[ProfileCell class]]) {
            cell = (ProfileCell *) nibItem;
            break;
        }
    }
    return cell;
}

@end
