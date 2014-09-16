//
//  School.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "School.h"
#import "NSDate+Bttendance.h"
#import "Course.h"
#import "User.h"
#import "NSDictionary+Bttendance.h"

@implementation SimpleSchool

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    dictionary = [dictionary dictionaryByReplacingNullsWithStrings];
    self = [super init];

    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.name = [dictionary objectForKey:@"name"];
        self.type = [dictionary objectForKey:@"type"];
    }
    return self;
}

@end

@implementation School

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    dictionary = [dictionary dictionaryByReplacingNullsWithStrings];
    self = [super init];

    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.createdAt = [NSDate dateFromString:[dictionary objectForKey:@"createdAt"]];
        self.updatedAt = [NSDate dateFromString:[dictionary objectForKey:@"updatedAt"]];
        self.name = [dictionary objectForKey:@"name"];
        self.type = [dictionary objectForKey:@"type"];
        self.courses_count = [[dictionary objectForKey:@"courses_count"] integerValue];
        self.professors_count = [[dictionary objectForKey:@"professors_count"] integerValue];
        self.students_count = [[dictionary objectForKey:@"students_count"] integerValue];
    }
    return self;
}

@end
