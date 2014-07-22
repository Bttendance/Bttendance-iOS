//
//  User.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "User.h"
#import "BTDateFormatter.h"
#import "Course.h"
#import "School.h"
#import "Identification.h"
#import "NSDictionary+Bttendance.h"

@implementation SimpleUser

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    dictionary = [dictionary dictionaryByReplacingNullsWithStrings];
    self = [super init];
    
    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.email = [dictionary objectForKey:@"email"];
        self.full_name = [dictionary objectForKey:@"full_name"];
        
        //Added by APIs
        self.grade = [dictionary objectForKey:@"grade"];
        self.student_id = [dictionary objectForKey:@"student_id"];
    }
    return self;
}

@end



@implementation User

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    dictionary = [dictionary dictionaryByReplacingNullsWithStrings];
    self = [super init];
    
    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.createdAt = [BTDateFormatter dateFromString:[dictionary objectForKey:@"createdAt"]];
        self.updatedAt = [BTDateFormatter dateFromString:[dictionary objectForKey:@"updatedAt"]];
        self.email = [dictionary objectForKey:@"email"];
        self.password = [dictionary objectForKey:@"password"];
        self.full_name = [dictionary objectForKey:@"full_name"];
        self.device = [[SimpleDevice alloc] initWithDictionary:[dictionary objectForKey:@"device"]];
        self.notification = [[SimpleNotification alloc] initWithDictionary:[dictionary objectForKey:@"notification"]];
        
        NSMutableArray *supervising_courses = [NSMutableArray array];
        for (NSDictionary *dic in [dictionary objectForKey:@"supervising_courses"]) {
            SimpleCourse *course = [[SimpleCourse alloc] initWithDictionary:dic];
            [supervising_courses addObject:course];
        }
        
        self.supervising_courses = [supervising_courses sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSInteger first = ((SimpleCourse *)a).id;
            NSInteger second = ((SimpleCourse *)b).id;
            if (first > second)
                return (NSComparisonResult)NSOrderedDescending;
            else
                return (NSComparisonResult)NSOrderedAscending;
        }];
        
        NSMutableArray *attending_courses = [NSMutableArray array];
        for (NSDictionary *dic in [dictionary objectForKey:@"attending_courses"]) {
            SimpleCourse *course = [[SimpleCourse alloc] initWithDictionary:dic];
            [attending_courses addObject:course];
        }
        
        self.attending_courses = [attending_courses sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSInteger first = ((SimpleCourse *)a).id;
            NSInteger second = ((SimpleCourse *)b).id;
            if (first > second)
                return (NSComparisonResult)NSOrderedDescending;
            else
                return (NSComparisonResult)NSOrderedAscending;
        }];
        
        NSMutableArray *employed_schools = [NSMutableArray array];
        for (NSDictionary *dic in [dictionary objectForKey:@"employed_schools"]) {
            SimpleSchool *school = [[SimpleSchool alloc] initWithDictionary:dic];
            [employed_schools addObject:school];
        }
        self.employed_schools = employed_schools;
        
        NSMutableArray *enrolled_schools = [NSMutableArray array];
        for (NSDictionary *dic in [dictionary objectForKey:@"enrolled_schools"]) {
            SimpleSchool *school = [[SimpleSchool alloc] initWithDictionary:dic];
            [enrolled_schools addObject:school];
        }
        self.enrolled_schools = enrolled_schools;
        
        NSMutableArray *identifications = [NSMutableArray array];
        for (NSDictionary *dic in [dictionary objectForKey:@"identifications"]) {
            SimpleIdentification *identification = [[SimpleIdentification alloc] initWithDictionary:dic];
            [identifications addObject:identification];
        }
        self.identifications = identifications;
    }
    return self;
}

@end
