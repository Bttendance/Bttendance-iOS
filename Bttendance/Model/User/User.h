//
//  User.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTObject.h"
#import "RLMArray.h"
#import "SimpleDevice.h"
#import "SimpleSetting.h"
#import "SimpleCourse.h"
#import "SimpleSchool.h"
#import "SimpleIdentification.h"

@interface User : BTObject

@property NSString                              *email;
@property NSString                              *password;
@property NSString                              *full_name;
@property NSString                              *locale;
@property SimpleDevice                          *device;
@property SimpleSetting                         *setting;
@property RLMArray<SimpleCourse>                *supervising_courses;
@property RLMArray<SimpleCourse>                *attending_courses;
@property RLMArray<SimpleSchool>                *employed_schools;
@property RLMArray<SimpleSchool>                *enrolled_schools;
@property RLMArray<SimpleIdentification>        *identifications;


- (BOOL)supervising:(NSInteger)courseID;

- (BOOL)attending:(NSInteger)courseID;

- (BOOL)enrolled:(NSInteger)schoolID;

- (NSArray *)getAllSchools;

- (BOOL)hasOpenedCourse;

- (SimpleCourse *)getCourse:(NSInteger)courseID;

- (NSArray *)getOpenedCourses;

- (NSArray *)getClosedCourses;

- (NSString *)getSchoolNameFromId:(NSInteger)schoolId;

@end