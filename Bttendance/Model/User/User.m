//
//  User.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "User.h"
#import "SimpleDevice.h"
#import "SimpleSetting.h"

@implementation User

#pragma Override RLMObject Method
+ (NSDictionary *)defaultPropertyValues {
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithDictionary:[super defaultPropertyValues]];
    [jsonDict addEntriesFromDictionary:@{@"email" : @"",
                                         @"password" : @"",
                                         @"full_name" : @"",
                                         @"locale" : @""}];
    return jsonDict;
}

#pragma Public Method
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
    NSMutableArray *schools = [NSMutableArray array];
    for (SimpleSchool* school in self.employed_schools)
        [schools addObject:school];
    for (SimpleSchool* school in self.enrolled_schools)
        [schools addObject:school];
    return schools;
}

- (BOOL)hasOpenedCourse {
    BOOL hasOpenCourse = NO;
    
    for (SimpleCourse* course in self.supervising_courses)
        if (course.opened)
            hasOpenCourse = YES;
    
    for (SimpleCourse* course in self.attending_courses)
        if (course.opened)
            hasOpenCourse = YES;
    
    return hasOpenCourse;
}

- (SimpleCourse *)getCourse:(NSInteger)course_id {
    
    for (SimpleCourse *course in self.supervising_courses)
        if (course.id == course_id)
            return course;
    
    for (SimpleCourse *course in self.attending_courses)
        if (course.id == course_id)
            return course;
    
    return nil;
}

- (NSArray *)getOpenedCourses {
    NSMutableArray *openedCourses = [NSMutableArray array];
    
    for (SimpleCourse* course in self.supervising_courses)
        if (course.opened)
            [openedCourses addObject:course];
    
    for (SimpleCourse* course in self.attending_courses)
        if (course.opened)
            [openedCourses addObject:course];
    
    return openedCourses;
}

- (NSArray *)getClosedCourses {
    NSMutableArray *closedCourses = [NSMutableArray array];
    
    for (SimpleCourse* course in self.supervising_courses)
        if (!course.opened)
            [closedCourses addObject:course];
    
    for (SimpleCourse* course in self.attending_courses)
        if (!course.opened)
            [closedCourses addObject:course];
    
    return closedCourses;
}

- (NSString *)getSchoolNameFromId:(NSInteger)schoolId {
    for (SimpleSchool* school in self.employed_schools)
        if (school.id == schoolId)
            return school.name;
    
    for (SimpleSchool* school in self.enrolled_schools)
        if (school.id == schoolId)
            return school.name;
    
    return nil;
}

@end
