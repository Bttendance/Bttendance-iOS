//
//  BTUserDefault.h
//  Bttendance
//
//  Created by TheFinestArtist on 2013. 11. 9..
//  Copyright (c) 2013년 Bttendance. All rights reserved.
//
#import "User.h"

#define UserJSONKey @"btd_user_json"
#define SeenGuideKey @"btd_seen_guide"
#define LastSeenCourseKey @"btd_last_seen_course"

@interface BTUserDefault : NSObject {

}

+ (NSString *)getEmail;

+ (NSString *)getFullName;

+ (NSString *)getPassword;

+ (NSString *)getUUID;

+ (User *)getUser;

+ (void)setUser:(id)responseObject;

+ (BOOL)getSeenGuide;

+ (NSInteger)getLastSeenCourse;

+ (void)setLastSeenCourse:(NSInteger)lastCourse;

+ (void)clear;

@end
