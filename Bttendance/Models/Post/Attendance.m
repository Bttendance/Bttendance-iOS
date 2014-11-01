//
//  Attendance.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "Attendance.h"
#import "NSData+Bttendance.h"

@implementation Attendance

- (instancetype)initWithObject:(id)object {
    [object setObject:[NSData dataFromArray:[object objectForKey:@"checked_students"]] forKey:@"checked_students"];
    [object setObject:[NSData dataFromArray:[object objectForKey:@"late_students"]] forKey:@"late_students"];
    [object setObject:[NSData dataFromArray:[object objectForKey:@"clusters"]] forKey:@"clusters"];
    return [self initWithObject:object];
}

@end
