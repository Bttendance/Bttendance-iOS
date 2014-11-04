//
//  BTDatabase.h
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
#import "StudentRecord.h"

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
+ (void)getUserWithData:(void (^)(User *user))data;
+ (void)updateUser:(User *)user;

#pragma Schools Table (Sort : courses_count)
+ (void)getSchoolsWithData:(void (^)(NSArray *schools))data;
+ (void)updateSchools:(NSArray *)schools;
+ (void)updateSchool:(School *)school;

#pragma Courses Table (Sort : id)
+ (void)getCoursesWithData:(void (^)(NSArray *courses))data;
+ (void)updateCourses:(NSArray *)courses;

+ (void)getCourseWithID:(NSInteger)courseID
               withData:(void (^)(Course *course))data;
+ (void)updateCourse:(Course *)course;

#pragma Posts Table (Sort : id)
+ (void)getPostsWithCourseID:(NSInteger)courseID
                    WithType:(NSString *)type
                    withData:(void (^)(NSArray *posts))data;
+ (void)updatePosts:(NSArray *)posts ofCourseID:(NSInteger)courseID;
+ (void)updatePost:(Post *)post;
+ (void)deletePost:(Post *)post;

+ (void)updateClicker:(Clicker *)clicker;
+ (void)updateAttendance:(Attendance *)attendance;
+ (void)updateNotice:(Notice *)notice;
+ (void)updateCurious:(Curious *)curious;

#pragma Questions Table (Sort : id)
+ (void)getQuestionsWithCourseID:(NSInteger)courseID
                        withData:(void (^)(NSArray *questions))data;
+ (void)updateQuestions:(NSArray *)questions ofCourseID:(NSInteger)courseID;

+ (void)updateQuestion:(ClickerQuestion *)question;
+ (void)deleteQuestion:(ClickerQuestion *)question;

#pragma Alarms Table (Sort : id)
+ (void)getAlarmsWithCourseID:(NSInteger)courseID
                     withData:(void (^)(NSArray *alarms))data;
+ (void)updateAlarms:(NSArray *)alarms ofCourseID:(NSInteger)courseID;

+ (void)updateAlarm:(AttendanceAlarm *)alarm;
+ (void)deleteAlarm:(AttendanceAlarm *)alarm;

#pragma Students Table (Sort : full_name)
+ (void)getStudentsWithCourseID:(NSInteger)courseID
                       withData:(void (^)(NSArray *students))data;
+ (void)updateStudents:(NSArray *)students ofCourseID:(NSInteger)courseID;

#pragma Attendance Records Table (Sort : full_name)
+ (void)getAttendanceRecordsWithCourseID:(NSInteger)courseID
                                withData:(void (^)(NSArray *attendanceRecords))data;
+ (void)updateAttendanceRecords:(NSArray *)attendanceRecords ofCourseID:(NSInteger)courseID;

#pragma Clicker Records Table (Sort : full_name)
+ (void)getClickerRecordsWithCourseID:(NSInteger)courseID
                             withData:(void (^)(NSArray *clickerRecords))data;
+ (void)updateClickerRecords:(NSArray *)clickerRecords ofCourseID:(NSInteger)courseID;

@end
