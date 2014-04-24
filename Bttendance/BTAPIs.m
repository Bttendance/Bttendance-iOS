//
//  BTAPIs.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 2. 11..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTAPIs.h"
#import <AFNetworking/AFNetworking.h>
#import "BTUserDefault.h"
#import "BTUUID.h"
#import "AFResponseSerializer.h"
#import "User.h"

@implementation BTAPIs

+ (AFHTTPRequestOperationManager *)sharedAFManager
{
	static AFHTTPRequestOperationManager *manager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		manager = [AFHTTPRequestOperationManager manager];
		manager.responseSerializer = [AFResponseSerializer serializer];
	});
    
	return (manager);
}

+ (void)failureHandleWithError:(NSError *)error {
    
}

+ (void)signUpWithFullName:(NSString *)full_name
                  username:(NSString *)username
                     email:(NSString *)email
                  password:(NSString *)password
                   success:(void (^)(User *user))success {
    
    NSString *uuid = [BTUUID representativeString:[BTUUID getUserService].UUID];
    NSDictionary *params = @{@"username" : username,
                             @"email" : email,
                             @"full_name" : full_name,
                             @"password" : password,
                             @"device_type" : @"iphone",
                             @"device_uuid" : uuid};
    
    [[self sharedAFManager] POST:[BTURL stringByAppendingString:@"/users/signup"]
                      parameters:params
                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                             [self failureHandleWithError:error];
    }];
    
}

+ (void)autoSignInWithAppVersion:(NSString *)app_version
                         success:(void (^)(User *user))success {
    
}

+ (void)signInWithUsername:(NSString *)username
                  password:(NSString *)password
                   success:(void (^)(User *user))success {
    
    NSString *uuid = [BTUUID representativeString:[BTUUID getUserService].UUID];
    NSDictionary *params = @{@"username" : username,
                             @"password" : password,
                             @"device_uuid" : uuid};
    
    [[self sharedAFManager] GET:[BTURL stringByAppendingString:@"/users/signin"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            User *user = [[User alloc] initWithDictionary:responseObject];
                            success(user);
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
    }];
}

+ (void)forgotPasswordWithEmail:(NSString *)email
                        success:(void (^)(Email *email))success {
    
}

+ (void)updateProfileImage:(NSString *)profile_image
                   success:(void (^)(User *user))success {
    
}

+ (void)updateFullName:(NSString *)full_name
               success:(void (^)(User *user))success {
    
}

+ (void)updateEmail:(NSString *)email
            success:(void (^)(User *user))success {
    
}

+ (void)feedWithPage:(NSInteger)page
             success:(void (^)(NSArray *posts))success {
    
}

+ (void)coursesAtSuccess:(void (^)(NSArray *courses))success {
    
}

+ (void)searchUser:(NSString *)search_id
           success:(void (^)(User *user))success {
    
}

+ (void)updateNotificationKey:(NSString *)notification_key
                      success:(void (^)(User *user))success {
    
}

+ (void)allSchoolsAtSuccess:(void (^)(NSArray *schools))success {
    
}

+ (void)coursesForSchool:(NSString *)school_id
                 success:(void (^)(NSArray *courses))success {
    
}

+ (void)employSchool:(NSString *)school_id
              serial:(NSString *)serial
             success:(void (^)(User *user))success {
    
}

+ (void)enrollSchool:(NSString *)school_id
            identity:(NSString *)student_id
             success:(void (^)(User *user))success {
    
}

+ (void)createCourseWitheName:(NSString *)name
                       number:(NSString *)number
                       school:(NSString *)school_id
                professorName:(NSString *)professor_name
                      success:(void (^)(Email *email))success {
    
}

+ (void)attendCourse:(NSString *)course_id
             success:(void (^)(User *user))success {
    
}

+ (void)dettendCourse:(NSString *)course_id
              success:(void (^)(User *user))success {
    
}

+ (void)feedForCourse:(NSString *)course_id
                 page:(NSInteger)page
              success:(void (^)(NSArray *posts))success {
    
}

+ (void)studentsForCourse:(NSString *)course_id
                  success:(void (^)(NSArray *users))success {
    
}

+ (void)addManagerWithCourse:(NSString *)course_id
                     manager:(NSString *)manager
                     success:(void (^)(Course *course))success {
    
}

+ (void)gradesWithCourse:(NSString *)course_id
                 success:(void (^)(NSArray *users))success {
    
}

+ (void)gradesExportWithCourse:(NSString *)course_id
                       success:(void (^)(Email *email))success {
    
}

+ (void)startAttendanceWithCourse:(NSString *)course_id
                          success:(void (^)(Post *post))success {
    
}

+ (void)startClickerWithCourse:(NSString *)course_id
                       message:(NSString *)message
                       success:(void (^)(Post *post))success {
    
}

+ (void)startNoticeWithCourse:(NSString *)course_id
                      message:(NSString *)message
                      success:(void (^)(Post *post))success {
    
}

+ (void)foundDeviceWithAttendance:(NSString *)attendance_id
                             uuid:(NSString *)uuid
                          success:(void (^)(Attendance *attendance))success {
    
}

+ (void)checkManuallyWithAttendance:(NSString *)attendance_id
                               user:(NSString *)user_id
                            success:(void (^)(Attendance *attendance))success {
    
}

+ (void)connectWithClicker:(NSString *)clicker_id
                    socker:(NSString *)socket_id
                   success:(void (^)(Clicker *clicker))success {
    
}

+ (void)clickWithClicker:(NSString *)clicker_id
                  choice:(NSString *)choice_number
                 success:(void (^)(Clicker *clicker))success {
    
}

@end
