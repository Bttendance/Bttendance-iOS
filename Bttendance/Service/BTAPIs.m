//
//  BTAPIs.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 2. 11..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTAPIs.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import "AFNetworkActivityLogger.h"
#import "AFResponseSerializer.h"
#import "BTUserDefault.h"
#import "BTDatabase.h"
#import "BTUUID.h"

#import "Error.h"
#import "Email.h"

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

#import "CatchPointViewController.h"
#import "AppDelegate.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "UIColor+Bttendance.h"
#import "SocketAgent.h"

@implementation BTAPIs

static UIAlertView *Ooooppss;

+ (AFHTTPRequestOperationManager *)sharedAFManager
{
	static AFHTTPRequestOperationManager *manager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		manager = [AFHTTPRequestOperationManager manager];
		manager.responseSerializer = [AFResponseSerializer serializer];
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
#ifdef DEBUG
        [[AFNetworkActivityLogger sharedLogger] startLogging];
        [[AFNetworkActivityLogger sharedLogger] setLevel:AFLoggerLevelDebug];
#endif
	});
	return manager;
}

+ (void)failureHandleWithError:(NSError *)error {
    
    //401 : Auto Sign Out
    //441 : Update Recommended
    //442 : Update Required
    
    NSInteger statusCode = [[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
    Error *errorJson = [[Error alloc] initWithObject:[[error userInfo] objectForKey:AFResponseSerializerKey]];
    
    if (statusCode == 441) {
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:errorJson.title
                                           message:errorJson.message
                                          delegate:self
                                 cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                 otherButtonTitles:NSLocalizedString(@"Confirm", nil), nil];
        alert.tag = statusCode;
        [alert show];
    } else if (statusCode == 503) {
        if (Ooooppss == nil) {
            NSString *message = NSLocalizedString(@"Too many users are connecting at the same time, please try again later.", nil);
            Ooooppss = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Ooooppss!", nil)
                                               message:message
                                              delegate:self
                                     cancelButtonTitle:nil
                                     otherButtonTitles:NSLocalizedString(@"Confirm", nil), nil];
            Ooooppss.tag = statusCode;
        }
        
        if (!Ooooppss.visible)
            [Ooooppss show];
    } else {
        switch ([errorJson getErrorType]) {
            case ErrorType_Alert: {
                UIAlertView *alert;
                alert = [[UIAlertView alloc] initWithTitle:errorJson.title
                                                   message:errorJson.message
                                                  delegate:self
                                         cancelButtonTitle:nil
                                         otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
                alert.tag = statusCode;
                [alert show];
                break;
            }
            case ErrorType_Toast: {
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:appDelegate.topController.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.color = [UIColor cyan:0.7];
                hud.detailsLabelText = errorJson.message;
                hud.detailsLabelFont = [UIFont boldSystemFontOfSize:14.0f];
                hud.yOffset = - appDelegate.topController.view.frame.size.height / 2 + 104;
                hud.margin = 14.0f;
                [hud hide:YES afterDelay:1.5];
                break;
            }
            default:
            case ErrorType_Log:
                NSLog(@"Error : %@", errorJson.message);
                break;
        }
    }
}

#pragma UIAlertViewDelegate
+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 401) {
        [BTUserDefault clear];
        CatchPointViewController *catchView = [[CatchPointViewController alloc] initWithNibName:@"CatchPointViewController" bundle:nil];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.topController presentViewController:[[UINavigationController alloc] initWithRootViewController:catchView] animated:NO completion:nil];
    }
    
    if (alertView.tag == 442 || (alertView.tag == 441 && buttonIndex == 1)) {
        NSString *iTunesLink = @"https://itunes.apple.com/us/app/apple-store/id829410376?mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
    }
}

#pragma Users APIs
+ (void)signUpWithFullName:(NSString *)full_name
                     email:(NSString *)email
                  password:(NSString *)password
                   success:(void (^)(User *user))success
                   failure:(void (^)(NSError *error))failure {
    
    NSString *uuid = [BTUUID representativeString:[BTUUID getUserService].UUID];
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"full_name" : full_name,
                             @"email" : email,
                             @"password" : password,
                             @"device_type" : @"iphone",
                             @"device_uuid" : uuid,
                             @"locale" : locale};
    
    [[self sharedAFManager] POST:[BTURL stringByAppendingString:@"/users/signup"]
                      parameters:params
                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                             [BTDatabase updateUser:responseObject
                                           withData:^(User *user) {
                                               if (success != nil)
                                                   success(user);
                                           }];
                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                             [self failureHandleWithError:error];
                             if (failure != nil)
                                failure(error);
                         }];
}

