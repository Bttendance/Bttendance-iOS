//
//  BTAPIs.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 2. 11..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "School.h"
#import "Course.h"
#import "Post.h"
#import "Attendance.h"
#import "Clicker.h"
#import "Notice.h"
#import "Email.h"
#import "Question.h"

#ifdef DEBUG
    #define BTURL @"http://bttendance-dev.herokuapp.com/api"
    #define BTSOCKET @"bttendance-dev.herokuapp.com"
#else
    #define BTURL @"http://www.bttd.co/api"
    #define BTSOCKET @"www.bttd.co"
#endif

@interface BTAPIs : NSObject <UIAlertViewDelegate>

#pragma Users APIs
+ (void)signUpWithFullName:(NSString *)full_name
                     email:(NSString *)email
                  password:(NSString *)password
                   success:(void (^)(User *user))success
                   failure:(void (^)(NSError *error))failure;

+ (void)autoSignInInSuccess:(void (^)(User *user))success
                    failure:(void (^)(NSError *error))failure;

+ (void)signInWithEmail:(NSString *)email
               password:(NSString *)password
                success:(void (^)(User *user))success
                failure:(void (^)(NSError *error))failure;

+ (void)forgotPasswordWithEmail:(NSString *)email
                        success:(void (^)(Email *email))success
                        failure:(void (^)(NSError *error))failure;

+ (void)updatePasswordWithOldOne:(NSString *)password_old
                          newOne:(NSString *)password_new
                         success:(void (^)(User *user))success
                         failure:(void (^)(NSError *error))failure;

+ (void)updateFullName:(NSString *)full_name
               success:(void (^)(User *user))success
               failure:(void (^)(NSError *error))failure;

+ (void)updateEmail:(NSString *)email_new
            success:(void (^)(User *user))success
            failure:(void (^)(NSError *error))failure;

+ (void)searchUser:(NSString *)search_id
           success:(void (^)(User *user))success
           failure:(void (^)(NSError *error))failure;

+ (void)coursesInSuccess:(void (^)(NSArray *courses))success
                 failure:(void (^)(NSError *error))failure;

#pragma Devices APIs
+ (void)updateNotificationKey:(NSString *)notification_key
                      success:(void (^)(User *user))success
                      failure:(void (^)(NSError *error))failure;

#pragma Settings APIs
+ (void)updateNotiSettingAttendance:(BOOL)attendance
                            success:(void (^)(User *user))success
                            failure:(void (^)(NSError *error))failure;

+ (void)updateNotiSettingClicker:(BOOL)clicker
                         success:(void (^)(User *user))success
                         failure:(void (^)(NSError *error))failure;

+ (void)updateNotiSettingNotice:(BOOL)notice
                        success:(void (^)(User *user))success
                        failure:(void (^)(NSError *error))failure;

#pragma Questions APIs
+ (void)myQuestionsInSuccess:(void (^)(NSArray *questions))success
                     failure:(void (^)(NSError *error))failure;

+ (void)createQuestionWithMessage:(NSString *)message
                   andChoiceCount:(NSString *)choice_count
                          success:(void (^)(Question *question))success
                          failure:(void (^)(NSError *error))failure;

+ (void)updateQuestion:(NSString *)question_id
           WithMessage:(NSString *)message
        andChoiceCount:(NSString *)choice_count
               success:(void (^)(Question *question))success
               failure:(void (^)(NSError *error))failure;

+ (void)removeQuestionWithId:(NSString *)question_id
                     success:(void (^)(Question *question))success
                     failure:(void (^)(NSError *error))failure;

#pragma Identifications APIs
+ (void)updateIdentityWithSchool:(NSString *)school_id
                        identity:(NSString *)identity
                         success:(void (^)(User *user))success
                         failure:(void (^)(NSError *error))failure;

#pragma Schools APIs
+ (void)createSchoolWithName:(NSString *)name
                        type:(NSString *)type
                     success:(void (^)(School *school))success
                     failure:(void (^)(NSError *error))failure;

+ (void)allSchoolsAtSuccess:(void (^)(NSArray *schools))success
                    failure:(void (^)(NSError *error))failure;

+ (void)enrollSchool:(NSString *)school_id
            identity:(NSString *)identity
             success:(void (^)(User *user))success
             failure:(void (^)(NSError *error))failure;

#pragma Courses APIs
+ (void)createCourseInstantWithName:(NSString *)name
                             school:(NSString *)school_id
                      professorName:(NSString *)professor_name
                            success:(void (^)(User *user))success
                            failure:(void (^)(NSError *error))failure;

