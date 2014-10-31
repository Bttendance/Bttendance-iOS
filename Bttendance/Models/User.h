//
//  User.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "Device.h"
#import "Setting.h"

@class SimpleDevice;
@class SimpleCourse;
@class SimpleSetting;

@interface SimpleUser : NSObject

@property NSInteger         id;
@property NSString          *email;
@property NSString          *full_name;

//Added by APIs
@property NSString          *grade;
@property NSString          *student_id;

- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (NSDictionary *)toDictionary:(SimpleUser *)user;

@end


@interface User : NSObject

@property NSInteger         id;
@property NSDate            *createdAt;
@property NSDate            *updatedAt;
@property NSString          *email;
@property NSString          *password;
@property NSString          *locale;
@property NSString          *full_name;
@property SimpleDevice      *device;
@property SimpleSetting     *setting;
@property NSArray           *supervising_courses;
@property NSArray           *attending_courses;
@property NSArray           *employed_schools;
@property NSArray           *enrolled_schools;
@property NSArray           *identifications;
@property NSInteger         questions_count;

- (id)initWithDictionary:(NSDictionary *)dictionary;

- (BOOL)supervising:(NSInteger)course_id;

- (BOOL)attending:(NSInteger)course_id;

- (BOOL)enrolled:(NSInteger)school_id;

- (NSArray *)getAllSchools;

- (BOOL)hasOpenedCourse;

- (SimpleCourse *)getCourse:(NSInteger)course_id;

- (NSArray *)getOpenedCourses;

- (NSArray *)getClosedCourses;

- (NSString *)getSchoolNameFromId:(NSInteger)schoolId;

@end