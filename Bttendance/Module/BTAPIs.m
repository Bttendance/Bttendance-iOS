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
#import "BTUUID.h"
#import "User.h"
#import "Course.h"
#import "School.h"
#import "Post.h"
#import "Attendance.h"
#import "Clicker.h"
#import "Error.h"
#import "Email.h"
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
    Error *errorJson = [[Error alloc] initWithDictionary:[[error userInfo] objectForKey:AFResponseSerializerKey]];
    
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
    } else { //(log, toast, alert)
        if ([errorJson.type isEqualToString:@"log"]) {
            NSLog(@"Error : %@", errorJson.message);
        } else if ([errorJson.type isEqualToString:@"toast"]) {
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:appDelegate.topController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.color = [UIColor cyan:0.7];
            hud.detailsLabelText = errorJson.message;
            hud.detailsLabelFont = [UIFont boldSystemFontOfSize:14.0f];
            hud.yOffset = - appDelegate.topController.view.frame.size.height / 2 + 104;
            hud.margin = 14.0f;
            [hud hide:YES afterDelay:1.5];
        } else if ([errorJson.type isEqualToString:@"alert"]) {
            UIAlertView *alert;
            alert = [[UIAlertView alloc] initWithTitle:errorJson.title
                                               message:errorJson.message
                                              delegate:self
                                     cancelButtonTitle:nil
                                     otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
            alert.tag = statusCode;
            [alert show];
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
                             [BTUserDefault setUser:responseObject];
                             dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                 User *user = [[User alloc] initWithDictionary:responseObject];
                                 dispatch_async( dispatch_get_main_queue(), ^{
                                     success(user);
                                 });
                             });
                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                             [self failureHandleWithError:error];
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
                            [self coursesInSuccess:nil failure:nil];
                            [BTUserDefault setUser:responseObject];
                            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                User *user = [[User alloc] initWithDictionary:responseObject];
                                dispatch_async( dispatch_get_main_queue(), ^{
                                    success(user);
                                });
                            });
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
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
                            [BTUserDefault setUser:responseObject];
                            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                User *user = [[User alloc] initWithDictionary:responseObject];
                                dispatch_async( dispatch_get_main_queue(), ^{
                                    success(user);
                                });
                            });
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
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
                            Email *email = [[Email alloc] initWithDictionary:responseObject];
                            success(email);
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
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
                            [BTUserDefault setUser:responseObject];
                            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                User *user = [[User alloc] initWithDictionary:responseObject];
                                dispatch_async( dispatch_get_main_queue(), ^{
                                    success(user);
                                });
                            });
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
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
                            [BTUserDefault setUser:responseObject];
                            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                User *user = [[User alloc] initWithDictionary:responseObject];
                                dispatch_async( dispatch_get_main_queue(), ^{
                                    success(user);
                                });
                            });
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
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
                            [BTUserDefault setUser:responseObject];
                            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                User *user = [[User alloc] initWithDictionary:responseObject];
                                dispatch_async( dispatch_get_main_queue(), ^{
                                    success(user);
                                });
                            });
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            failure(error);
                        }];
}

+ (void)searchUser:(NSString *)search_id
           success:(void (^)(User *user))success
           failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"search_id" : search_id};
    
    [[self sharedAFManager] GET:[BTURL stringByAppendingString:@"/users/search"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            User *user = [[User alloc] initWithDictionary:responseObject];
                            success(user);
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
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
                            [BTUserDefault setCourses:responseObject];
                            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                NSMutableArray *courses = [NSMutableArray array];
                                for (NSDictionary *dic in responseObject) {
                                    Course *course = [[Course alloc] initWithDictionary:dic];
                                    [courses addObject:course];
                                }
                                dispatch_async( dispatch_get_main_queue(), ^{
                                    if (success != nil) {
                                        success(courses);
                                    }
                                });
                            });
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
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
//                            [BTUserDefault setUser:responseObject];
                            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                User *user = [[User alloc] initWithDictionary:responseObject];
                                dispatch_async( dispatch_get_main_queue(), ^{
                                    success(user);
                                });
                            });
                        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
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
                            [BTUserDefault setUser:responseObject];
                            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                User *user = [[User alloc] initWithDictionary:responseObject];
                                dispatch_async( dispatch_get_main_queue(), ^{
                                    success(user);
                                });
                            });
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
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
                            [BTUserDefault setUser:responseObject];
                            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                User *user = [[User alloc] initWithDictionary:responseObject];
                                dispatch_async( dispatch_get_main_queue(), ^{
                                    success(user);
                                });
                            });
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
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
                            [BTUserDefault setUser:responseObject];
                            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                User *user = [[User alloc] initWithDictionary:responseObject];
                                dispatch_async( dispatch_get_main_queue(), ^{
                                    success(user);
                                });
                            });
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            failure(error);
                        }];
}


