//
//  PostCell.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 1. 1..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "PostCell.h"

@interface PostCell ()
@end

@implementation PostCell

+ (PostCell *)cellFromNibNamed:(NSString *)nibName {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    PostCell *cell = nil;
    NSObject *nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[PostCell class]]) {
            cell = (PostCell *) nibItem;
            break;
        }
    }
    return cell;
}

@end