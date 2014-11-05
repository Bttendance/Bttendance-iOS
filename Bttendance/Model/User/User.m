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
- (BOOL)supervising:(NSInteger)courseID {
    for (SimpleCourse *course in self.supervising_courses)
        if (course.id == courseID)
            return YES;
    return NO;
}

- (BOOL)attending:(NSInteger)courseID {
    for (SimpleCourse *course in self.attending_courses)
        if (course.id == courseID)
            return YES;
    return NO;
}

- (BOOL)enrolled:(NSInteger)schoolID {
    for (SimpleSchool *school in self.enrolled_schools)
        if (school.id == schoolID)
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

- (SimpleCourse *)getCourse:(NSInteger)courseID {
    
    for (SimpleCourse *course in self.supervising_courses)
        if (course.id == courseID)
            return course;
    
    for (SimpleCourse *course in self.attending_courses)
        if (course.id == courseID)
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