+ (void)autoSignInInSuccess:(void (^)(User *user))success
                    failure:(void (^)(NSError *error))failure {
    
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"device_uuid" : [BTUserDefault getUUID],
                             @"device_type" : @"iphone",
                             @"app_version" : appVersion};
    
    [[self sharedAFManager] GET:[BTURL stringByAppendingString:@"/users/auto/signin"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [BTDatabase updateUser:responseObject
                                          withData:^(User *user) {
                                              if (success != nil)
                                                  success(user);
                                          }];
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            if (failure != nil)
                                failure(error);
                        }];
}

+ (void)signInWithEmail:(NSString *)email
               password:(NSString *)password
                success:(void (^)(User *user))success
                failure:(void (^)(NSError *error))failure {
    
    NSString *uuid = [BTUUID representativeString:[BTUUID getUserService].UUID];
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : email,
                             @"password" : password,
                             @"locale" : locale,
                             @"device_uuid" : uuid,
                             @"device_type" : @"iphone"};
    
    [[self sharedAFManager] GET:[BTURL stringByAppendingString:@"/users/signin"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [BTDatabase updateUser:responseObject
                                          withData:^(User *user) {
                                              if (success != nil)
                                                  success(user);
                                          }];
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            if (failure != nil)
                                failure(error);
                        }];
}

+ (void)forgotPasswordWithEmail:(NSString *)email
                        success:(void (^)(Email *email))success
                        failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : email,
                             @"locale" : locale};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/users/forgot/password"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            Email *email = [[Email alloc] initWithObject:responseObject];
                            if (success != nil)
                                success(email);
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            if (failure != nil)
                                failure(error);
                        }];
}

+ (void)updatePasswordWithOldOne:(NSString *)password_old
                          newOne:(NSString *)password_new
                         success:(void (^)(User *user))success
                         failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"password_old" : password_old,
                             @"password_new" : password_new};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/users/update/password"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [BTDatabase updateUser:responseObject
                                          withData:^(User *user) {
                                              if (success != nil)
                                                  success(user);
                                          }];
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            if (failure != nil)
                                failure(error);
                        }];
}

+ (void)updateFullName:(NSString *)full_name
               success:(void (^)(User *user))success
               failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"full_name" : full_name};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/users/update/full_name"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [BTDatabase updateUser:responseObject
                                          withData:^(User *user) {
                                              if (success != nil)
                                                  success(user);
                                          }];
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            if (failure != nil)
                                failure(error);
                        }];
}

+ (void)updateEmail:(NSString *)email_new
            success:(void (^)(User *user))success
            failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"email_new" : email_new};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/users/update/email"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [BTDatabase updateUser:responseObject
                                          withData:^(User *user) {
                                              if (success != nil)
                                                  success(user);
                                          }];
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            if (failure != nil)
                                failure(error);
                        }];
}

+ (void)searchUser:(NSString *)searchID
           success:(void (^)(User *user))success
           failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"searchID" : searchID};
    
    [[self sharedAFManager] GET:[BTURL stringByAppendingString:@"/users/search"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            User *user = [[User alloc] initWithObject:responseObject];
                            if (success != nil)
                                success(user);
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            if (failure != nil)
                                failure(error);
                        }];
}

+ (void)coursesInSuccess:(void (^)(NSArray *courses))success
                 failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale};
    
    [[self sharedAFManager] GET:[BTURL stringByAppendingString:@"/users/courses"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [BTDatabase updateCourses:responseObject withData:^(NSArray *courses) {
                                if (success != nil)
                                    success(courses);
                            }];
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            if (failure != nil)
                                failure(error);
                        }];
}

