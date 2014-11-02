//
//  SimpleAttendance.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 11. 1..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "SimpleAttendance.h"
#import "Attendance.h"
#import "NSData+Bttendance.h"
#import "NSArray+Bttendance.h"

@implementation SimpleAttendance

- (instancetype)initWithObject:(id)object {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionaryWithDictionary:object];
    [dictionary setObject:[NSData dataFromArray:[object objectForKey:@"checked_students"]] forKey:@"checked_students"];
    [dictionary setObject:[NSData dataFromArray:[object objectForKey:@"late_students"]] forKey:@"late_students"];
    return [super initWithObject:dictionary];
}

- (void)copyDataFromAttendance:(id)object {
    Attendance *attendance = (Attendance *)object;
    self.checked_students = attendance.checked_students;
    self.late_students = attendance.late_students;
}

- (NSInteger)stateInt:(NSInteger)userId {
    for (int i = 0; i < [self checkedStudentsCount]; i++)
        if([[self checkedStudents][i] integerValue] == userId)
            return 1;

    for (int i = 0; i < [self lateStudentsCount]; i++)
        if([[self lateStudents][i] integerValue] == userId)
            return 2;
    
    return 0;
}

- (void)toggleStatus:(NSInteger)userId {
    
    NSMutableArray *checked = [NSMutableArray array];
    NSMutableArray *lated = [NSMutableArray array];
    
    BOOL check = NO;
    BOOL late = NO;
    
    for (int i = 0; i < [self checkedStudentsCount]; i++) {
        if([[self checkedStudents][i] integerValue] == userId) {
            check = YES;
        } else {
            [checked addObject:[self checkedStudents][i]];
        }
    }
    
    for (int i = 0; i < [self lateStudentsCount]; i++) {
        if([[self lateStudents][i] integerValue] == userId) {
            late = YES;
        } else {
            [lated addObject:[self lateStudents][i]];
        }
    }
    
    if (check) {
        [lated addObject:[NSString stringWithFormat:@"%ld", (long)userId]];
    } else if (!late) {
        [checked addObject:[NSString stringWithFormat:@"%ld", (long)userId]];
    }
    
    self.checked_students = [NSKeyedArchiver archivedDataWithRootObject:checked];
    self.late_students = [NSKeyedArchiver archivedDataWithRootObject:lated];
}

#pragma NSArray Converting
- (NSArray *)checkedStudents {
    return [NSArray arrayFromData:self.checked_students];
}

- (NSArray *)lateStudents {
    return [NSArray arrayFromData:self.late_students];
}

- (NSInteger)checkedStudentsCount {
    NSArray *students = [self checkedStudents];
    if (students == nil)
        return 0;
    
    return students.count;
}

- (NSInteger)lateStudentsCount {
    NSArray *students = [self lateStudents];
    if (students == nil)
        return 0;
    
    return students.count;
}

- (NSInteger)totalStudentsCount {
    return [self checkedStudentsCount] + [self lateStudentsCount];
}

@end
