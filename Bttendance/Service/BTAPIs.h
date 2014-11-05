//
//  BTAPIs.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 2. 11..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;
@class School;
@class Course;
@class Post;
@class Attendance;
@class Clicker;
@class Notice;
@class Email;

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

+ (void)searchUser:(NSString *)searchID
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

+ (void)updateNotiSettingCurious:(BOOL)curious
                        success:(void (^)(User *user))success
                        failure:(void (^)(NSError *error))failure;

#pragma Questions APIs
//+ (void)myQuestionsInSuccess:(void (^)(NSArray *questions))success
//                     failure:(void (^)(NSError *error))failure;
//
//+ (void)createQuestionWithMessage:(NSString *)message
//                   andChoiceCount:(NSString *)choice_count
//                          andTime:(NSString *)progress_time
//                        andSelect:(BOOL)show_info_on_select
//                       andPrivacy:(NSString *)detail_privacy
//                          success:(void (^)(Question *question))success
//                          failure:(void (^)(NSError *error))failure;
//
//+ (void)updateQuestion:(NSString *)questionID
//           WithMessage:(NSString *)message
//        andChoiceCount:(NSString *)choice_count
//              andTime:(NSString *)progress_time
//             andSelect:(BOOL)show_info_on_select
//            andPrivacy:(NSString *)detail_privacy
//               success:(void (^)(Question *question))success
//               failure:(void (^)(NSError *error))failure;
//
//+ (void)removeQuestionWithId:(NSString *)questionID
//                     success:(void (^)(Question *question))success
//                     failure:(void (^)(NSError *error))failure;

#pragma Identifications APIs
+ (void)updateIdentityWithSchool:(NSString *)schoolID
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

+ (void)enrollSchool:(NSString *)schoolID
            identity:(NSString *)identity
             success:(void (^)(User *user))success
             failure:(void (^)(NSError *error))failure;

#pragma Courses APIs
+ (void)courseInfo:(NSString *)courseID
           success:(void (^)(Course *course))success
           failure:(void (^)(NSError *error))failure;

+ (void)createCourseInstantWithName:(NSString *)name
                             school:(NSString *)schoolID
                      professorName:(NSString *)professor_name
                            success:(void (^)(User *user))success
                            failure:(void (^)(NSError *error))failure;

+ (void)searchCourseWithCode:(NSString *)course_code
                        orId:(NSString *)courseID
                     success:(void (^)(Course *course))success
                     failure:(void (^)(NSError *error))failure;

+ (void)attendCourse:(NSString *)courseID
             success:(void (^)(User *user))success
             failure:(void (^)(NSError *error))failure;

+ (void)dettendCourse:(NSString *)courseID
              success:(void (^)(User *user))success
              failure:(void (^)(NSError *error))failure;

+ (void)feedForCourse:(NSString *)courseID
             withType:(NSString *)type
              success:(void (^)(NSArray *posts))success
              failure:(void (^)(NSError *error))failure;

+ (void)openCourse:(NSString *)courseID
           success:(void (^)(User *user))success
           failure:(void (^)(NSError *error))failure;

+ (void)closeCourse:(NSString *)courseID
            success:(void (^)(User *user))success
            failure:(void (^)(NSError *error))failure;

+ (void)addManagerWithCourse:(NSString *)courseID
                     manager:(NSString *)manager
                     success:(void (^)(Course *course))success
                     failure:(void (^)(NSError *error))failure;

+ (void)studentsForCourse:(NSString *)courseID
                  success:(void (^)(NSArray *simpleUsers))success
                  failure:(void (^)(NSError *error))failure;

+ (void)attendanceGradesWithCourse:(NSString *)courseID
                           success:(void (^)(NSArray *simpleUsers))success
                           failure:(void (^)(NSError *error))failure;

+ (void)clickerGradesWithCourse:(NSString *)courseID
                        success:(void (^)(NSArray *simpleUsers))success
                        failure:(void (^)(NSError *error))failure;

+ (void)exportGradesWithCourse:(NSString *)courseID
                       success:(void (^)(Email *email))success
                       failure:(void (^)(NSError *error))failure;

#pragma Posts APIs
+ (void)startAttendanceWithCourse:(NSString *)courseID
                          andType:(NSString *)type
                          success:(void (^)(Post *post))success
                          failure:(void (^)(NSError *error))failure;

+ (void)startClickerWithCourse:(NSString *)courseID
                       message:(NSString *)message
                   choiceCount:(NSString *)choice_count
                       andTime:(NSString *)progress_time
                     andSelect:(BOOL)show_info_on_select
                    andPrivacy:(NSString *)detail_privacy
                       success:(void (^)(Post *post))success
                       failure:(void (^)(NSError *error))failure;

+ (void)createNoticeWithCourse:(NSString *)courseID
                       message:(NSString *)message
                       success:(void (^)(Post *post))success
                       failure:(void (^)(NSError *error))failure;

+ (void)updateMessageOfPost:(NSString *)postID
                withMessage:(NSString *)message
                    success:(void (^)(Post *post))success
                    failure:(void (^)(NSError *error))failure;

+ (void)removePost:(NSString *)postID
           success:(void (^)(Post *post))success
           failure:(void (^)(NSError *error))failure;

#pragma Attendances APIs
+ (void)fromCoursesWithCourses:(NSArray *)courseIDs
                       success:(void (^)(NSArray *attendanceIDs))success
                       failure:(void (^)(NSError *error))failure;

+ (void)foundDeviceWithAttendance:(NSString *)attendanceID
                             uuid:(NSString *)uuid
                          success:(void (^)(Attendance *attendance))success
                          failure:(void (^)(NSError *error))failure;

+ (void)toggleManuallyWithAttendance:(NSString *)attendanceID
                                user:(NSString *)userID
                             success:(void (^)(Attendance *attendance))success
                             failure:(void (^)(NSError *error))failure;

#pragma Clickers APIs
+ (void)clickWithClicker:(NSString *)clickerID
                  choice:(NSString *)choice_number
                 success:(void (^)(Clicker *clicker))success
                 failure:(void (^)(NSError *error))failure;

#pragma Notices APIs
+ (void)seenWithNotice:(NSString *)noticeID
               success:(void (^)(Notice *notice))success
               failure:(void (^)(NSError *error))failure;

@end
