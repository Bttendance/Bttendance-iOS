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

@interface BTAPIs : NSObject

+ (void)SignUpWithFullName:(NSString *)full_name
                  username:(NSString *)username
                  password:(NSString *)password
                deviceType:(NSString *)device_type
                deviceUUID:(NSString *)device_uuid
                   success:(void (^)(User *user))success;

+ (void)AutoSignInWithAppVersion:(NSString *)app_version
                         success:(void (^)(User *user))success;

+ (void)SignInWithUsername:(NSString *)username
                  password:(NSString *)password
                deviceUUID:(NSString *)device_uuid
                   success:(void (^)(User *user))success;

+ (void)ForgotPasswordWithEmail:(NSString *)email
                        success:(void (^)(Email *email))success;

+ (void)UpdateProfileImage:(NSString *)profile_image
                   success:(void (^)(User *user))success;

+ (void)UpdateFullName:(NSString *)full_name
               success:(void (^)(User *user))success;

+ (void)UpdateEmail:(NSString *)email
            success:(void (^)(User *user))success;

+ (void)FeedWithPage:(NSInteger)page
             success:(void (^)(NSArray *posts))success;

+ (void)CoursesAtSuccess:(void (^)(NSArray *courses))success;

+ (void)SearchUser:(NSString *)search_id
           success:(void (^)(User *user))success;

+ (void)UpdateNotificationKey:(NSString *)notification_key
                      success:(void (^)(User *user))success;

+ (void)AllSchoolsAtSuccess:(void (^)(NSArray *schools))success;

+ (void)CoursesForSchool:(NSString *)school_id
                 success:(void (^)(NSArray *courses))success;

+ (void)EmploySchool:(NSString *)school_id
              serial:(NSString *)serial
             success:(void (^)(User *user))success;

+ (void)EnrollSchool:(NSString *)school_id
            identity:(NSString *)student_id
             success:(void (^)(User *user))success;

+ (void)CreateCourseWitheName:(NSString *)name
                       number:(NSString *)number
                       school:(NSString *)school_id
                professorName:(NSString *)professor_name
                      success:(void (^)(Email *email))success;

+ (void)AttendCourse:(NSString *)course_id
             success:(void (^)(User *user))success;

+ (void)DettendCourse:(NSString *)course_id
              success:(void (^)(User *user))success;

+ (void)FeedForCourse:(NSString *)course_id
                 page:(NSInteger)page
              success:(void (^)(NSArray *posts))success;

+ (void)StudentsForCourse:(NSString *)course_id
                  success:(void (^)(NSArray *users))success;

+ (void)AddManagerWithCourse:(NSString *)course_id
                     manager:(NSString *)manager
                     success:(void (^)(Course *course))success;

+ (void)GradesWithCourse:(NSString *)course_id
                 success:(void (^)(NSArray *users))success;

+ (void)GradesExportWithCourse:(NSString *)course_id
                       success:(void (^)(Email *email))success;

+ (void)StartAttendanceWithCourse:(NSString *)course_id
                          success:(void (^)(Post *post))success;

+ (void)StartClickerWithCourse:(NSString *)course_id
                       message:(NSString *)message
                       success:(void (^)(Post *post))success;

+ (void)StartNoticeWithCourse:(NSString *)course_id
                      message:(NSString *)message
                      success:(void (^)(Post *post))success;

+ (void)FoundDeviceWithAttendance:(NSString *)attendance_id
                             uuid:(NSString *)uuid
                          success:(void (^)(Attendance *attendance))success;

+ (void)CheckManuallyWithAttendance:(NSString *)attendance_id
                               user:(NSString *)user_id
                            success:(void (^)(Attendance *attendance))success;

+ (void)ConnectWithClicker:(NSString *)clicker_id
                    socker:(NSString *)socket_id
                   success:(void (^)(Clicker *clicker))success;

+ (void)ClickWithClicker:(NSString *)clicker_id
                  choice:(NSString *)choice_number
                 success:(void (^)(Clicker *clicker))success;

@end
