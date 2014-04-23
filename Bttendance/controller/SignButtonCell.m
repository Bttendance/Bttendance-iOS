//
//  SignButtonCell.m
//  bttendance
//
//  Created by HAJE on 2014. 1. 4..
//  Copyright (c) 2014년 Utopia. All rights reserved.
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