#pragma Devices APIs
+ (void)updateNotificationKey:(NSString *)notification_key
                      success:(void (^)(User *user))success
                      failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"device_uuid" : [BTUserDefault getUUID],
                             @"notification_key" : notification_key};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/devices/update/notification_key"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [BTDatabase updateUser:responseObject
                                          withData:^(User *user) {
                                              if (success != nil)
                                                  success(user);
                                          }];
                        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            if (failure != nil)
                                failure(error);
                        }];
}

#pragma Settings APIs
+ (void)updateNotiSettingAttendance:(BOOL)attendance
                            success:(void (^)(User *user))success
                            failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"attendance" : (attendance) ? @"true" : @"false"};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/settings/update/attendance"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [BTDatabase updateUser:responseObject
                                          withData:^(User *user) {
                                              if (success != nil)
                                                  success(user);
                                          }];
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            if (failure != nil)
                                failure(error);
                        }];
}

+ (void)updateNotiSettingClicker:(BOOL)clicker
                         success:(void (^)(User *user))success
                         failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"clicker" : (clicker) ? @"true" : @"false"};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/settings/update/clicker"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [BTDatabase updateUser:responseObject
                                          withData:^(User *user) {
                                              if (success != nil)
                                                  success(user);
                                          }];
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            if (failure != nil)
                                failure(error);
                        }];
}

+ (void)updateNotiSettingNotice:(BOOL)notice
                        success:(void (^)(User *user))success
                        failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"notice" : (notice) ? @"true" : @"false"};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/settings/update/notice"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [BTDatabase updateUser:responseObject
                                          withData:^(User *user) {
                                              if (success != nil)
                                                  success(user);
                                          }];
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            if (failure != nil)
                                failure(error);
                        }];
}

+ (void)updateNotiSettingCurious:(BOOL)curious
                        success:(void (^)(User *user))success
                        failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"curious" : (curious) ? @"true" : @"false"};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/settings/update/curious"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [BTDatabase updateUser:responseObject
                                          withData:^(User *user) {
                                              if (success != nil)
                                                  success(user);
                                          }];
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            if (failure != nil)
                                failure(error);
                        }];
}

#pragma Questions APIs
//+ (void)myQuestionsInSuccess:(void (^)(NSArray *questions))success
//                     failure:(void (^)(NSError *error))failure {
//    
//    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
//    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
//                             @"password" : [BTUserDefault getPassword],
//                             @"locale" : locale};
//    
//    [[self sharedAFManager] GET:[BTURL stringByAppendingString:@"/questions/mine"]
//                        parameters:params
//                           success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                               [BTUserDefault setQuestions:responseObject];
//                               NSMutableArray *questions = [NSMutableArray array];
//                               for (NSDictionary *dic in responseObject) {
//                                   Question *question = [[Question alloc] initWithDictionary:dic];
//                                   [questions addObject:question];
//                               }
//                               success(questions);
//                           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                               [self failureHandleWithError:error];
//                               if (failure != nil)
//                                    failure(error);
//                           }];
//    
//}
//
//+ (void)createQuestionWithMessage:(NSString *)message
//                   andChoiceCount:(NSString *)choice_count
//                          andTime:(NSString *)progress_time
//                        andSelect:(BOOL)show_info_on_select
//                       andPrivacy:(NSString *)detail_privacy
//                          success:(void (^)(Question *question))success
//                          failure:(void (^)(NSError *error))failure {
//    
//    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
//    if (detail_privacy == nil)
//        detail_privacy = @"professor";
//    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
//                             @"password" : [BTUserDefault getPassword],
//                             @"locale" : locale,
//                             @"message" : message,
//                             @"choice_count" : choice_count,
//                             @"progress_time" : progress_time,
//                             @"show_info_on_select" : (show_info_on_select) ? @"true" : @"false",
//                             @"detail_privacy" : detail_privacy};
//    
//    [[self sharedAFManager] POST:[BTURL stringByAppendingString:@"/questions/create"]
//                      parameters:params
//                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                             Question *question = [[Question alloc] initWithDictionary:responseObject];
//                             success(question);
//                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                             [self failureHandleWithError:error];
//                             if (failure != nil)
//                                failure(error);
//                         }];
//}
//
//+ (void)updateQuestion:(NSString *)questionID
//           WithMessage:(NSString *)message
//        andChoiceCount:(NSString *)choice_count
//               andTime:(NSString *)progress_time
//             andSelect:(BOOL)show_info_on_select
//            andPrivacy:(NSString *)detail_privacy
//               success:(void (^)(Question *question))success
//               failure:(void (^)(NSError *error))failure {
//    
//    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
//    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
//                             @"password" : [BTUserDefault getPassword],
//                             @"locale" : locale,
//                             @"questionID" : questionID,
//                             @"message" : message,
//                             @"choice_count" : choice_count,
//                             @"progress_time" : progress_time,
//                             @"show_info_on_select" : (show_info_on_select) ? @"true" : @"false",
//                             @"detail_privacy" : detail_privacy};
//    
//    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/questions/edit"]
//                      parameters:params
//                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                             Question *question = [[Question alloc] initWithDictionary:responseObject];
//                             success(question);
//                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                             [self failureHandleWithError:error];
//                             if (failure != nil)
//                                failure(error);
//                         }];
//}
//
//+ (void)removeQuestionWithId:(NSString *)questionID
//                     success:(void (^)(Question *question))success
//                     failure:(void (^)(NSError *error))failure {
//    
//    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
//    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
//                             @"password" : [BTUserDefault getPassword],
//                             @"locale" : locale,
//                             @"questionID" : questionID};
//    
//    [[self sharedAFManager] DELETE:[BTURL stringByAppendingString:@"/questions/remove"]
//                     parameters:params
//                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                            Question *question = [[Question alloc] initWithDictionary:responseObject];
//                            success(question);
//                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                            [self failureHandleWithError:error];
//                            if (failure != nil)
//                                failure(error);
//                        }];
//}

