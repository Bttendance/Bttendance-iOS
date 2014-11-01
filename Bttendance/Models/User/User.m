//
//  User.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "User.h"
#import "DeviceSimple.h"
#import "SettingSimple.h"

@implementation User

- (BOOL)supervising:(NSInteger)course_id {
    for (CourseSimple *course in self.supervising_courses)
        if (course.id == course_id)
            return YES;
    return NO;
}

- (BOOL)attending:(NSInteger)course_id {
    for (CourseSimple *course in self.attending_courses)
        if (course.id == course_id)
            return YES;
    return NO;
}

- (BOOL)enrolled:(NSInteger)school_id {
    for (SchoolSimple *school in self.enrolled_schools)
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
