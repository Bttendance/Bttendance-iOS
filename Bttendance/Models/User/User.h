//
//  User.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTObject.h"
#import "RLMArray.h"

#import "CourseSimple.h"
#import "SchoolSimple.h"
#import "IdentificationSimple.h"

@class DeviceSimple;
@class SettingSimple;

@interface User : BTObject

@property NSString                              *email;
@property NSString                              *password;
@property NSString                              *locale;
@property NSString                              *full_name;
@property DeviceSimple                          *device;
@property SettingSimple                         *setting;
@property RLMArray<CourseSimple>                *supervising_courses;
@property RLMArray<CourseSimple>                *attending_courses;
@property RLMArray<SchoolSimple>                *employed_schools;
@property RLMArray<SchoolSimple>                *enrolled_schools;
@property RLMArray<IdentificationSimple>        *identifications;
@property NSInteger         questions_count;

- (id)initWithDictionary:(NSDictionary *)dictionary;

- (BOOL)supervising:(NSInteger)course_id;

- (BOOL)attending:(NSInteger)course_id;

- (BOOL)enrolled:(NSInteger)school_id;

- (NSArray *)getAllSchools;

- (BOOL)hasOpenedCourse;

- (CourseSimple *)getCourse:(NSInteger)course_id;

- (NSArray *)getOpenedCourses;

- (NSArray *)getClosedCourses;

- (NSString *)getSchoolNameFromId:(NSInteger)schoolId;

@end