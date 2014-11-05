//
//  BTDatabase.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 11. 3..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;
@class School;
@class Course;
@class Post;
@class Clicker;
@class Attendance;
@class Notice;
@class Curious;
@class ClickerQuestion;
@class AttendanceAlarm;
@class SimpleUser;
@class AttendanceRecord;
@class ClickerRecord;
@class StudentRecord;

@interface BTDatabase : NSObject

@property(nonatomic, retain) User *user;

// (key : id,       value : object)
@property(nonatomic, retain) NSMutableDictionary *schools;
@property(nonatomic, retain) NSMutableDictionary *courses;

// (key : courseID, value : NSMutableDictionary)
@property(nonatomic, retain) NSMutableDictionary *postsOfCourse;
@property(nonatomic, retain) NSMutableDictionary *questionsOfCourse;
@property(nonatomic, retain) NSMutableDictionary *alarmsOfCourse;
@property(nonatomic, retain) NSMutableDictionary *studentsOfCourse;
@property(nonatomic, retain) NSMutableDictionary *attendanceRecordsOfCourse;
@property(nonatomic, retain) NSMutableDictionary *clickerRecordsOfCourse;

#pragma SharedInstance
+ (BTDatabase *)sharedInstance;

#pragma User Table
+ (User *)getUser;
+ (void)updateUser:(id)responseObject withData:(void (^)(User *user))data;

#pragma Schools Table (Sort : courses_count)
+ (void)getSchoolsWithData:(void (^)(NSArray *schools))data;
+ (void)updateSchool:(id)responseObject withData:(void (^)(School *school))data;
+ (void)updateSchools:(id)responseObject withData:(void (^)(NSArray *schools))data;

#pragma Courses Table (Sort : id)
+ (Course *)getCourseWithID:(NSInteger)courseID;
+ (void)getCoursesWithData:(void (^)(NSArray *courses))data;
+ (void)updateCourse:(id)responseObject withData:(void (^)(Course *course))data;
+ (void)updateCourses:(id)responseObject withData:(void (^)(NSArray *courses))data;

#pragma Posts Table (Sort : id)
+ (void)getPostsWithCourseID:(NSInteger)courseID
                    withType:(NSString *)type
                    withData:(void (^)(NSArray *posts))data;
+ (void)updatePosts:(id)responseObject
         ofCourseID:(NSInteger)courseID
           withType:(NSString *)type
           withData:(void (^)(NSArray *posts))data;

+ (void)updatePost:(id)responseObject withData:(void (^)(Post *post))data;
+ (void)deletePost:(id)responseObject withData:(void (^)(Post *post))data;

+ (void)updateClicker:(Clicker *)clicker;
+ (void)updateAttendance:(Attendance *)attendance;
+ (void)updateNotice:(Notice *)notice;
+ (void)updateCurious:(Curious *)curious;

#pragma Questions Table (Sort : id)
+ (void)getQuestionsWithCourseID:(NSInteger)courseID
                        withData:(void (^)(NSArray *questions))data;
+ (void)updateQuestions:(id)responseObject
             ofCourseID:(NSInteger)courseID
               withData:(void (^)(NSArray *questions))data;

+ (void)updateQuestion:(id)responseObject withData:(void (^)(ClickerQuestion *question))data;
+ (void)deleteQuestion:(id)responseObject withData:(void (^)(ClickerQuestion *question))data;

#pragma Alarms Table (Sort : id)
+ (void)getAlarmsWithCourseID:(NSInteger)courseID
                     withData:(void (^)(NSArray *alarms))data;
+ (void)updateAlarms:(id)responseObject
          ofCourseID:(NSInteger)courseID
            withData:(void (^)(NSArray *alarms))data;

+ (void)updateAlarm:(id)responseObject withData:(void (^)(AttendanceAlarm *alarm))data;
+ (void)deleteAlarm:(id)responseObject withData:(void (^)(AttendanceAlarm *alarm))data;

#pragma Students Table (Sort : full_name)
+ (void)getStudentsWithCourseID:(NSInteger)courseID
                       withData:(void (^)(NSArray *students))data;
+ (void)updateStudents:(id)responseObject
            ofCourseID:(NSInteger)courseID
              withData:(void (^)(NSArray *students))data;

#pragma Attendance Records Table (Sort : full_name)
+ (void)getAttendanceRecordsWithCourseID:(NSInteger)courseID
                                withData:(void (^)(NSArray *attendanceRecords))data;
+ (void)updateAttendanceRecords:(id)responseObject
                     ofCourseID:(NSInteger)courseID
                       withData:(void (^)(NSArray *attendanceRecords))data;

#pragma Clicker Records Table (Sort : full_name)
+ (void)getClickerRecordsWithCourseID:(NSInteger)courseID
                             withData:(void (^)(NSArray *clickerRecords))data;
+ (void)updateClickerRecords:(id)responseObject
                  ofCourseID:(NSInteger)courseID
                    withData:(void (^)(NSArray *clickerRecords))data;

@end
