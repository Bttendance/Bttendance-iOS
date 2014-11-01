//
//  Clicker.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "Clicker.h"
#import "NSData+Bttendance.h"

@implementation Clicker

- (instancetype)initWithObject:(id)object {
    [object setObject:[NSData dataFromArray:[object objectForKey:@"a_students"]] forKey:@"a_students"];
    [object setObject:[NSData dataFromArray:[object objectForKey:@"b_students"]] forKey:@"b_students"];
    [object setObject:[NSData dataFromArray:[object objectForKey:@"c_students"]] forKey:@"c_students"];
    [object setObject:[NSData dataFromArray:[object objectForKey:@"d_students"]] forKey:@"d_students"];
    [object setObject:[NSData dataFromArray:[object objectForKey:@"e_students"]] forKey:@"e_students"];
    return [super initWithObject:object];
}

@end
