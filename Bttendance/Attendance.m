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
