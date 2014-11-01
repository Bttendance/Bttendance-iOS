//
//  AttendanceSimple.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 11. 1..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "AttendanceSimple.h"

@implementation AttendanceSimple

- (instancetype)initWithObject:(id)object {
    [object setObject:[NSKeyedArchiver archivedDataWithRootObject:[object objectForKey:@"checked_students"]] forKey:@"checked_students"];
    [object setObject:[NSKeyedArchiver archivedDataWithRootObject:[object objectForKey:@"late_students"]] forKey:@"late_students"];
    return [super initWithObject:object];
}

- (void)copyDataFromAttendance:(id)object {
//    Attendance *attendance = (Attendance *)object;
//    self.checked_students = attendance.checked_students;
//    self.late_students = attendance.late_students;
}

- (NSInteger)stateInt:(NSInteger)userId {
    //    for (int i = 0; i < self.checked_students.count; i++)
    //        if([self.checked_students[i] integerValue] == userId)
    //            return 1;
    //
    //    for (int i = 0; i < self.late_students.count; i++)
    //        if([self.late_students[i] integerValue] == userId)
    //            return 2;
    
    return 0;
}

- (void)toggleStatus:(NSInteger)userId {
    
//    NSMutableArray *checked = [NSMutableArray array];
//    NSMutableArray *lated = [NSMutableArray array];
//    
//    BOOL check = NO;
//    BOOL late = NO;
//    
//    for (int i = 0; i < self.checked_students.count; i++) {
//        if([self.checked_students[i] integerValue] == userId) {
//            check = YES;
//        } else {
//            [checked addObject:self.checked_students[i]];
//        }
//    }
//    
//    for (int i = 0; i < self.late_students.count; i++) {
//        if([self.late_students[i] integerValue] == userId) {
//            late = YES;
//        } else {
//            [lated addObject:self.late_students[i]];
//        }
//    }
//    
//    if (check) {
//        [lated addObject:[NSString stringWithFormat:@"%ld", (long)userId]];
//    } else if (!late) {
//        [checked addObject:[NSString stringWithFormat:@"%ld", (long)userId]];
//    }
//    
//    self.checked_students = [NSKeyedArchiver archivedDataWithRootObject:checked];
//    self.late_students = [NSKeyedArchiver archivedDataWithRootObject:lated];
}

@end
