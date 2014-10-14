//
//  Attendance.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "Attendance.h"
#import "NSDate+Bttendance.h"
#import "NSDictionary+Bttendance.h"

@implementation SimpleAttendance

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    dictionary = [dictionary dictionaryByReplacingNullsWithStrings];
    self = [super init];
    
    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.createdAt = [NSDate dateFromString:[dictionary objectForKey:@"createdAt"]];
        self.updatedAt = [NSDate dateFromString:[dictionary objectForKey:@"updatedAt"]];
        self.type = [dictionary objectForKey:@"type"];
        self.checked_students = [dictionary objectForKey:@"checked_students"];
        self.late_students = [dictionary objectForKey:@"late_students"];
        self.post = [[dictionary objectForKey:@"post"] integerValue];
    }
    return self;
}

+ (NSDictionary *)toDictionary:(SimpleAttendance *)attendance {
    
    NSMutableArray *keys = [NSMutableArray array];
    [keys addObject:@"id"];
    [keys addObject:@"createdAt"];
    [keys addObject:@"updatedAt"];
    if (attendance.type != nil)
        [keys addObject:@"type"];
    if (attendance.checked_students != nil)
        [keys addObject:@"checked_students"];
    if (attendance.late_students != nil)
        [keys addObject:@"late_students"];
    [keys addObject:@"post"];
    
    NSMutableArray *objects = [NSMutableArray array];
    [objects addObject:[NSString stringWithFormat:@"%ld", (long)attendance.id]];
    [objects addObject:[NSDate serializedStringFromDate:attendance.createdAt]];
    [objects addObject:[NSDate serializedStringFromDate:attendance.updatedAt]];
    if (attendance.type != nil)
        [objects addObject:attendance.type];
    if (attendance.checked_students != nil)
        [objects addObject:attendance.checked_students];
    if (attendance.late_students != nil)
        [objects addObject:attendance.late_students];
    [objects addObject:[NSString stringWithFormat:@"%ld", (long)attendance.post]];
    
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    return dictionary;
}

- (void)copyDataFromAttendance:(id)object {
    Attendance *attendance = (Attendance *)object;
    self.checked_students = attendance.checked_students;
    self.late_students = attendance.late_students;
}

- (NSInteger)stateInt:(NSInteger)userId {
    for (int i = 0; i < self.checked_students.count; i++)
        if([self.checked_students[i] integerValue] == userId)
            return 1;
    
    for (int i = 0; i < self.late_students.count; i++)
        if([self.late_students[i] integerValue] == userId)
            return 2;
    
    return 0;
}

- (void)toggleStatus:(NSInteger)userId {
    
    NSMutableArray *checked = [NSMutableArray array];
    NSMutableArray *lated = [NSMutableArray array];
    
    BOOL check = NO;
    BOOL late = NO;
    
    for (int i = 0; i < self.checked_students.count; i++) {
        if([self.checked_students[i] integerValue] == userId) {
            check = YES;
        } else {
            [checked addObject:self.checked_students[i]];
        }
    }
    
    for (int i = 0; i < self.late_students.count; i++) {
        if([self.late_students[i] integerValue] == userId) {
            late = YES;
        } else {
            [lated addObject:self.late_students[i]];
        }
    }
    
    if (check) {
        [lated addObject:[NSString stringWithFormat:@"%ld", (long)userId]];
    } else if (!late) {
        [checked addObject:[NSString stringWithFormat:@"%ld", (long)userId]];
    }
    
    self.checked_students = checked;
    self.late_students = lated;
}

@end


@implementation Attendance

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    dictionary = [dictionary dictionaryByReplacingNullsWithStrings];
    self = [super init];
    
    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.createdAt = [NSDate dateFromString:[dictionary objectForKey:@"createdAt"]];
        self.updatedAt = [NSDate dateFromString:[dictionary objectForKey:@"updatedAt"]];
        self.type = [dictionary objectForKey:@"type"];
        self.checked_students = [dictionary objectForKey:@"checked_students"];
        self.late_students = [dictionary objectForKey:@"late_students"];
        self.clusters = [dictionary objectForKey:@"clusters"];
        self.post = [[SimplePost alloc] initWithDictionary:[dictionary objectForKey:@"post"]];
    }
    return self;
}

@end