+ (void)updateClickerDefaultsWithTime:(NSString *)progress_time
                            andSelect:(BOOL)show_info_on_select
                           andPrivacy:(NSString *)detail_privacy
                              success:(void (^)(User *user))success
                              failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"progress_time" : progress_time,
                             @"notice" : (show_info_on_select) ? @"true" : @"false",
                             @"detail_privacy" : detail_privacy};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/settings/update/clicker/defaults"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [BTUserDefault setUser:responseObject];
                            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                User *user = [[User alloc] initWithDictionary:responseObject];
                                dispatch_async( dispatch_get_main_queue(), ^{
                                    success(user);
                                });
                            });
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            failure(error);
                        }];
}

#pragma Questions APIs
+ (void)myQuestionsInSuccess:(void (^)(NSArray *questions))success
                     failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale};
    
    [[self sharedAFManager] GET:[BTURL stringByAppendingString:@"/questions/mine"]
                        parameters:params
                           success:^(AFHTTPRequestOperation *operation, id responseObject) {
                               [BTUserDefault setQuestions:responseObject];
                               NSMutableArray *questions = [NSMutableArray array];
                               for (NSDictionary *dic in responseObject) {
                                   Question *question = [[Question alloc] initWithDictionary:dic];
                                   [questions addObject:question];
                               }
                               success(questions);
                           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                               [self failureHandleWithError:error];
                               failure(error);
                           }];
    
}

+ (void)createQuestionWithMessage:(NSString *)message
                   andChoiceCount:(NSString *)choice_count
                          andTime:(NSString *)progress_time
                        andSelect:(BOOL)show_info_on_select
                       andPrivacy:(NSString *)detail_privacy
                          success:(void (^)(Question *question))success
                          failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"message" : message,
                             @"choice_count" : choice_count,
                             @"progress_time" : progress_time,
                             @"notice" : (show_info_on_select) ? @"true" : @"false",
                             @"detail_privacy" : detail_privacy};
    
    [[self sharedAFManager] POST:[BTURL stringByAppendingString:@"/questions/create"]
                      parameters:params
                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                             Question *question = [[Question alloc] initWithDictionary:responseObject];
                             success(question);
                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                             [self failureHandleWithError:error];
                             failure(error);
                         }];
}

+ (void)updateQuestion:(NSString *)question_id
           WithMessage:(NSString *)message
        andChoiceCount:(NSString *)choice_count
               andTime:(NSString *)progress_time
             andSelect:(BOOL)show_info_on_select
            andPrivacy:(NSString *)detail_privacy
               success:(void (^)(Question *question))success
               failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"question_id" : question_id,
                             @"message" : message,
                             @"choice_count" : choice_count,
                             @"progress_time" : progress_time,
                             @"notice" : (show_info_on_select) ? @"true" : @"false",
                             @"detail_privacy" : detail_privacy};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/questions/edit"]
                      parameters:params
                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                             Question *question = [[Question alloc] initWithDictionary:responseObject];
                             success(question);
                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                             [self failureHandleWithError:error];
                             failure(error);
                         }];
}

+ (void)removeQuestionWithId:(NSString *)question_id
                     success:(void (^)(Question *question))success
                     failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"question_id" : question_id};
    
    [[self sharedAFManager] DELETE:[BTURL stringByAppendingString:@"/questions/remove"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            Question *question = [[Question alloc] initWithDictionary:responseObject];
                            success(question);
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            failure(error);
                        }];
}

#pragma Identifications APIs
+ (void)updateIdentityWithSchool:(NSString *)school_id
                        identity:(NSString *)identity
                         success:(void (^)(User *user))success
                         failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"school_id" : school_id,
                             @"identity" : identity};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/identifications/update/identity"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [BTUserDefault setUser:responseObject];
                            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                User *user = [[User alloc] initWithDictionary:responseObject];
                                dispatch_async( dispatch_get_main_queue(), ^{
                                    success(user);
                                });
                            });
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
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
                            School *school = [[School alloc] initWithDictionary:responseObject];
                            success(school);
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
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
                            [BTUserDefault setSchools:responseObject];
                            NSMutableArray *schools = [NSMutableArray array];
                            for (NSDictionary *dic in responseObject) {
                                School *school = [[School alloc] initWithDictionary:dic];
                                [schools addObject:school];
                            }
                            success(schools);
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            failure(error);
                        }];
}