#pragma Identifications APIs
+ (void)updateIdentityWithSchool:(NSString *)schoolID
                        identity:(NSString *)identity
                         success:(void (^)(User *user))success
                         failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"schoolID" : schoolID,
                             @"identity" : identity};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/identifications/update/identity"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [BTDatabase updateUser:responseObject
                                          withData:^(User *user) {
                                              if (success != nil)
                                                  success(user);
                                          }];
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            if (failure != nil)
                                failure(error);
                        }];
}

#pragma Schools APIs
+ (void)createSchoolWithName:(NSString *)name
                        type:(NSString *)type
                     success:(void (^)(School *school))success
                     failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"name" : name,
                             @"type" : type};
    
    [[self sharedAFManager] POST:[BTURL stringByAppendingString:@"/schools/create"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [BTDatabase updateSchool:responseObject withData:^(School *school) {
                                if (success != nil)
                                    success(school);
                            }];
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            if (failure != nil)
                                failure(error);
                        }];
    
}

+ (void)allSchoolsAtSuccess:(void (^)(NSArray *schools))success
                    failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale};
    
    [[self sharedAFManager] GET:[BTURL stringByAppendingString:@"/schools/all"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [BTDatabase updateSchools:responseObject withData:^(NSArray *schools) {
                                if (success != nil)
                                    success(schools);
                            }];
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            if (failure != nil)
                                failure(error);
                        }];
}

+ (void)enrollSchool:(NSString *)schoolID
            identity:(NSString *)identity
             success:(void (^)(User *user))success
             failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"schoolID" : schoolID,
                             @"identity" : identity};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/schools/enroll"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [BTDatabase updateUser:responseObject
                                          withData:^(User *user) {
                                              if (success != nil)
                                                  success(user);
                                          }];
                        } failure:^(AFHTTPRequestOperation *opration, NSError *error) {
                            [self failureHandleWithError:error];
                            if (failure != nil)
                                failure(error);
                        }];
}

#pragma Courses APIs
+ (void)courseInfo:(NSString *)courseID
           success:(void (^)(Course *course))success
           failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"courseID" : courseID,
                             @"locale" : locale};
    
    [[self sharedAFManager] GET:[BTURL stringByAppendingString:@"/courses/info"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [BTDatabase updateCourse:responseObject
                                            withData:^(Course *course) {
                                                if (success == nil)
                                                    return;
                                            }];
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            if (failure != nil)
                                failure(error);
                        }];
}

