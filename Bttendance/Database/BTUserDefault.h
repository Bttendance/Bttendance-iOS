//
//  BTUserDefault.h
//  Bttendance
//
//  Created by TheFinestArtist on 2013. 11. 9..
//  Copyright (c) 2013년 Bttendance. All rights reserved.
//
#import "User.h"
#import "Course.h"
#import "Attendance.h"
#import "Clicker.h"
#import "Notice.h"
#import "Post.h"

#define MigratedKey @"btd_migrated"

#define UserJSONKey @"btd_user_json"
#define EmailKey @"btd_email"
#define PasswordKey @"btd_password"
#define UUIDKey @"btd_uuid"
#define SeenGuideKey @"btd_seen_guide"
#define LastSeenCourseKey @"btd_last_seen_course"

@interface BTUserDefault : NSObject

+ (void)migrate;

// User
+ (NSString *)getEmail;
+ (NSString *)getPassword;
+ (NSString *)getUUID;
+ (void)setUser:(User *)user;

// Guide
+ (BOOL)getSeenGuide;

// Last Course
+ (NSInteger)getLastSeenCourse;
+ (void)setLastSeenCourse:(NSInteger)lastCourse;

// Sign Out
+ (void)clear;

@end