+ (void)enrollSchool:(NSString *)school_id
            identity:(NSString *)identity
             success:(void (^)(User *user))success
             failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"school_id" : school_id,
                             @"identity" : identity};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/schools/enroll"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [BTUserDefault setUser:responseObject];
                            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                User *user = [[User alloc] initWithDictionary:responseObject];
                                dispatch_async( dispatch_get_main_queue(), ^{
                                    success(user);
                                });
                            });
                        } failure:^(AFHTTPRequestOperation *opration, NSError *error) {
                            [self failureHandleWithError:error];
                            failure(error);
                        }];
}

#pragma Courses APIs
+ (void)createCourseInstantWithName:(NSString *)name
                             school:(NSString *)school_id
                      professorName:(NSString *)professor_name
                            success:(void (^)(User *user))success
                            failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"name" : name,
                             @"school_id" : school_id,
                             @"professor_name" : professor_name};
    
    [[self sharedAFManager] POST:[BTURL stringByAppendingString:@"/courses/create/instant"]
                      parameters:params
                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                             [self coursesInSuccess:nil failure:nil];
                             [BTUserDefault setUser:responseObject];
                             [[SocketAgent sharedInstance] socketConnectToServer];
                             dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                 User *user = [[User alloc] initWithDictionary:responseObject];
                                 dispatch_async( dispatch_get_main_queue(), ^{
                                     success(user);
                                 });
                             });
                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                             [self failureHandleWithError:error];
                             failure(error);
                         }];
}

+ (void)searchCourseWithCode:(NSString *)course_code
                        orId:(NSString *)course_id
                     success:(void (^)(Course *course))success
                     failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"course_code" : course_code,
                             @"course_id" : course_id};
    
    [[self sharedAFManager] GET:[BTURL stringByAppendingString:@"/courses/search"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            Course *course = [[Course alloc] initWithDictionary:responseObject];
                            success(course);
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            failure(error);
                        }];
    
}

+ (void)attendCourse:(NSString *)course_id
             success:(void (^)(User *user))success
             failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"course_id" : course_id};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/courses/attend"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [self coursesInSuccess:nil failure:nil];
                            [BTUserDefault setUser:responseObject];
                            [[SocketAgent sharedInstance] socketConnectToServer];
                            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                User *user = [[User alloc] initWithDictionary:responseObject];
                                dispatch_async( dispatch_get_main_queue(), ^{
                                    success(user);
                                });
                            });
                        } failure:^(AFHTTPRequestOperation *opration, NSError *error) {
                            [self failureHandleWithError:error];
                            failure(error);
                        }];
}

+ (void)dettendCourse:(NSString *)course_id
              success:(void (^)(User *user))success
              failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"course_id" : course_id};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/courses/dettend"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [self coursesInSuccess:nil failure:nil];
                            [BTUserDefault setUser:responseObject];
                            [[SocketAgent sharedInstance] socketConnectToServer];
                            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                User *user = [[User alloc] initWithDictionary:responseObject];
                                dispatch_async( dispatch_get_main_queue(), ^{
                                    success(user);
                                });
                            });
                        } failure:^(AFHTTPRequestOperation *opration, NSError *error) {
                            [self failureHandleWithError:error];
                            failure(error);
                        }];
    
}

+ (void)feedForCourse:(NSString *)course_id
                 page:(NSInteger)page
              success:(void (^)(NSArray *posts))success
              failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"course_id" : course_id,
                             @"page" : [NSString stringWithFormat: @"%d", (int)page]};
    
    [[self sharedAFManager] GET:[BTURL stringByAppendingString:@"/courses/feed"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [BTUserDefault setPostsArray:responseObject ofCourse:course_id];
                            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                NSMutableArray *posts = [NSMutableArray array];
                                for (NSDictionary *dic in responseObject) {
                                    Post *post = [[Post alloc] initWithDictionary:dic];
                                    [posts addObject:post];
                                }
                                dispatch_async( dispatch_get_main_queue(), ^{
                                    success(posts);
                                });
                            });
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            failure(error);
                        }];
}

+ (void)openCourse:(NSString *)course_id
           success:(void (^)(User *user))success
           failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"course_id" : course_id};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/courses/open"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [BTUserDefault setUser:responseObject];
                            User *user = [[User alloc] initWithDictionary:responseObject];
                            success(user);
                        } failure:^(AFHTTPRequestOperation *opration, NSError *error) {
                            [self failureHandleWithError:error];
                            failure(error);
                        }];
}