+ (void)createCourseInstantWithName:(NSString *)name
                             school:(NSString *)schoolID
                      professorName:(NSString *)professor_name
                            success:(void (^)(User *user))success
                            failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"name" : name,
                             @"schoolID" : schoolID,
                             @"professor_name" : professor_name};
    
    [[self sharedAFManager] POST:[BTURL stringByAppendingString:@"/courses/create/instant"]
                      parameters:params
                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                             [self coursesInSuccess:nil failure:nil];
                             [[SocketAgent sharedInstance] socketConnectToServer];
                             
                             [BTDatabase updateUser:responseObject
                                           withData:^(User *user) {
                                               if (success != nil)
                                                   success(user);
                                           }];
                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                             [self failureHandleWithError:error];
                             if (failure != nil)
                                failure(error);
                         }];
}

+ (void)searchCourseWithCode:(NSString *)course_code
                        orId:(NSString *)courseID
                     success:(void (^)(Course *course))success
                     failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"course_code" : course_code,
                             @"courseID" : courseID};
    
    [[self sharedAFManager] GET:[BTURL stringByAppendingString:@"/courses/search"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            Course *course = [[Course alloc] initWithObject:responseObject];
                            success(course);
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            if (failure != nil)
                                failure(error);
                        }];
    
}

+ (void)attendCourse:(NSString *)courseID
             success:(void (^)(User *user))success
             failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"courseID" : courseID};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/courses/attend"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [self coursesInSuccess:nil failure:nil];
                            [[SocketAgent sharedInstance] socketConnectToServer];
                            
                            [BTDatabase updateUser:responseObject
                                          withData:^(User *user) {
                                              if (success != nil)
                                                  success(user);
                                          }];
                        } failure:^(AFHTTPRequestOperation *opration, NSError *error) {
                            [self failureHandleWithError:error];
                            if (failure != nil)
                                failure(error);
                        }];
}

+ (void)dettendCourse:(NSString *)courseID
              success:(void (^)(User *user))success
              failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"courseID" : courseID};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/courses/dettend"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [self coursesInSuccess:nil failure:nil];
                            [[SocketAgent sharedInstance] socketConnectToServer];
                            
                            [BTDatabase updateUser:responseObject
                                          withData:^(User *user) {
                                              if (success != nil)
                                                  success(user);
                                          }];
                        } failure:^(AFHTTPRequestOperation *opration, NSError *error) {
                            [self failureHandleWithError:error];
                            if (failure != nil)
                                failure(error);
                        }];
    
}

+ (void)feedForCourse:(NSString *)courseID
             withType:(NSString *)type
              success:(void (^)(NSArray *posts))success
              failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"courseID" : courseID};
    
    [[self sharedAFManager] GET:[BTURL stringByAppendingString:@"/courses/feed"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [BTDatabase updatePosts:responseObject
                                         ofCourseID:[courseID integerValue]
                                           withType:type
                                           withData:^(NSArray *posts) {
                                               if (success != nil)
                                                   success(posts);
                                           }];
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            if (failure != nil)
                                failure(error);
                        }];
}

+ (void)openCourse:(NSString *)courseID
           success:(void (^)(User *user))success
           failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"courseID" : courseID};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/courses/open"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [BTDatabase updateUser:responseObject
                                          withData:^(User *user) {
                                              if (success != nil)
                                                  success(user);
                                          }];
                        } failure:^(AFHTTPRequestOperation *opration, NSError *error) {
                            [self failureHandleWithError:error];
                            if (failure != nil)
                                failure(error);
                        }];
}

+ (void)closeCourse:(NSString *)courseID
            success:(void (^)(User *user))success
            failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"courseID" : courseID};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/courses/close"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [BTDatabase updateUser:responseObject
                                          withData:^(User *user) {
                                              if (success != nil)
                                                  success(user);
                                          }];
                        } failure:^(AFHTTPRequestOperation *opration, NSError *error) {
                            [self failureHandleWithError:error];
                            if (failure != nil)
                                failure(error);
                        }];
}

+ (void)addManagerWithCourse:(NSString *)courseID
                     manager:(NSString *)manager
                     success:(void (^)(Course *course))success
                     failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"courseID" : courseID,
                             @"manager" : manager};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/courses/add/manager"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            Course *course = [[Course alloc] initWithObject:responseObject];
                            if (success != nil)
                                success(course);
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            if (failure != nil)
                                failure(error);
                        }];
}

