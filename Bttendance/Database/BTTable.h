//
//  BTTable.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 11. 3..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "School.h"
#import "Course.h"
#import "Post.h"
#import "Clicker.h"
#import "Attendance.h"
#import "Notice.h"
#import "Curious.h"
#import "ClickerQuestion.h"
#import "AttendanceAlarm.h"
#import "SimpleUser.h"
#import "AttendanceRecord.h"
#import "ClickerRecord.h"

@interface BTTable : NSObject

@property(nonatomic, retain) User *user;

// (key : id,       value : object)
@property(nonatomic, retain) NSMutableDictionary *schools;
@property(nonatomic, retain) NSMutableDictionary *courses;

// (key : courseID, value : NSDictionary)
@property(nonatomic, retain) NSMutableDictionary *postsOfCourse;
@property(nonatomic, retain) NSMutableDictionary *questionsOfCourse;
@property(nonatomic, retain) NSMutableDictionary *alarmsOfCourse;
@property(nonatomic, retain) NSMutableDictionary *studentsOfCourse;
@property(nonatomic, retain) NSMutableDictionary *attendanceRecordsOfCourse;
@property(nonatomic, retain) NSMutableDictionary *clickerRecordsOfCourse;

#pragma SharedInstance
+ (BTTable *)sharedInstance;

#pragma User Table
+ (void)getUserWithSuccess:(void (^)(User *user))success
                   failure:(void (^)(NSError *error))failure;
+ (void)updateUser:(User *)user;

#pragma Schools Table (Sort : courses_count)
+ (void)getSchoolsWithSuccess:(void (^)(NSArray *schools))success
                      failure:(void (^)(NSError *error))failure;
+ (void)updateSchools:(NSArray *)schools;
+ (void)updateSchool:(School *)school;

#pragma Courses Table (Sort : createdAt)
+ (void)getCoursesWithSuccess:(void (^)(NSArray *courses))success
                      failure:(void (^)(NSError *error))failure;
+ (void)updateCourses:(NSArray *)courses;

+ (void)getCourseWithID:(NSInteger)courseID
            withSuccess:(void (^)(Course *course))success
                failure:(void (^)(NSError *error))failure;
+ (void)updateCourse:(Course *)course;

#pragma Posts Table (Sort : createdAt)
+ (void)getPostsWithCourseID:(NSInteger)courseID
                    WithType:(NSString *)type
                 withSuccess:(void (^)(NSArray *posts))success
                     failure:(void (^)(NSError *error))failure;
+ (void)updatePosts:(NSArray *)posts ofCourseID:(NSInteger)courseID;
+ (void)deletePost:(Post *)post;
+ (void)updatePost:(Post *)post;

+ (void)updateClicker:(Clicker *)clicker;
+ (void)updateAttendance:(Attendance *)attendance;
+ (void)updateNotice:(Notice *)notice;
+ (void)updateCurious:(Curious *)curious;

#pragma Questions Table (Sort : createdAt)
+ (void)getQuestionsWithCourseID:(NSInteger)courseID
                     withSuccess:(void (^)(NSArray *questions))success
                         failure:(void (^)(NSError *error))failure;
+ (void)updateQuestions:(NSArray *)questions;

+ (void)updateQuestion:(ClickerQuestion *)question;
+ (void)deleteQuestion:(ClickerQuestion *)question;

#pragma Alarms Table (Sort : createdAt)
+ (void)getAlarmsWithCourseID:(NSInteger)courseID
                     withSuccess:(void (^)(NSArray *alarms))success
                         failure:(void (^)(NSError *error))failure;
+ (void)updateAlarms:(NSArray *)alarms;

+ (void)updateAlarm:(AttendanceAlarm *)alarm;
+ (void)deleteAlarm:(AttendanceAlarm *)alarm;

#pragma Students Table (Sort : full_name)
+ (void)getStudentsWithCourseID:(NSInteger)courseID
                    withSuccess:(void (^)(NSArray *students))success
                        failure:(void (^)(NSError *error))failure;
+ (void)updateStudents:(NSArray *)students;

#pragma Attendance Records Table (Sort : full_name)
+ (void)getAttendanceRecordsWithCourseID:(NSInteger)courseID
                             withSuccess:(void (^)(NSArray *attendanceRecords))success
                                 failure:(void (^)(NSError *error))failure;
+ (void)updateAttendanceRecords:(NSArray *)attendanceRecords;

#pragma Clicker Records Table (Sort : full_name)
+ (void)getClickerRecordsWithCourseID:(NSInteger)courseID
                          withSuccess:(void (^)(NSArray *clickerRecords))success
                              failure:(void (^)(NSError *error))failure;
+ (void)updateClickerRecords:(NSArray *)clickerRecords;

@end