+ (void)closeCourse:(NSString *)course_id
            success:(void (^)(User *user))success
            failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"course_id" : course_id};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/courses/close"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [BTUserDefault setUser:responseObject];
                            User *user = [[User alloc] initWithDictionary:responseObject];
                            success(user);
                        } failure:^(AFHTTPRequestOperation *opration, NSError *error) {
                            [self failureHandleWithError:error];
                            failure(error);
                        }];
}

+ (void)addManagerWithCourse:(NSString *)course_id
                     manager:(NSString *)manager
                     success:(void (^)(Course *course))success
                     failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"course_id" : course_id,
                             @"manager" : manager};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/courses/add/manager"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            Course *course = [[Course alloc] initWithDictionary:responseObject];
                            success(course);
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            failure(error);
                        }];
}

+ (void)studentsForCourse:(NSString *)course_id
                  success:(void (^)(NSArray *simpleUsers))success
                  failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"course_id" : course_id};
    
    [[self sharedAFManager] GET:[BTURL stringByAppendingString:@"/courses/students"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [BTUserDefault setStudentsArray:responseObject ofCourse:course_id];
                            NSMutableArray *simpleUsers = [NSMutableArray array];
                            for (NSDictionary *dic in responseObject) {
                                SimpleUser *simpleUser = [[SimpleUser alloc] initWithDictionary:dic];
                                [simpleUsers addObject:simpleUser];
                            }
                            success(simpleUsers);
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            failure(error);
                        }];
}

+ (void)attendanceGradesWithCourse:(NSString *)course_id
                           success:(void (^)(NSArray *simpleUsers))success
                           failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"course_id" : course_id};
    
    [[self sharedAFManager] GET:[BTURL stringByAppendingString:@"/courses/attendance/grades"]
                     parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         NSMutableArray *simpleUsers = [NSMutableArray array];
                         for (NSDictionary *dic in responseObject) {
                             SimpleUser *simpleUser = [[SimpleUser alloc] initWithDictionary:dic];
                             [simpleUsers addObject:simpleUser];
                         }
                         success(simpleUsers);
                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         [self failureHandleWithError:error];
                         failure(error);
                     }];
}

+ (void)clickerGradesWithCourse:(NSString *)course_id
                        success:(void (^)(NSArray *simpleUsers))success
                        failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"course_id" : course_id};
    
    [[self sharedAFManager] GET:[BTURL stringByAppendingString:@"/courses/clicker/grades"]
                     parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         NSMutableArray *simpleUsers = [NSMutableArray array];
                         for (NSDictionary *dic in responseObject) {
                             SimpleUser *simpleUser = [[SimpleUser alloc] initWithDictionary:dic];
                             [simpleUsers addObject:simpleUser];
                         }
                         success(simpleUsers);
                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         [self failureHandleWithError:error];
                         failure(error);
                     }];
}

+ (void)exportGradesWithCourse:(NSString *)course_id
                       success:(void (^)(Email *email))success
                       failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"course_id" : course_id};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/courses/export/grades"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            Email *email = [[Email alloc] initWithDictionary:responseObject];
                            success(email);
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            failure(error);
                        }];
}

#pragma Posts APIs
+ (void)startAttendanceWithCourse:(NSString *)course_id
                          andType:(NSString *)type
                          success:(void (^)(Post *post))success
                          failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"course_id" : course_id,
                             @"type" : type};
    
    [[self sharedAFManager] POST:[BTURL stringByAppendingString:@"/posts/start/attendance"]
                      parameters:params
                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                             Post *post = [[Post alloc] initWithDictionary:responseObject];
                             success(post);
                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                             [self failureHandleWithError:error];
                             failure(error);
                         }];
    
}

+ (void)startClickerWithCourse:(NSString *)course_id
                       message:(NSString *)message
                   choiceCount:(NSString *)choice_count
                       andTime:(NSString *)progress_time
                     andSelect:(BOOL)show_info_on_select
                    andPrivacy:(NSString *)detail_privacy
                       success:(void (^)(Post *post))success
                       failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"course_id" : course_id,
                             @"message" : message,
                             @"choice_count" : choice_count,
                             @"progress_time" : progress_time,
                             @"notice" : (show_info_on_select) ? @"true" : @"false",
                             @"detail_privacy" : detail_privacy};
    
    [[self sharedAFManager] POST:[BTURL stringByAppendingString:@"/posts/start/clicker"]
                      parameters:params
                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                             Post *post = [[Post alloc] initWithDictionary:responseObject];
                             success(post);
                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                             [self failureHandleWithError:error];
                             failure(error);
                         }];    
}