+ (void)studentsForCourse:(NSString *)courseID
                  success:(void (^)(NSArray *simpleUsers))success
                  failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"courseID" : courseID};
    
    [[self sharedAFManager] GET:[BTURL stringByAppendingString:@"/courses/students"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [BTDatabase updateStudents:responseObject
                                            ofCourseID:[courseID integerValue]
                                              withData:^(NSArray *students) {
                                                  if (success != nil)
                                                      success(students);
                                              }];
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            if (failure != nil)
                                failure(error);
                        }];
}

+ (void)attendanceGradesWithCourse:(NSString *)courseID
                           success:(void (^)(NSArray *simpleUsers))success
                           failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"courseID" : courseID};
    
    [[self sharedAFManager] GET:[BTURL stringByAppendingString:@"/courses/attendance/grades"]
                     parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         [BTDatabase updateAttendanceRecords:responseObject
                                                  ofCourseID:[courseID integerValue]
                                                    withData:^(NSArray *students) {
                                                        if (success != nil)
                                                            success(students);
                                                    }];
                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         [self failureHandleWithError:error];
                         if (failure != nil)
                             failure(error);
                     }];
}

+ (void)clickerGradesWithCourse:(NSString *)courseID
                        success:(void (^)(NSArray *simpleUsers))success
                        failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"courseID" : courseID};
    
    [[self sharedAFManager] GET:[BTURL stringByAppendingString:@"/courses/clicker/grades"]
                     parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         [BTDatabase updateClickerRecords:responseObject
                                               ofCourseID:[courseID integerValue]
                                                 withData:^(NSArray *students) {
                                                     if (success != nil)
                                                         success(students);
                                                 }];
                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         [self failureHandleWithError:error];
                         if (failure != nil)
                             failure(error);
                     }];
}

+ (void)exportGradesWithCourse:(NSString *)courseID
                       success:(void (^)(Email *email))success
                       failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"courseID" : courseID};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/courses/export/grades"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            Email *email = [[Email alloc] initWithObject:responseObject];
                            if (success != nil)
                                success(email);
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            if (failure != nil)
                                failure(error);
                        }];
}

#pragma Posts APIs
+ (void)startAttendanceWithCourse:(NSString *)courseID
                          andType:(NSString *)type
                          success:(void (^)(Post *post))success
                          failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"courseID" : courseID,
                             @"type" : type};
    
    [[self sharedAFManager] POST:[BTURL stringByAppendingString:@"/posts/start/attendance"]
                      parameters:params
                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                             [BTDatabase updatePost:responseObject
                                           withData:^(Post *post) {
                                               if (success != nil)
                                                   success(post);
                                           }];
                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                             [self failureHandleWithError:error];
                             if (failure != nil)
                                failure(error);
                         }];
    
}

+ (void)startClickerWithCourse:(NSString *)courseID
                       message:(NSString *)message
                   choiceCount:(NSString *)choice_count
                       andTime:(NSString *)progress_time
                     andSelect:(BOOL)show_info_on_select
                    andPrivacy:(NSString *)detail_privacy
                       success:(void (^)(Post *post))success
                       failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    if (detail_privacy == nil)
        detail_privacy = @"professor";
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"courseID" : courseID,
                             @"message" : message,
                             @"choice_count" : choice_count,
                             @"progress_time" : progress_time,
                             @"show_info_on_select" : (show_info_on_select) ? @"true" : @"false",
                             @"detail_privacy" : detail_privacy};
    
    [[self sharedAFManager] POST:[BTURL stringByAppendingString:@"/posts/start/clicker"]
                      parameters:params
                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                             [BTDatabase updatePost:responseObject
                                           withData:^(Post *post) {
                                               if (success != nil)
                                                   success(post);
                                           }];
                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                             [self failureHandleWithError:error];
                             if (failure != nil)
                                failure(error);
                         }];    
}

