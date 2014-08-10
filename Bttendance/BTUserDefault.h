//
//  BTUserDefault.h
//  Bttendance
//
//  Created by TheFinestArtist on 2013. 11. 9..
//  Copyright (c) 2013년 Bttendance. All rights reserved.
//
#import "User.h"
#import "Course.h"

#define UserJSONKey @"btd_user_json"
#define CoursesJSONKey @"btd_courses_json"
#define PostJSONArrayOfCourseKey @"btd_post_json_array_of_course"
#define StudentJSONArrayOfCourseKey @"btd_student_json_array_of_course"
#define SchoolsJSONKey @"btd_schools_json"
#define QuestionsJSONKey @"btd_questions_json"
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

+ (NSArray *)getCourses;

+ (Course *)getCourse:(NSInteger)courseId;

+ (void)setCourses:(id)responseObject;

+ (NSArray *)getPostsOfArray:(NSString *)courseId;

+ (void)setPostsArray:(id)responseObject ofCourse:(NSString *)courseId;

+ (NSArray *)getSchools;

+ (void)setSchools:(id)responseObject;

+ (NSArray *)getStudentsOfArray:(NSString *)courseId;

+ (void)setStudentsArray:(id)responseObject ofCourse:(NSString *)courseId;

+ (NSArray *)getQuestions;

+ (void)setQuestions:(id)responseObject;

+ (BOOL)getSeenGuide;

+ (NSInteger)getLastSeenCourse;

+ (void)setLastSeenCourse:(NSInteger)lastCourse;

+ (void)clear;

@end
