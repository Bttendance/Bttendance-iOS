//
//  SignButtonCell.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 1. 4..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "SignButtonCell.h"

@interface SignButtonCell ()

@end

@implementation SignButtonCell

+ (SignButtonCell *)cellFromNibNamed:(NSString *)nibName {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    SignButtonCell *cell = nil;
    NSObject *nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[SignButtonCell class]]) {
            cell = (SignButtonCell *) nibItem;
            break;
        }
    }
    return cell;
}
@end