+ (void)createNoticeWithCourse:(NSString *)course_id
                      message:(NSString *)message
                      success:(void (^)(Post *post))success
                      failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"course_id" : course_id,
                             @"message" : message};
    
    [[self sharedAFManager] POST:[BTURL stringByAppendingString:@"/posts/create/notice"]
                      parameters:params
                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                             Post *post = [[Post alloc] initWithDictionary:responseObject];
                             success(post);
                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                             [self failureHandleWithError:error];
                             failure(error);
                         }];
}

+ (void)updateMessageOfPost:(NSString *)post_id
                withMessage:(NSString *)message
                    success:(void (^)(Post *post))success
                    failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"post_id" : post_id,
                             @"message" : message};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/posts/update/message"]
                      parameters:params
                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                             Post *post = [[Post alloc] initWithDictionary:responseObject];
                             success(post);
                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                             [self failureHandleWithError:error];
                             failure(error);
                         }];
}

+ (void)removePost:(NSString *)post_id
           success:(void (^)(Post *post))success
           failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"post_id" : post_id};
    
    [[self sharedAFManager] DELETE:[BTURL stringByAppendingString:@"/posts/remove"]
                      parameters:params
                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                             Post *post = [[Post alloc] initWithDictionary:responseObject];
                             success(post);
                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                             [self failureHandleWithError:error];
                             failure(error);
                         }];
}

#pragma Attendances APIs
+ (void)fromCoursesWithCourses:(NSArray *)course_ids
                       success:(void (^)(NSArray *attendanceIDs))success
                       failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[BTUserDefault getEmail] forKey:@"email"];
    [params setObject:[BTUserDefault getPassword] forKey:@"password"];
    [params setObject:locale forKey:@"locale"];
    for (int i = 0; i < course_ids.count; i++)
        [params setObject:[NSString stringWithFormat:@"%@", course_ids[i]] forKey:@"course_ids"];
    
    [[self sharedAFManager] GET:[BTURL stringByAppendingString:@"/attendances/from/courses"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            success(responseObject);
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            failure(error);
                        }];
}

+ (void)foundDeviceWithAttendance:(NSString *)attendance_id
                             uuid:(NSString *)uuid
                          success:(void (^)(Attendance *attendance))success
                          failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"attendance_id" : attendance_id,
                             @"uuid" : uuid};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/attendances/found/device"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            Attendance *attendance = [[Attendance alloc] initWithDictionary:responseObject];
                            success(attendance);
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            failure(error);
                        }];
}

+ (void)toggleManuallyWithAttendance:(NSString *)attendance_id
                                user:(NSString *)user_id
                             success:(void (^)(Attendance *attendance))success
                             failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"attendance_id" : attendance_id,
                             @"user_id" : user_id};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/attendances/toggle/manually"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            Attendance *attendance = [[Attendance alloc] initWithDictionary:responseObject];
                            success(attendance);
                        } failure:^(AFHTTPRequestOperation *opration, NSError *error) {
                            [self failureHandleWithError:error];
                            failure(error);
                        }];
}

#pragma Clickers APIs
+ (void)clickWithClicker:(NSString *)clicker_id
                  choice:(NSString *)choice_number
                 success:(void (^)(Clicker *clicker))success
                 failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"clicker_id" : clicker_id,
                             @"choice_number" : choice_number};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/clickers/click"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            Clicker *clicker = [[Clicker alloc] initWithDictionary:responseObject];
                            success(clicker);
                        } failure:^(AFHTTPRequestOperation *opration, NSError *error) {
                            [self failureHandleWithError:error];
                            failure(error);
                        }];
}

#pragma Notices APIs
+ (void)seenWithNotice:(NSString *)notice_id
               success:(void (^)(Notice *notice))success
               failure:(void (^)(NSError *error))failure {
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *params = @{@"email" : [BTUserDefault getEmail],
                             @"password" : [BTUserDefault getPassword],
                             @"locale" : locale,
                             @"notice_id" : notice_id};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/notices/seen"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            Notice *notice = [[Notice alloc] initWithDictionary:responseObject];
                            success(notice);
                        } failure:^(AFHTTPRequestOperation *opration, NSError *error) {
                            [self failureHandleWithError:error];
                            failure(error);
                        }];
}

@end
