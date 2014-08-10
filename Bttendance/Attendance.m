//
//  Attendance.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "Attendance.h"
#import "BTDateFormatter.h"
#import "NSDictionary+Bttendance.h"

@implementation SimpleAttendance

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    dictionary = [dictionary dictionaryByReplacingNullsWithStrings];
    self = [super init];

    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.type = [dictionary objectForKey:@"type"];
        self.checked_students = [dictionary objectForKey:@"checked_students"];
        self.late_students = [dictionary objectForKey:@"late_students"];
        self.post = [[dictionary objectForKey:@"post"] integerValue];
    }
    return self;
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

@end


@implementation Attendance

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    dictionary = [dictionary dictionaryByReplacingNullsWithStrings];
    self = [super init];

    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.createdAt = [BTDateFormatter dateFromString:[dictionary objectForKey:@"createdAt"]];
        self.updatedAt = [BTDateFormatter dateFromString:[dictionary objectForKey:@"updatedAt"]];
        self.type = [dictionary objectForKey:@"type"];
        self.checked_students = [dictionary objectForKey:@"checked_students"];
        self.late_students = [dictionary objectForKey:@"late_students"];
        self.clusters = [dictionary objectForKey:@"clusters"];
        self.post = [[SimplePost alloc] initWithDictionary:[dictionary objectForKey:@"post"]];
    }
    return self;
}

@end
