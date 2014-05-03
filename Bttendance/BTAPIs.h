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
#import "Email.h"

#ifdef DEBUG
    #define BTURL @"http://bttendance-dev.herokuapp.com/api"
#else
    #define BTURL @"http://www.bttd.co/api"
#endif

@interface BTAPIs : NSObject <UIAlertViewDelegate>

+ (void)signUpWithFullName:(NSString *)full_name
                  username:(NSString *)username
                     email:(NSString *)email
                  password:(NSString *)password
                   success:(void (^)(User *user))success
                   failure:(void (^)(NSError *error))failure;

+ (void)autoSignInInSuccess:(void (^)(User *user))success
                    failure:(void (^)(NSError *error))failure;

+ (void)signInWithUsername:(NSString *)username
                  password:(NSString *)password
                   success:(void (^)(User *user))success
                   failure:(void (^)(NSError *error))failure;

+ (void)forgotPasswordWithEmail:(NSString *)email
                        success:(void (^)(Email *email))success
                        failure:(void (^)(NSError *error))failure;

+ (void)updateProfileImage:(NSString *)profile_image
                   success:(void (^)(User *user))success
                   failure:(void (^)(NSError *error))failure;

+ (void)updateFullName:(NSString *)full_name
               success:(void (^)(User *user))success
               failure:(void (^)(NSError *error))failure;

+ (void)updateEmail:(NSString *)email
            success:(void (^)(User *user))success
            failure:(void (^)(NSError *error))failure;

+ (void)feedWithPage:(NSInteger)page
             success:(void (^)(NSArray *posts))success
             failure:(void (^)(NSError *error))failure;

+ (void)coursesInSuccess:(void (^)(NSArray *courses))success
                 failure:(void (^)(NSError *error))failure;

+ (void)searchUser:(NSString *)search_id
           success:(void (^)(User *user))success
           failure:(void (^)(NSError *error))failure;

+ (void)updateNotificationKey:(NSString *)notification_key
                      success:(void (^)(User *user))success
                      failure:(void (^)(NSError *error))failure;

+ (void)allSchoolsAtSuccess:(void (^)(NSArray *schools))success
                    failure:(void (^)(NSError *error))failure;

+ (void)coursesForSchool:(NSString *)school_id
                 success:(void (^)(NSArray *courses))success
                 failure:(void (^)(NSError *error))failure;

+ (void)enrollSchool:(NSString *)school_id
            identity:(NSString *)student_id
             success:(void (^)(User *user))success
             failure:(void (^)(NSError *error))failure;

+ (void)createCourseRequestWithName:(NSString *)name
                             number:(NSString *)number
                             school:(NSString *)school_id
                      professorName:(NSString *)professor_name
                            success:(void (^)(Email *email))success
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

+ (void)studentsForCourse:(NSString *)course_id
                  success:(void (^)(NSArray *simpleUsers))success
                  failure:(void (^)(NSError *error))failure;

+ (void)addManagerWithCourse:(NSString *)course_id
                     manager:(NSString *)manager
                     success:(void (^)(Course *course))success
                     failure:(void (^)(NSError *error))failure;

+ (void)gradesWithCourse:(NSString *)course_id
                 success:(void (^)(NSArray *simpleUsers))success
                 failure:(void (^)(NSError *error))failure;

+ (void)exportGradesWithCourse:(NSString *)course_id
                       success:(void (^)(Email *email))success
                       failure:(void (^)(NSError *error))failure;

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

+ (void)foundDeviceWithAttendance:(NSString *)attendance_id
                             uuid:(NSString *)uuid
                          success:(void (^)(Attendance *attendance))success
                          failure:(void (^)(NSError *error))failure;

+ (void)checkManuallyWithAttendance:(NSString *)attendance_id
                               user:(NSString *)user_id
                            success:(void (^)(Attendance *attendance))success
                            failure:(void (^)(NSError *error))failure;

+ (void)connectWithClicker:(NSString *)clicker_id
                    socker:(NSString *)socket_id
                   success:(void (^)(Clicker *clicker))success
                   failure:(void (^)(NSError *error))failure;

+ (void)clickWithClicker:(NSString *)clicker_id
                  choice:(NSString *)choice_number
                 success:(void (^)(Clicker *clicker))success
                 failure:(void (^)(NSError *error))failure;

@end