+ (void)createNoticeWithCourse:(NSString *)courseID
                      message:(NSString *)message
                      success:(void (^)(Post *post))success
                      failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"courseID" : courseID,
                             @"message" : message};
    
    [[self sharedAFManager] POST:[BTURL stringByAppendingString:@"/posts/create/notice"]
                      parameters:params
                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                             [BTDatabase updatePost:responseObject
                                           withData:^(Post *post) {
                                               if (success != nil)
                                                   success(post);
                                           }];
                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                             [self failureHandleWithError:error];
                             if (failure != nil)
                                failure(error);
                         }];
}

+ (void)updateMessageOfPost:(NSString *)postID
                withMessage:(NSString *)message
                    success:(void (^)(Post *post))success
                    failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"postID" : postID,
                             @"message" : message};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/posts/update/message"]
                      parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [BTDatabase updatePost:responseObject
                                          withData:^(Post *post) {
                                              if (success != nil)
                                                  success(post);
                                          }];
                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                             [self failureHandleWithError:error];
                             if (failure != nil)
                                failure(error);
                         }];
}

+ (void)removePost:(NSString *)postID
           success:(void (^)(Post *post))success
           failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"postID" : postID};
    
    [[self sharedAFManager] DELETE:[BTURL stringByAppendingString:@"/posts/remove"]
                      parameters:params
                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                             [BTDatabase deletePost:responseObject
                                           withData:^(Post *post) {
                                               if (success != nil)
                                                   success(post);
                                           }];
                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                             [self failureHandleWithError:error];
                             if (failure != nil)
                                failure(error);
                         }];
}

#pragma Attendances APIs
+ (void)fromCoursesWithCourses:(NSArray *)courseIDs
                       success:(void (^)(NSArray *attendanceIDs))success
                       failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[BTUserDefault getEmail] forKey:@"email"];
    [params setObject:[BTUserDefault getPassword] forKey:@"password"];
    [params setObject:locale forKey:@"locale"];
    for (int i = 0; i < courseIDs.count; i++)
        [params setObject:[NSString stringWithFormat:@"%@", courseIDs[i]] forKey:@"courseIDs"];
    
    [[self sharedAFManager] GET:[BTURL stringByAppendingString:@"/attendances/from/courses"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            success(responseObject);
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            if (failure != nil)
                                failure(error);
                        }];
}

+ (void)foundDeviceWithAttendance:(NSString *)attendanceID
                             uuid:(NSString *)uuid
                          success:(void (^)(Attendance *attendance))success
                          failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"attendanceID" : attendanceID,
                             @"uuid" : uuid};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/attendances/found/device"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            Attendance *attendance = [[Attendance alloc] initWithObject:responseObject];
                            success(attendance);
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            if (failure != nil)
                                failure(error);
                        }];
}

+ (void)toggleManuallyWithAttendance:(NSString *)attendanceID
                                user:(NSString *)userID
                             success:(void (^)(Attendance *attendance))success
                             failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"attendanceID" : attendanceID,
                             @"userID" : userID};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/attendances/toggle/manually"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            Attendance *attendance = [[Attendance alloc] initWithObject:responseObject];
                            success(attendance);
                        } failure:^(AFHTTPRequestOperation *opration, NSError *error) {
                            [self failureHandleWithError:error];
                            if (failure != nil)
                                failure(error);
                        }];
}

#pragma Clickers APIs
+ (void)clickWithClicker:(NSString *)clickerID
                  choice:(NSString *)choice_number
                 success:(void (^)(Clicker *clicker))success
                 failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"clickerID" : clickerID,
                             @"choice_number" : choice_number};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/clickers/click"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            Clicker *clicker = [[Clicker alloc] initWithObject:responseObject];
                            success(clicker);
                        } failure:^(AFHTTPRequestOperation *opration, NSError *error) {
                            [self failureHandleWithError:error];
                            if (failure != nil)
                                failure(error);
                        }];
}

#pragma Notices APIs
+ (void)seenWithNotice:(NSString *)noticeID
               success:(void (^)(Notice *notice))success
               failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"noticeID" : noticeID};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/notices/seen"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            Notice *notice = [[Notice alloc] initWithObject:responseObject];
                            success(notice);
                        } failure:^(AFHTTPRequestOperation *opration, NSError *error) {
                            [self failureHandleWithError:error];
                            if (failure != nil)
                                failure(error);
                        }];
}

@end
