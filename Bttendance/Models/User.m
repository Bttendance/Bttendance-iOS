//
//  User.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "User.h"
#import "NSDate+Bttendance.h"
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

+ (NSDictionary *)toDictionary:(SimpleUser *)user {
    
    NSMutableArray *keys = [NSMutableArray array];
    [keys addObject:@"id"];
    if (user.email != nil)
            [keys addObject:@"email"];
    if (user.full_name != nil)
        [keys addObject:@"full_name"];
    if (user.grade != nil)
        [keys addObject:@"grade"];
    if (user.student_id != nil)
        [keys addObject:@"student_id"];
    
    NSMutableArray *objects = [NSMutableArray array];
    [objects addObject:[NSString stringWithFormat:@"%ld", (long)user.id]];
    if (user.email != nil)
        [objects addObject:user.email];
    if (user.full_name != nil)
        [objects addObject:user.full_name];
    if (user.grade != nil)
        [objects addObject:user.grade];
    if (user.student_id != nil)
        [objects addObject:user.student_id];
    
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    return dictionary;
}

@end



@implementation User

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    dictionary = [dictionary dictionaryByReplacingNullsWithStrings];
    self = [super init];
    
    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.createdAt = [NSDate dateFromString:[dictionary objectForKey:@"createdAt"]];
        self.updatedAt = [NSDate dateFromString:[dictionary objectForKey:@"updatedAt"]];
        self.email = [dictionary objectForKey:@"email"];
        self.password = [dictionary objectForKey:@"password"];
        self.locale = [dictionary objectForKey:@"locale"];
        self.full_name = [dictionary objectForKey:@"full_name"];
        self.device = [[SimpleDevice alloc] initWithDictionary:[dictionary objectForKey:@"device"]];
        self.setting = [[SimpleSetting alloc] initWithDictionary:[dictionary objectForKey:@"setting"]];
        
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
        
        self.questions_count = [[dictionary objectForKey:@"questions_count"] integerValue];
    }
    return self;
}

- (BOOL)supervising:(NSInteger)course_id {
    for (SimpleCourse *course in self.supervising_courses)
        if (course.id == course_id)
            return YES;
    return NO;
}

- (BOOL)attending:(NSInteger)course_id {
    for (SimpleCourse *course in self.attending_courses)
        if (course.id == course_id)
            return YES;
    return NO;
}

- (BOOL)enrolled:(NSInteger)school_id {
    for (SimpleSchool *school in self.enrolled_schools)
        if (school.id == school_id)
            return YES;
    return NO;
}

- (NSArray *)getAllSchools {
    return [self.employed_schools arrayByAddingObjectsFromArray:self.enrolled_schools];
}

- (BOOL)hasOpenedCourse {
    NSArray *courses = [self.supervising_courses arrayByAddingObjectsFromArray:self.attending_courses];
    BOOL hasOpenCourse = NO;
    for (id course in courses)
        if (((SimpleCourse *) course).opened)
            hasOpenCourse = YES;
    
    return hasOpenCourse;
}

- (SimpleCourse *)getCourse:(NSInteger)course_id {
    NSArray *courses = [self.supervising_courses arrayByAddingObjectsFromArray:self.attending_courses];
    for (SimpleCourse *course in courses)
        if (course.id == course_id)
            return course;
    
    return nil;
}

- (NSArray *)getOpenedCourses {
    NSArray *courses = [self.supervising_courses arrayByAddingObjectsFromArray:self.attending_courses];
    NSMutableArray *openedCourses = [[NSMutableArray alloc] init];;
    for (id course in courses)
        if (((SimpleCourse *) course).opened)
            [openedCourses addObject:course];
    
    return openedCourses;
}

- (NSArray *)getClosedCourses {
    NSArray *courses = [self.supervising_courses arrayByAddingObjectsFromArray:self.attending_courses];
    NSMutableArray *closedCourses = [[NSMutableArray alloc] init];;
    for (id course in courses)
        if (!((SimpleCourse *) course).opened)
            [closedCourses addObject:course];

    return closedCourses;
}

- (NSString *)getSchoolNameFromId:(NSInteger)schoolId {
    NSArray *schools = [self.employed_schools arrayByAddingObjectsFromArray:self.enrolled_schools];
    for (id school in schools)
        if (((SimpleSchool *) school).id == schoolId)
            return ((SimpleSchool *) school).name;
    
    return nil;
}

@end