+ (void)searchCourseWithCode:(NSString *)course_code
                        orId:(NSString *)course_id
                     success:(void (^)(Course *course))success
                     failure:(void (^)(NSError *error))failure;

+ (void)attendCourse:(NSString *)course_id
             success:(void (^)(User *user))success
             failure:(void (^)(NSError *error))failure;

+ (void)dettendCourse:(NSString *)course_id
              success:(void (^)(User *user))success
              failure:(void (^)(NSError *error))failure;

+ (void)feedForCourse:(NSString *)course_id
                 page:(NSInteger)page
              success:(void (^)(NSArray *posts))success
              failure:(void (^)(NSError *error))failure;

+ (void)openCourse:(NSString *)course_id
           success:(void (^)(User *user))success
           failure:(void (^)(NSError *error))failure;

+ (void)closeCourse:(NSString *)course_id
            success:(void (^)(User *user))success
            failure:(void (^)(NSError *error))failure;

+ (void)addManagerWithCourse:(NSString *)course_id
                     manager:(NSString *)manager
                     success:(void (^)(Course *course))success
                     failure:(void (^)(NSError *error))failure;

+ (void)studentsForCourse:(NSString *)course_id
                  success:(void (^)(NSArray *simpleUsers))success
                  failure:(void (^)(NSError *error))failure;

+ (void)attendanceGradesWithCourse:(NSString *)course_id
                           success:(void (^)(NSArray *simpleUsers))success
                           failure:(void (^)(NSError *error))failure;

+ (void)clickerGradesWithCourse:(NSString *)course_id
                        success:(void (^)(NSArray *simpleUsers))success
                        failure:(void (^)(NSError *error))failure;

+ (void)exportGradesWithCourse:(NSString *)course_id
                       success:(void (^)(Email *email))success
                       failure:(void (^)(NSError *error))failure;

#pragma Posts APIs
+ (void)startAttendanceWithCourse:(NSString *)course_id
                          success:(void (^)(Post *post))success
                          failure:(void (^)(NSError *error))failure;

+ (void)startClickerWithCourse:(NSString *)course_id
                       message:(NSString *)message
                   choiceCount:(NSString *)choice_count
                       success:(void (^)(Post *post))success
                       failure:(void (^)(NSError *error))failure;

+ (void)createNoticeWithCourse:(NSString *)course_id
                       message:(NSString *)message
                       success:(void (^)(Post *post))success
                       failure:(void (^)(NSError *error))failure;

+ (void)updateMessageOfPost:(NSString *)post_id
                withMessage:(NSString *)message
                    success:(void (^)(Post *post))success
                    failure:(void (^)(NSError *error))failure;

+ (void)removePost:(NSString *)post_id
           success:(void (^)(Post *post))success
           failure:(void (^)(NSError *error))failure;

#pragma Attendances APIs
+ (void)fromCoursesWithCourses:(NSArray *)course_ids
                       success:(void (^)(NSArray *attendanceIDs))success
                       failure:(void (^)(NSError *error))failure;

+ (void)foundDeviceWithAttendance:(NSString *)attendance_id
                             uuid:(NSString *)uuid
                          success:(void (^)(Attendance *attendance))success
                          failure:(void (^)(NSError *error))failure;

+ (void)checkManuallyWithAttendance:(NSString *)attendance_id
                               user:(NSString *)user_id
                            success:(void (^)(Attendance *attendance))success
                            failure:(void (^)(NSError *error))failure;

+ (void)uncheckManuallyWithAttendance:(NSString *)attendance_id
                                 user:(NSString *)user_id
                              success:(void (^)(Attendance *attendance))success
                              failure:(void (^)(NSError *error))failure;

+ (void)toggleManuallyWithAttendance:(NSString *)attendance_id
                                user:(NSString *)user_id
                             success:(void (^)(Attendance *attendance))success
                             failure:(void (^)(NSError *error))failure;

#pragma Clickers APIs
+ (void)clickWithClicker:(NSString *)clicker_id
                  choice:(NSString *)choice_number
                 success:(void (^)(Clicker *clicker))success
                 failure:(void (^)(NSError *error))failure;

#pragma Notices APIs
+ (void)seenWithNotice:(NSString *)notice_id
               success:(void (^)(Notice *notice))success
               failure:(void (^)(NSError *error))failure;

@end
